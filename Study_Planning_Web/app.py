import logging
from flask import Flask, request, jsonify
import mysql.connector
from datetime import datetime, timedelta
import json

app = Flask(__name__)

# Configure Logging
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("py_service.log"),
        logging.StreamHandler()
    ]
)

# Database Configuration (Hardcoded for now based on DBUtil.java)
DB_CONFIG = {
    'host': '127.0.0.1', # Force IPv4
    'port': 3306,        # Explicit port
    'user': 'root',
    'password': '123456',
    'database': 'study_planning_db'
}

def get_db_connection():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except mysql.connector.Error as err:
        logging.error(f"Error connecting to database: {err}")
        return None

# --- Data Fetching Helper Functions ---

def fetch_user_profile(conn, user_id):
    """Fetches MBTI, Work Style, and Learning Style for the user."""
    cursor = conn.cursor(dictionary=True)
    
    profile = {
        'mbti': None,
        'work_style': None,
        'learning_style': None
    }
    
    # Fetch MBTI
    cursor.execute("SELECT * FROM user_mbti_profile WHERE user_id = %s", (user_id,))
    profile['mbti'] = cursor.fetchone()
    
    # Fetch Work Style
    cursor.execute("SELECT * FROM user_work_style WHERE user_id = %s", (user_id,))
    profile['work_style'] = cursor.fetchone()
    
    # Fetch Learning Style
    cursor.execute("SELECT * FROM user_learning_style WHERE user_id = %s", (user_id,))
    profile['learning_style'] = cursor.fetchone()
    
    cursor.close()
    return profile

def fetch_pending_tasks(conn, collection_id):
    """Fetches tasks with status 'pending' strictly for the given collection."""
    cursor = conn.cursor(dictionary=True)
    
    # We filter by collection_id to prevent tasks from OTHER collections (e.g. 'Backlog' or 'Work')
    # from leaking into the current schedule (e.g. 'Study').
    # We allow ALL statuses except 'completed' to catch 'pending', 'in_progress', 'todo', etc.
    query = """
        SELECT DISTINCT t.task_id, t.title, t.description, t.priority, t.duration, t.deadline, us.type, t.status
        FROM tasks t
        JOIN user_schedule us ON t.task_id = us.task_id
        WHERE us.collection_id = %s AND t.status != 'completed'
    """
    
    cursor.execute(query, (collection_id,))
    tasks = cursor.fetchall()
    
    logging.info(f"Fetching tasks for collection_id={collection_id} (excluding completed). Found: {len(tasks)}")
    for t in tasks:
        logging.info(f"   -> Found Task: '{t .get('title')}' [ID: {t.get('task_id')}] Status: {t.get('status')}")

    return tasks

def fetch_existing_schedules(conn, collection_id):
    """
    Fetches existing schedule items that should be treated as BLOCKING constraints.
    We exclude items that are themselves 'Tasks' (have task_id) because we are re-scheduling them.
    We only want to block 'Fixed' items (like manually added Classes, Meetings without task_id).
    """
    cursor = conn.cursor(dictionary=True)
    # Check if 'task_id' column exists effectively by assuming it does (verified via DAO)
    # We assume task_id is NULL or 0 for manual items.
    query = """
        SELECT * FROM user_schedule 
        WHERE collection_id = %s 
    """
    cursor.execute(query, (collection_id,))
    all_schedules = cursor.fetchall()
    
    valid_existing = []
    for s in all_schedules:
        # Only treat as fixed if it has a valid time
        if s.get('start_time'):
            valid_existing.append(s)

    logging.info(f"Collection {collection_id}: Found {len(all_schedules)} items. Treating {len(valid_existing)} valid-time items as FIXED constraints.")
    cursor.close()
    return valid_existing

# --- Smart Scheduling Logic ---

