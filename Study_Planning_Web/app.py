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
    'password': 'Anhang@204',
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

def fetch_pending_tasks(conn, user_id):
    """Fetches tasks with status 'pending' by joining with schedule tables."""
    cursor = conn.cursor(dictionary=True)
    # Fix: 'tasks' table has NULL user_id. We must find tasks via user_schedule -> schedule_collection.
    # We select tasks that are 'pending'.
    query = """
        SELECT DISTINCT t.task_id, t.title, t.description, t.priority, t.duration, t.deadline 
        FROM tasks t
        JOIN user_schedule us ON t.task_id = us.task_id
        JOIN schedule_collection sc ON us.collection_id = sc.collection_id
        WHERE sc.user_id = %s AND t.status = 'pending'
    """
    
    # DEBUG: Fetch all tasks to see if any exist at all
    # cursor.execute("SELECT count(*) as total FROM tasks")
    # total = cursor.fetchone()
    # logging.info(f"Total tasks in DB: {total}")

    cursor.execute(query, (user_id,))
    tasks = cursor.fetchall()
    logging.info(f"Fetching pending tasks for user_id={user_id}. Found: {len(tasks)}")
    cursor.close()
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
        AND (task_id IS NULL OR task_id = 0)
    """
    cursor.execute(query, (collection_id,))
    schedules = cursor.fetchall()
    cursor.close()
    return schedules

# --- Smart Scheduling Logic ---

class SmartScheduler:
    def __init__(self, start_time_str, end_time_str, include_weekends, profile):
        self.start_time = datetime.strptime(start_time_str, "%H:%M").time()
        self.end_time = datetime.strptime(end_time_str, "%H:%M").time()
        self.include_weekends = include_weekends
        self.profile = profile
        
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
                    
                    # Base priority is already handled by sorting tasks, but we can add minor factors
                    # e.g. Prefer earlier days?
                    day_penalty = self.days.index(day_name) * 0.1 # Slight penalization for later in the week
                    
                    final_score = time_fitness - day_penalty
                    
                    if final_score > best_score:
                        best_score = final_score
                        best_slot = {
                            'day': day_name,
                            'start': proposed_start.time(),
                            'end': proposed_end.time()
                        }
                    
                    # Advance search cursor
                    current_scan_time += timedelta(minutes=30) # Step size
            
            # Place the task if a slot was found
            if best_slot:
                new_item = {
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
                    logging.info(f"Placed '{safe_title}' on {best_slot['day']} at {new_item['start_time']} (Score: {best_score:.2f})")
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

        # 1. Add Existing (Fixed) - Convert snake_case DB keys to camelCase
        for ex in existing_schedules:
            item = {
                'subject': ex.get('subject') or ex.get('title'),
                'description': ex.get('description', ''),
                'type': ex.get('type', 'self-study'),
                'dayOfWeek': ex.get('day_of_week'),
                'startTime': fmt_time(ex.get('start_time')),
                'endTime': fmt_time(ex.get('end_time')),
                'collectionId': ex.get('collection_id', 0)
            }
            final_output.append(item)
            
        # 2. Add New (Tasks) - Convert internal snake_case to camelCase
        for task_item in new_schedule:
            item = {
                'subject': task_item['subject'],
                'description': task_item['description'],
                'type': task_item['type'],
                'dayOfWeek': task_item['day_of_week'],
                'startTime': task_item['start_time'],
                'endTime': task_item['end_time'],
                'collectionId': task_item['collection_id']
            }
            final_output.append(item)

        return final_output


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
    
    if not user_id or not collection_id:
        return jsonify({'error': 'Missing user_id or collection_id'}), 400
        
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        # 1. Fetch Context
        profile = fetch_user_profile(conn, user_id)
        tasks = fetch_pending_tasks(conn, user_id)
        existing_schedules = fetch_existing_schedules(conn, collection_id)
        
        if not tasks:
            return jsonify([]) # No tasks to schedule
            
        # 2. Run Scheduler
        scheduler = SmartScheduler(start_time_str, end_time_str, include_weekends, profile)
        generated_schedule = scheduler.generate_schedule(tasks, existing_schedules)
        
        return jsonify(generated_schedule)
        
    except Exception as e:
        logging.error(f"Error generating schedule: {e}", exc_info=True)
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

if __name__ == '__main__':
    # Run on port 5000
    app.run(host='0.0.0.0', port=5000, debug=True)