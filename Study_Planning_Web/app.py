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
    """Fetches tasks with status 'pending'."""
    cursor = conn.cursor(dictionary=True)
    # Assuming valid columns. Adjust if schema differs.
    query = """
        SELECT task_id, title, description, priority, duration, deadline 
        FROM tasks 
        WHERE user_id = %s AND status = 'pending'
    """
    # DEBUG: Fetch ALL tasks in the TABLE to see if DB is empty
    cursor.execute("SELECT task_id, user_id, title, status FROM tasks LIMIT 5")
    all_tasks = cursor.fetchall()
    logging.info(f"GLOBAL CHECK - First 5 tasks in DB: {all_tasks}")

    # DEBUG: Fetch ALL tasks to see what status they really have
    cursor.execute("SELECT status, count(*) as cnt FROM tasks WHERE user_id = %s GROUP BY status", (user_id,))
    statuses = cursor.fetchall()
    logging.info(f"Task Status Distribution for User {user_id}: {statuses}")

    cursor.execute(query, (user_id,))
    tasks = cursor.fetchall()
    logging.info(f"Fetching pending tasks for user_id={user_id}. Found: {len(tasks)}")
    cursor.close()
    return tasks

def fetch_existing_schedules(conn, collection_id):
    """Fetches existing schedule items for the given collection to avoid conflicts."""
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT * FROM user_schedule 
        WHERE collection_id = %s
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
        
        # Adjust based on Personality
        # Example: if user is 'Judging' (J), they might prioritize due_date (Urgency) more.
        # If user is 'Thinking' (T), they might stick strictly to High priority first.
        
        mbti = self.profile.get('mbti')
        if mbti:
            # If INTJ/ENTJ (Judgers), boost score for High priority to ensure they get done first
            if 'J' in mbti.get('mbti_type', ''):
                if p == 'high': base_score += 5
        
        return base_score

    def _is_overlapping(self, start_dt, end_dt, existing_items):
        """Checks if the proposed slot overlaps with any existing schedule item."""
        # start_dt and end_dt are datetime objects (dummy date, correct time)
        # existing_items is list of dicts.
        
        proposed_day = start_dt.strftime("%a") # Day name e.g., 'Mon'
        
        for item in existing_items:
            if item['day_of_week'] != proposed_day:
                continue
            
            # Convert item times to dummy datetime for comparison
            # item['start_time'] might be timedelta or time object depending on connector
            # Normalize to seconds or time objects
            
            ex_start = item['start_time'] # Likely timedelta
            ex_end = item['end_time']
            
            # Convert timedelta to time if necessary (mysql-connector often returns timedelta)
            if isinstance(ex_start, timedelta):
                ex_start = (datetime.min + ex_start).time()
            if isinstance(ex_end, timedelta):
                ex_end = (datetime.min + ex_end).time()
                
            # Create comparable datetimes on same dummy date
            dummy_date = start_dt.date()
            ex_start_dt = datetime.combine(dummy_date, ex_start)
            ex_end_dt = datetime.combine(dummy_date, ex_end)
            
            # Overlap condition: StartA < EndB and EndA > StartB
            if start_dt < ex_end_dt and end_dt > ex_start_dt:
                return True, ex_end_dt # Return overlapping end time to jump
                
        return False, None

    def generate_schedule(self, tasks, existing_schedules):
        """
        Generates a list of new schedule items.
        """
        logging.info(f"Generating schedule. Start: {self.start_time}, End: {self.end_time}, Weekends: {self.include_weekends}")
        
        # Sort tasks by calculated priority
        sorted_tasks = sorted(tasks, key=self._get_priority_score, reverse=True)
        logging.info(f"Tasks to schedule: {len(sorted_tasks)}")
        
        new_schedule = []
        
        # Simulation State
        current_day_idx = 0
        
        # Create a "Cursor" for time
        dummy_date = datetime(2000, 1, 1).date() 
        current_time = datetime.combine(dummy_date, self.start_time)
        day_end_time = datetime.combine(dummy_date, self.end_time)
        
        for task in sorted_tasks:
            placed = False
            duration_mins = task.get('duration', 60) # Default 60 mins
            
            # Start search from the current cursor position
            # But if we fail to place it today, we should try subsequent days
            # We preserve current_day_idx/current_time for the NEXT task to pack tightly
            # BUT for the CURRENT task, we can temporarily look ahead if needed?
            # No, 'simulated annealing/greedy' usually moves forward.
            
            # Temporary cursor for this task
            temp_day_idx = current_day_idx
            temp_time = current_time
            
            # Try to find a slot starting from where we are
            while temp_day_idx < len(self.days) and not placed:
                current_day_name = self.days[temp_day_idx]
                
                # Check if task fits in remaining day
                proposed_end_time = temp_time + timedelta(minutes=duration_mins)
                
                if proposed_end_time > day_end_time:
                    # Move to next day start
                    temp_day_idx += 1
                    temp_time = datetime.combine(dummy_date, self.start_time)
                    continue
                
                # Check for conflicts
                day_items = [x for x in existing_schedules if x['day_of_week'] == current_day_name]
                day_items += [x for x in new_schedule if x['day_of_week'] == current_day_name]
                
                is_overlap = False
                next_jump = None
                
                for item in day_items:
                    # Normalize item times
                    i_start = item['start_time']
                    i_end = item['end_time']
                    
                    if isinstance(i_start, timedelta): i_start = (datetime.min + i_start).time()
                    if isinstance(i_end, timedelta): i_end = (datetime.min + i_end).time()
                    
                    # Fix: Handle case where item is from new_schedule (string format)
                    if isinstance(i_start, str): i_start = datetime.strptime(i_start, "%H:%M:%S").time()
                    if isinstance(i_end, str): i_end = datetime.strptime(i_end, "%H:%M:%S").time()
                    
                    i_start_dt = datetime.combine(dummy_date, i_start)
                    i_end_dt = datetime.combine(dummy_date, i_end)
                    
                    # Overlap Check
                    if temp_time < i_end_dt and proposed_end_time > i_start_dt:
                        is_overlap = True
                        next_jump = i_end_dt
                        break
                
                if is_overlap:
                    # Jump to the end of the blocking task
                    # CRITICAL FIX: Ensure we don't jump backwards or before start_time (though start_time check handles init)
                    # And ensure we don't just infinite loop if next_jump is weird.
                    if next_jump:
                        temp_time = max(next_jump, temp_time)
                        # Ensure we respect the user's start constraint if next_jump was somehow earlier (unlikely but safe)
                        start_constraint = datetime.combine(dummy_date, self.start_time)
                        temp_time = max(temp_time, start_constraint)
                    else:
                        # Fallback
                        temp_time += timedelta(minutes=15)
                else:
                    # Found a valid slot!
                    
                    # Double check start time constraint
                    start_constraint = datetime.combine(dummy_date, self.start_time)
                    if temp_time < start_constraint:
                         temp_time = start_constraint
                         continue # Re-evaluate overlap at correct time

                    # Recalculate end time after any adjustments
                    proposed_end_time = temp_time + timedelta(minutes=duration_mins)
                    
                    # Final strict bound check
                    if proposed_end_time > day_end_time:
                         temp_day_idx += 1
                         temp_time = datetime.combine(dummy_date, self.start_time)
                         continue
                        
                    new_item = {
                        'subject': task['title'],
                        'description': task.get('description', ''),
                        'type': 'self-study',
                        'day_of_week': current_day_name,
                        'start_time': temp_time.strftime("%H:%M:%S"),
                        'end_time': proposed_end_time.strftime("%H:%M:%S"),
                        'collection_id': 0
                    }
                    
                    ls = self.profile.get('learning_style')
                    if ls and ls.get('primary_style') == 'VISUAL':
                        new_item['description'] = (new_item['description'] or "") + " [Use Visual Aids]"
                        
                    new_schedule.append(new_item)
                    placed = True
                    logging.info(f"Placed task '{task['title']}' on {current_day_name} at {new_item['start_time']}")
                    
                    # Update MAIN cursor to this new position + task duration
                    # Choosing to update GLOBAL cursor means we pack tasks sequentially.
                    # If we didn't update global cursor, we'd overlap our own new tasks (handled by day_items check).
                    # But for efficiency, updating global cursor is good IF we assume sequential packing.
                    # BUT: If we skipped to next day for this task, we shouldn't necessarily force all future tasks to next day 
                    # if they could fit in the holes of previous days?
                    # For now, let's update global cursor ONLY if on same day, or advance it if we moved days.
                    
                    current_day_idx = temp_day_idx
                    current_time = proposed_end_time
            
            if not placed:
                 logging.warning(f"Could not place task: {task['title']} within limits.")

        return new_schedule


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