class SmartScheduler:
    def __init__(self, start_time_str, end_time_str, include_weekends, profile, priority_focus='balance'):
        self.start_time = datetime.strptime(start_time_str, "%H:%M").time()
        self.end_time = datetime.strptime(end_time_str, "%H:%M").time()
        self.include_weekends = include_weekends
        self.profile = profile
        self.priority_focus = priority_focus.lower() if priority_focus else 'balance'
        
        self.days = ["Mon", "Tue", "Wed", "Thu", "Fri"]
        if self.include_weekends:
            self.days.extend(["Sat", "Sun"])

    def _get_priority_score(self, task):
        """Calculates a priority score based on Task Priority and User Profile."""
        base_score = 0
        p = task.get('priority', 'low').lower()
        if p == 'high': base_score = 30
        elif p == 'medium': base_score = 20
        else: base_score = 10
        
        # Adjust based on Personality (MBTI)
        mbti = self.profile.get('mbti')
        if mbti:
            mbti_type = mbti.get('mbti_type', '').upper()
            # Judgers (J) prioritize High priority/Deadlines more
            if 'J' in mbti_type:
                if p == 'high': base_score += 10
            # Perceivers (P) might be more flexible, but we give slight boost to Medium to keep them on track
            if 'P' in mbti_type:
                if p == 'medium': base_score += 5
        
        # Adjust based on Deadline (Urgency)
        # Assuming task has 'deadline'
        # if task.get('deadline') ... (logic can be added here)
        
        # --- PRIORITY FOCUS ADJUSTMENT ---
        if self.priority_focus == 'deadline':
            # "Chạy Deadline": Massive boost for HIGH priority
            if p == 'high':
                base_score += 100 # Increased from 50 to 100
            if p == 'medium':
                base_score += 40  # Increased from 20 to 40
                
        elif self.priority_focus in ['focus', 'learning', 'work', 'study']:  # "Tập trung Học tập/Làm việc"
            # Boost detailed "Study/Work" related tasks
            # Check type or infer from title
            title = task.get('title', '').lower()
            desc = task.get('description', '').lower()
            t_type = task.get('type', '').lower()
            
            # Simple heuristic + Type check
            if 'học' in title or 'study' in title or 'work' in title or 'làm' in title:
                base_score += 80 # Increased from 40 to 80
            elif t_type in ['class', 'self-study', 'work', 'study']:
                 base_score += 80 # Increased from 40 to 80

        return base_score

    def _determine_productive_period(self):
        """
        Infers the user's most productive time of day based on Work Style scores.
        Returns a list of preferred hour ranges e.g. [(8, 12), (14, 18)]
        """
        ws = self.profile.get('work_style')
        if not ws:
            return [(8, 12), (13, 17)] # Default 9-5ish
            
        # Extract Scores (Default to 0 if missing)
        analysis = ws.get('analysis_score', 0)
        creativity = ws.get('creativity_score', 0)
        teamwork = ws.get('teamwork_score', 0)
        
        # Heuristic Logic
        preferred_slots = []
        
        # High Analysis -> Morning (Deep Work, Focus)
        if analysis >= 60:
            preferred_slots.append((7, 12)) 
            
        # High Teamwork/Communication -> Afternoon (Meetings, Collaboration)
        if teamwork >= 60:
            preferred_slots.append((13, 17))
            
        # High Creativity -> Evening/Night (Creative Flow)
        if creativity >= 60:
            preferred_slots.append((19, 23))
            
        # If no strong preference, default to standard day
        if not preferred_slots:
            preferred_slots = [(8, 12), (13, 17)]
            
        return preferred_slots

    def _get_time_fitness_score(self, slot_start_time, preferred_slots):
        """
        Calculates how well a time slot fits the user's preferences.
        Returns a multiplier (e.g. 1.0 to 2.0).
        """
        hour = slot_start_time.hour
        if self.priority_focus == 'deadline':
            # Deadline Mode: Ignore "productive time" preferences.
            # We want to schedule tasks AS EARLY AS POSSIBLE.
            # Since the scheduler scans chronologically and picks the FIRST best slot,
            # returning a flat score ensures the earliest available slot is chosen.
            # We add a tiny decay based on hour to break ties explicitly in favor of earlier times.
            return 1.0 + (24 - hour) * 0.01

        if self.priority_focus == 'focus' or self.priority_focus == 'study':
             # Focus Mode: Strongly prioritize Productive Hours (Deep Work)
             for (start_h, end_h) in preferred_slots:
                if start_h <= hour < end_h:
                    return 2.5 # Massive boost (was 1.5)
             return 1.0

        for (start_h, end_h) in preferred_slots:
            if start_h <= hour < end_h:
                return 1.5 # 50% boost for preferred time
        return 1.0

    def _is_overlapping(self, start_dt, end_dt, existing_items):
        """Checks if the proposed slot overlaps with any existing schedule item."""
        
        for item in existing_items:
            # Note: caller effectively filters by Day already, preventing day-mismatch issues.
            # But we double check just in case, or we rely on the caller.
            # If we rely on caller to filter by day, we just check times.
            # However, start_dt has a specific DATE (e.g. 2000-01-01 Sat).
            # existing_items might be on 'Mon'.
            # If we don't check day here, we must Ensure existing_items match the day logic.
            # Since strict date comparison is used below (datetime.combine(dummy_date...)), 
            # and dummy_date comes from start_dt.date(), we are forcing comparison on start_dt's date.
            
            ex_start = item['start_time']
            ex_end = item['end_time']
            
            # Normalize to time objects
            if isinstance(ex_start, str):
                try: 
                    ex_start = datetime.strptime(ex_start, "%H:%M:%S").time()
                except ValueError:
                    # Try considering it might be HH:MM
                    try: ex_start = datetime.strptime(ex_start, "%H:%M").time()
                    except: pass
            elif isinstance(ex_start, timedelta):
                ex_start = (datetime.min + ex_start).time()
                
            if isinstance(ex_end, str):
                try: 
                    ex_end = datetime.strptime(ex_end, "%H:%M:%S").time()
                except ValueError:
                    try: ex_end = datetime.strptime(ex_end, "%H:%M").time()
                    except: pass
            elif isinstance(ex_end, timedelta):
                ex_end = (datetime.min + ex_end).time()
                
            # Create comparable datetimes on same dummy date as start_dt
            dummy_date = start_dt.date()
            ex_start_dt = datetime.combine(dummy_date, ex_start)
            ex_end_dt = datetime.combine(dummy_date, ex_end)
            
            # Overlap condition: StartA < EndB and EndA > StartB
            if start_dt < ex_end_dt and end_dt > ex_start_dt:
                return True, ex_end_dt # Return overlapping end time to jump
                
        return False, None

    def generate_schedule(self, tasks, existing_schedules):
        """
        Generates a list of new schedule items using a Best-Fit Strategy
        guided by User Preferences.
        """
        logging.info(f"Generating schedule. Start: {self.start_time}, End: {self.end_time}, Weekends: {self.include_weekends}")
        
        # 1. Determine Productive Periods
        preferred_slots = self._determine_productive_period()
        logging.info(f"Inferred User Productive Slots: {preferred_slots}")

        # 2. Sort tasks by Value/Priority
        sorted_tasks = sorted(tasks, key=self._get_priority_score, reverse=True)
        logging.info(f"Tasks to schedule: {len(sorted_tasks)}")
        
        new_schedule = []
        
        # Simulation Setup
        dummy_date = datetime(2000, 1, 1).date() 
        day_start_dt = datetime.combine(dummy_date, self.start_time)
        day_end_dt = datetime.combine(dummy_date, self.end_time)
        
        # Combine existing schedules into a structure we can query easily
        # We'll re-check overlap dynamically, but it helps to know which days are populated
        
        for task in sorted_tasks:
            duration_mins = task.get('duration', 60)
            best_slot = None
            best_score = -1
            
            # Iterate through all days and all time slots to find the Global Best Fit for this task
            # (within the window of days we are scheduling - let's limit to 1 week for now or just the days list)
            
            for day_name in self.days:
                # Scan this day in 30-minute increments (or 15 for precision)
                current_scan_time = day_start_dt
                
                while current_scan_time + timedelta(minutes=duration_mins) <= day_end_dt:
                    proposed_start = current_scan_time
                    proposed_end = current_scan_time + timedelta(minutes=duration_mins)
                    
                    # 1. Check Conflicts
                    # Check against Existing Schedules
                    is_conflict, conflict_end = self._is_overlapping(proposed_start, proposed_end, 
                                                                   [x for x in existing_schedules if x['day_of_week'] == day_name])
                    
                    if is_conflict:
                        # Skip ahead past the conflict
                        current_scan_time = conflict_end
                        # Ensure we don't go backwards or get stuck (if conflict_end is same, add epsilon)
                        if current_scan_time <= proposed_start:
                             current_scan_time = proposed_start + timedelta(minutes=15)
                        continue

                    # Check against Newly Scheduled items
                    is_conflict_new, conflict_end_new = self._is_overlapping(proposed_start, proposed_end, 
                                                                           [x for x in new_schedule if x['day_of_week'] == day_name])
                    if is_conflict_new:
                        current_scan_time = conflict_end_new
                        if current_scan_time <= proposed_start:
                             current_scan_time = proposed_start + timedelta(minutes=15)
                        continue
                        
                    # 2. Calculate Fitness Score
                    time_fitness = self._get_time_fitness_score(proposed_start.time(), preferred_slots)
                    
                    # --- RELAX MODE: PENALIZE ADJACENCY ---
                    adjacency_penalty = 0
                    if self.priority_focus == 'relax':
                        # Relax Mode: Enforce 20-minute (1200s) gaps
                        is_adjacent = False
                        GAP_SECONDS = 1200 # 20 minutes

                        # Check vs Existing (manual)
                        for ex in existing_schedules:
                             ex_st = datetime.strptime(ex['start_time'], "%H:%M:%S").time() if isinstance(ex['start_time'], str) else ex['start_time']
                             ex_end = datetime.strptime(ex['end_time'], "%H:%M:%S").time() if isinstance(ex['end_time'], str) else ex['end_time']
                             
                             if ex['day_of_week'] == day_name:
                                 # End touches Start?
                                 if abs((datetime.combine(datetime.min, proposed_end.time()) - datetime.combine(datetime.min, ex_st)).total_seconds()) < GAP_SECONDS: is_adjacent = True
                                 # Start touches End?
                                 if abs((datetime.combine(datetime.min, proposed_start.time()) - datetime.combine(datetime.min, ex_end)).total_seconds()) < GAP_SECONDS: is_adjacent = True
                        
                        # Check vs New
                        if not is_adjacent:
                            for new_t in new_schedule:
                                if new_t['day_of_week'] == day_name:
                                     n_st = datetime.strptime(new_t['start_time'], "%H:%M:%S").time()
                                     n_end = datetime.strptime(new_t['end_time'], "%H:%M:%S").time()
                                     if abs((datetime.combine(datetime.min, proposed_end.time()) - datetime.combine(datetime.min, n_st)).total_seconds()) < GAP_SECONDS: is_adjacent = True
                                     if abs((datetime.combine(datetime.min, proposed_start.time()) - datetime.combine(datetime.min, n_end)).total_seconds()) < GAP_SECONDS: is_adjacent = True
                        
                        if is_adjacent:
                            adjacency_penalty = 50.0 
 

                    # Base priority is already handled by sorting tasks, but we can add minor factors
                    # e.g. Prefer earlier days?
                    day_penalty = self.days.index(day_name) * 0.1 # Slight penalization for later in the week
                    
                    final_score = time_fitness - day_penalty - adjacency_penalty
                    
                    if final_score > best_score:
                        best_score = final_score
                        best_slot = {
                            'day': day_name,
                            'start': proposed_start.time(),
                            'end': proposed_end.time(),
                            'breakdown': f"Base: {time_fitness} - Day: {day_penalty} - Adj: {adjacency_penalty}"
                        }
                    
                    # Advance search cursor
                    current_scan_time += timedelta(minutes=30) # Step size
            
            # Place the task if a slot was found
            if best_slot:
                new_item = {
                    'task_id': task.get('task_id'), # Propagate task_id
                    'subject': task['title'],
                    'description': task.get('description', ''),
                    'type': 'self-study',
                    'day_of_week': best_slot['day'],
                    'start_time': best_slot['start'].strftime("%H:%M:%S"),
                    'end_time': best_slot['end'].strftime("%H:%M:%S"),
                    'collection_id': 0
                }
                
                # Add Learning Style Tips
                ls = self.profile.get('learning_style')
                if ls:
                    style = ls.get('primary_style', '')
                    if 'VISUAL' in style:
                        new_item['description'] += " [Use Charts/Videos]"
                    elif 'AUDITORY' in style:
                        new_item['description'] += " [Listen/Discuss]"
                    elif 'KINESTHETIC' in style:
                        new_item['description'] += " [Practice/Do]"

                new_schedule.append(new_item)
                try:
                    safe_title = task['title'].encode('ascii', 'replace').decode('ascii')
                    logging.info(f"Placed '{safe_title}' on {best_slot['day']} at {new_item['start_time']} (Score: {best_score:.2f} | {best_slot.get('breakdown')})")
                except Exception:
                    logging.info(f"Placed task (ID: {task.get('task_id')}) at {new_item['start_time']}")
            else:
                try:
                    safe_title = task['title'].encode('ascii', 'replace').decode('ascii')
                    logging.warning(f"Could not fit task '{safe_title}' anywhere.")
                except:
                    logging.warning(f"Could not fit task ID {task.get('task_id')} anywhere.")

        # MERGE: return both Existing (Fixed) + New (Tasks) for a comprehensive Preview
        # We need to ensure existing_schedules are formatted correctly for JSON (str times)
        # AND convert keys to camelCase for Java/Gson compatibility
        final_output = []
        
        # Helper to stringify time/timedelta
        def fmt_time(t):
            if isinstance(t, timedelta):
               return (datetime.min + t).time().strftime("%H:%M:%S")
            if isinstance(t, str): return t
            if hasattr(t, 'strftime'): return t.strftime("%H:%M:%S")
            return str(t)

        # MERGE & DEDUPLICATE
        # Sometimes duplicates might sneak in (e.g. data races or logic gaps). 
        # We enforce uniqueness based on (Day, StartTime, Subject).
        seen_keys = set()
        unique_output = []
        
        logging.info(f"Finalizing output. Manual: {len(existing_schedules)}, New: {len(new_schedule)}")

        # 1. Add Manual Constraints (Fixed)
        for ex in existing_schedules:
            s_time = fmt_time(ex.get('start_time'))
            key = (ex.get('day_of_week'), s_time, ex.get('subject') or ex.get('title'))
            if key in seen_keys:
                logging.warning(f"Duplicate Manual item ignored: {key}")
                continue
            seen_keys.add(key)
            
            item = {
                'taskId': ex.get('task_id'),
                'subject': ex.get('subject') or ex.get('title'),
                'description': ex.get('description', ''),
                'type': ex.get('type', 'self-study'),
                'dayOfWeek': ex.get('day_of_week'),
                'startTime': s_time,
                'endTime': fmt_time(ex.get('end_time')),
                'collectionId': ex.get('collection_id', 0)
            }
            unique_output.append(item)
            
        # 2. Add New (Tasks)
        for task_item in new_schedule:
            s_time = task_item['start_time']
            key = (task_item['day_of_week'], s_time, task_item['subject'])
            if key in seen_keys:
                 logging.warning(f"Duplicate Scheduled item ignored: {key}")
                 continue
            seen_keys.add(key)
            
            item = {
                'subject': task_item['subject'],
                'description': task_item['description'],
                'type': task_item['type'],
                'taskId': task_item.get('task_id'),
                'dayOfWeek': task_item['day_of_week'],
                'startTime': s_time,
                'endTime': task_item['end_time'],
                'collectionId': task_item['collection_id']
            }
            unique_output.append(item)

        logging.info(f"Returning {len(unique_output)} items after deduplication.")
        return unique_output


@app.route('/generate-schedule', methods=['POST'])
def generate_schedule():
    data = request.json
    if not data:
        return jsonify({'error': 'No data provided'}), 400
        
    user_id = data.get('user_id')
    collection_id = data.get('collection_id')
    start_time_str = data.get('start_time', '08:00')
    end_time_str = data.get('end_time', '22:00')
    include_weekends = data.get('include_weekends', False)
    priority_focus = data.get('priorityFocus', 'balance') # Get priority
    
    if not user_id or not collection_id:
        return jsonify({'error': 'Missing user_id or collection_id'}), 400
        
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        # 1. Fetch Context
        profile = fetch_user_profile(conn, user_id)
        existing_schedules = fetch_existing_schedules(conn, collection_id)
        all_tasks = fetch_pending_tasks(conn, collection_id)
        
        # LOGIC: "Reschedule Everything" (Overwrite Mode)
        # 1. Identify Manual Items (Meetings, Breaks) that have NO task_id. Keep these as Constraints.
        manual_constraints = []
        for ex in existing_schedules:
            tid = ex.get('task_id')
            if not tid or tid == 0:
                manual_constraints.append(ex)
                
        # 2. Identify Tasks to Schedule.
        # We take ALL pending tasks, ignoring their current position on the calendar.
        tasks_to_schedule = all_tasks

        logging.info(f"Generating schedule. Start: {start_time_str}, End: {end_time_str}, Weekends: {include_weekends}")
        logging.info(f"Rescheduling Mode. Keeping {len(manual_constraints)} manual items fixed. Rescheduling {len(tasks_to_schedule)} tasks.")
            
        # 3. Run Scheduler
        # We pass ONLY the manual constraints as 'locked'.
        scheduler = SmartScheduler(start_time_str, end_time_str, include_weekends, profile, priority_focus)
        
        # generate_schedule returns the FINAL merged list (Manual + New) with correct keys
        final_output = scheduler.generate_schedule(tasks_to_schedule, manual_constraints)
        
        return jsonify(final_output)

    except Exception as e:
        logging.error(f"Error generating schedule: {e}", exc_info=True)
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

if __name__ == '__main__':
    # Run on port 5000
    app.run(host='0.0.0.0', port=5000, debug=True)