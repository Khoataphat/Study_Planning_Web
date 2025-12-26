import logging
from flask import Flask, request, jsonify
import mysql.connector
from datetime import datetime, timedelta, time 
import json
import sys
import io
import decimal  # Thêm import này

app = Flask(__name__)

# Fix Windows console encoding
if sys.platform == "win32":
    # Set UTF-8 encoding for stdout
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='ignore')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='ignore')

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("py_service.log", encoding='utf-8'),
        logging.StreamHandler(sys.stdout)  # Dùng sys.stdout đã fix
    ],
    force=True
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

def format_time_to_ampm(time_input):
    """
    Convert ANY time input to HH:MM:SS AM/PM format
    """
    if not time_input:
        return "08:00:00 SA"
    
    # Nếu đã là string có AM/PM rồi, return nguyên bản
    if isinstance(time_input, str):
        time_str = time_input.strip().upper()
        if 'SA' in time_str or 'CH' in time_str:
            return time_input  # Giữ nguyên

    # Nếu là timedelta (từ MySQL)
    if isinstance(time_input, timedelta):
        # Convert timedelta to time
        total_seconds = int(time_input.total_seconds())
        hours = total_seconds // 3600
        minutes = (total_seconds % 3600) // 60
        seconds = total_seconds % 60
        
        # Tạo time object
        time_obj = time(hour=hours, minute=minutes, second=seconds)
        
        # Gọi đệ quy với time object
        return format_time_to_ampm(time_obj)
    
    # Nếu là time object
    if isinstance(time_input, time):
        hour = time_input.hour
        minute = time_input.minute
        second = time_input.second
        
        # Xác định AM/PM
        if hour == 0:
            return f"12:{minute:02d}:{second:02d} SA"
        elif hour < 12:
            return f"{hour:02d}:{minute:02d}:{second:02d} SA"
        elif hour == 12:
            return f"12:{minute:02d}:{second:02d} CH"
        else:
            hour_12 = hour - 12
            return f"{hour_12:02d}:{minute:02d}:{second:02d} CH"
    
    # Nếu là string
    elif isinstance(time_input, str):
        time_str = time_input.strip().upper()
        
        # Nếu đã có AM/PM
        if 'SA' in time_str or 'CH' in time_str:
            # Đảm bảo có seconds
            parts = time_str.split()
            if len(parts) >= 2:
                time_part = parts[0]
                ampm = parts[1]
                
                # Đảm bảo có đủ HH:MM:SS
                time_parts = time_part.split(':')
                if len(time_parts) == 2:
                    time_part = f"{time_parts[0]}:{time_parts[1]}:00"
                
                return f"{time_part} {ampm}"
        
        # Nếu là format 24h
        if ':' in time_str:
            parts = time_str.split(':')
            hour = int(parts[0]) if parts[0] else 8
            minute = int(parts[1]) if len(parts) > 1 and parts[1] else 0
            second = int(parts[2]) if len(parts) > 2 and parts[2] else 0
            
            # Chuyển sang 12h format
            if hour == 0:
                return f"12:{minute:02d}:{second:02d} SA"
            elif hour < 12:
                return f"{hour:02d}:{minute:02d}:{second:02d} SA"
            elif hour == 12:
                return f"12:{minute:02d}:{second:02d} CH"
            else:
                hour_12 = hour - 12
                return f"{hour_12:02d}:{minute:02d}:{second:02d} CH"
    
    # Fallback
    return "08:00:00 SA"

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
    
    # Sửa query để phù hợp với ONLY_FULL_GROUP_BY
    query = """
        SELECT 
            MIN(t.task_id) as task_id, 
            t.title, 
            MIN(t.description) as description, 
            t.priority, 
            SUM(t.duration) as total_duration, 
            MIN(t.deadline) as deadline, 
            us.type, 
            t.status,
            COUNT(*) as duplicate_count
        FROM tasks t
        JOIN user_schedule us ON t.task_id = us.task_id
        WHERE us.collection_id = %s 
          AND t.status = 'pending'
          AND us.type = 'self-study'
        GROUP BY t.title, t.priority, t.status, us.type
    """
    
    cursor.execute(query, (collection_id,))
    tasks = cursor.fetchall()
    
    logging.info(f"Fetching SELF-STUDY tasks for collection_id={collection_id}. Found: {len(tasks)}")
    for t in tasks:
        duplicate_count = t.get('duplicate_count', 1)
        duration = t.get('total_duration', 60)
        
        if duplicate_count > 1:
            logging.info(f"   -> Self-Study Task: '{t.get('title')}' [Merged {duplicate_count}x, Total Duration: {duration} mins]")
        else:
            logging.info(f"   -> Self-Study Task: '{t.get('title')}' [ID: {t.get('task_id')}, Duration: {duration} mins]")
    
    # Đổi tên total_duration thành duration để tương thích
    for task in tasks:
        task['duration'] = task.pop('total_duration', 60)
        # Thêm collection_id nếu cần
        task['collection_id'] = collection_id
    
    cursor.close()
    return tasks

def fetch_existing_schedules(conn, collection_id):
    """
    Fetches existing schedule items.
    Chỉ lấy items KHÔNG phải self-study và KHÔNG phải class.
    """
    cursor = conn.cursor(dictionary=True)
    
    query = """
        SELECT * FROM user_schedule 
        WHERE collection_id = %s 
          AND (type != 'self-study' OR type IS NULL)
          AND (type != 'class' OR type IS NULL)
    """
    
    cursor.execute(query, (collection_id,))
    items = cursor.fetchall()
    
    # Helper để convert timedelta
    def convert_to_time(td):
        if isinstance(td, timedelta):
            total_seconds = int(td.total_seconds())
            hours = total_seconds // 3600
            minutes = (total_seconds % 3600) // 60
            seconds = total_seconds % 60
            return time(hour=hours, minute=minutes, second=seconds)
        elif isinstance(td, time):
            return td
        elif isinstance(td, str):
            try:
                if ':' in td:
                    parts = td.split(':')
                    hour = int(parts[0])
                    minute = int(parts[1]) if len(parts) > 1 else 0
                    second = int(parts[2]) if len(parts) > 2 else 0
                    return time(hour=hour, minute=minute, second=second)
            except:
                pass
        return None
    
    valid_items = []
    for s in items:
        # Convert thời gian
        start_time = convert_to_time(s.get('start_time'))
        end_time = convert_to_time(s.get('end_time'))
        
        if start_time:
            s['start_time'] = start_time
            s['end_time'] = end_time
            valid_items.append(s)
    
    logging.info(f"Collection {collection_id}: Found {len(valid_items)} NON-self-study, NON-class items.")
    cursor.close()
    return valid_items

def fetch_fixed_classes(conn, collection_id):
    """Fetches fixed classes (type='class') for the collection."""
    cursor = conn.cursor(dictionary=True)
    
    query = """
        SELECT us.*, t.title, t.description, t.priority, t.duration
        FROM user_schedule us
        LEFT JOIN tasks t ON us.task_id = t.task_id
        WHERE us.collection_id = %s 
        AND us.type = 'class'
        ORDER BY us.day_of_week, us.start_time
    """
    
    cursor.execute(query, (collection_id,))
    fixed_classes = cursor.fetchall()
    
    # Helper function để convert timedelta sang time
    def convert_to_time(td):
        if isinstance(td, timedelta):
            total_seconds = int(td.total_seconds())
            hours = total_seconds // 3600
            minutes = (total_seconds % 3600) // 60
            seconds = total_seconds % 60
            return time(hour=hours, minute=minutes, second=seconds)
        elif isinstance(td, time):
            return td
        elif isinstance(td, str):
            # Parse string - SỬA: Xử lý cả 24h format
            try:
                if ':' in td:
                    parts = td.split(':')
                    hour = int(parts[0])
                    minute = int(parts[1]) if len(parts) > 1 else 0
                    second = int(parts[2]) if len(parts) > 2 else 0
                    return time(hour=hour, minute=minute, second=second)
            except:
                pass
        return time(8, 0, 0)  # Default
    
    # Format for frontend
    formatted_classes = []
    for fc in fixed_classes:
        # Convert timedelta to time
        start_time = convert_to_time(fc.get('start_time'))
        end_time = convert_to_time(fc.get('end_time'))
        subject = fc.get('subject') or fc.get('title', 'Class')
        
        # Format với AM/PM - SỬA: Đảm bảo dùng format_time_to_ampm
        start_formatted = format_time_to_ampm(start_time)
        end_formatted = format_time_to_ampm(end_time)
        
        # Đảm bảo có AM/PM trong output
        if 'SA' not in start_formatted and 'CH' not in start_formatted:
            start_formatted = format_time_to_ampm(start_formatted)
        if 'SA' not in end_formatted and 'CH' not in end_formatted:
            end_formatted = format_time_to_ampm(end_formatted)
        
        formatted_classes.append({
            'taskId': fc.get('task_id'),
            'subject': subject,
            'description': fc.get('description', ''),
            'type': 'class',
            'dayOfWeek': fc.get('day_of_week'),
            'startTime': start_formatted,
            'endTime': end_formatted,
            'collectionId': collection_id,
            'isFixed': True
        })
        
        # Debug log
        logging.info(f"  ✅ Fixed Class: {fc.get('day_of_week')} {start_formatted}-{end_formatted} - {subject}")
    
    logging.info(f"Found {len(formatted_classes)} fixed classes for collection {collection_id}")
    cursor.close()
    return formatted_classes

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
        
        # SCIENCE-BASED EFFICIENCY MAP (No database needed)
        # Based on circadian rhythm research and productivity studies
        self.efficiency_map = self._initialize_science_based_efficiency()
        
        logging.info(f"Scheduler initialized: {start_time_str}-{end_time_str}, Focus: {priority_focus}")
        logging.info(f"Using science-based efficiency model with {len(self.efficiency_map)} time slots")
    
    def _initialize_science_based_efficiency(self):
        """
        INITIALIZE SCIENCE-BASED PRODUCTIVITY MODEL
        
        Research References (search on Google Scholar):
        1. 9-11 AM: Peak cognitive performance (Journal of Educational Psychology)
        2. 13-14 PM: Post-lunch dip - 20% decrease (University of Bristol)
        3. 14-16 PM: Afternoon recovery peak (Sleep Research Society)
        4. 20-22 PM: Evening creative boost (Personality and Individual Differences)
        
        Day multipliers based on weekly productivity patterns research
        """
        efficiency = {}
        
        # Base daily pattern (valid for most intermediate chronotypes)
        hourly_efficiency = {
            8: 0.80,   # Morning warm-up
            9: 0.95,   # PEAK cognitive time [REF1]
            10: 0.98,  # OPTIMAL learning time [REF1]
            11: 0.90,  # Still high
            12: 0.75,  # Pre-lunch decline
            13: 0.65,  # POST-LUNCH DIP -20% [REF2]
            14: 0.85,  # Recovery begins
            15: 0.92,  # Afternoon peak [REF3]
            16: 0.85,  # Gradual decline
            17: 0.78, 18: 0.75, 19: 0.72,
            20: 0.70,  # Evening varies [REF4]
            21: 0.68, 22: 0.65, 23: 0.60
        }
        
        # Weekly productivity multipliers (based on workplace studies)
        day_multipliers = {
            'Mon': 0.95,  # "Monday blues" - slower start
            'Tue': 1.00,  # Peak productivity day
            'Wed': 0.98,  # High consistency
            'Thu': 0.96,  # Slight decline
            'Fri': 0.90,  # "TGIF effect" - weekend anticipation
            'Sat': 0.92,  # Weekend - rested, flexible
            'Sun': 0.88   # Weekend - pre-Monday anticipation
        }
        
        # Apply to all days
        for day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']:
            multiplier = day_multipliers.get(day, 1.0)
            
            # Special Friday evening boost for creative work
            friday_evening_boost = 1.15 if day == 'Fri' else 1.0
            
            for hour, base_eff in hourly_efficiency.items():
                adjusted_eff = base_eff * multiplier
                
                # Evening adjustments
                if hour >= 20:
                    adjusted_eff *= friday_evening_boost
                
                efficiency[(day, hour)] = round(min(1.0, adjusted_eff), 3)
        
        return efficiency
    
    def _get_priority_score(self, task):
        """
        ENHANCED PRIORITY SCORING with SCIENCE-BASED URGENCY
        
        Urgency Curve based on deadline psychology research:
        - <12h: CRITICAL (Parkinson's Law)
        - 12-24h: HIGH urgency
        - 24-72h: MEDIUM (optimal planning window)
        - >72h: LOW (can use spaced scheduling)
        """
        base_score = 0
        p = task.get('priority', 'low').lower()
        
        # Base priority weights (increased for better differentiation)
        if p == 'high': base_score = 100
        elif p == 'medium': base_score = 60
        else: base_score = 30
        
        # === DEADLINE URGENCY (MOST IMPORTANT FOR EXAMS) ===
        deadline = task.get('deadline')
        if deadline:
            try:
                # Nếu deadline đã là datetime object (từ database)
                if isinstance(deadline, datetime):
                    deadline_dt = deadline
                elif isinstance(deadline, str):
                    deadline_dt = datetime.strptime(deadline, '%Y-%m-%d %H:%M:%S')
                else:
                    deadline_dt = None
                    
                if deadline_dt:
                    hours_left = (deadline_dt - datetime.now()).total_seconds() / 3600
                    
                    # URGENCY CURVE based on research
                    if hours_left <= 12:        # CRITICAL (<12h)
                        base_score += 500
                    elif hours_left <= 24:      # HIGH (12-24h)
                        base_score += 300
                    elif hours_left <= 72:      # MEDIUM (1-3 days)
                        base_score += 150
                    elif hours_left <= 168:     # LOW (3-7 days)
                        base_score += 50
                        
            except Exception as e:
                logging.debug(f"Could not parse deadline: {deadline}, Type: {type(deadline)}, Error: {e}")
        
        # === PRIORITY FOCUS MODE ADJUSTMENTS ===
        if self.priority_focus == 'deadline':
            # DEADLINE MODE: Extreme priority for urgent tasks
            if p == 'high':
                base_score *= 2.5
            elif p == 'medium':
                base_score *= 1.8
        
        elif self.priority_focus == 'focus':
            # FOCUS MODE: Boost study-related tasks
            task_type = self._infer_task_type(task)
            if task_type == 'study':
                base_score += 150
            elif task_type == 'work':
                base_score += 100
        
        elif self.priority_focus == 'relax':
            # RELAX MODE: Reduce urgency, add spacing
            base_score *= 0.7  # Less urgency
        
        # === PERSONALIZATION BASED ON MBTI ===
        mbti = self.profile.get('mbti')
        if mbti:
            mbti_type = mbti.get('mbti_type', '').upper()
            
            # Judgers (J) need structure and early completion
            if 'J' in mbti_type and p == 'high':
                base_score += 80
            
            # Perceivers (P) flexible but need motivation for medium tasks
            if 'P' in mbti_type and p == 'medium':
                base_score += 40
        
        return int(base_score)
    
    def _infer_task_type(self, task):
        """Intelligent task type inference for better scheduling"""
        title = task.get('title', '').lower()
        desc = task.get('description', '').lower()
        
        # Study keywords (memory-intensive)
        study_words = ['học', 'study', 'ôn', 'thi', 'exam', 'đọc', 'read', 'nhớ', 'memory', 'review']
        
        # Work keywords (analytical)
        work_words = ['làm', 'work', 'code', 'program', 'viết', 'write', 'tính', 'calculate', 'phân tích']
        
        # Creative keywords (divergent thinking)
        creative_words = ['sáng tạo', 'creative', 'design', 'nghĩ', 'think', 'brainstorm', 'ý tưởng']
        
        # Exam prep (special category)
        exam_words = ['thi', 'exam', 'kiểm tra', 'test', 'final', 'midterm']
        
        # Check exam first (highest priority)
        if any(word in title or word in desc for word in exam_words):
            return 'exam'
        
        # Then check other categories
        if any(word in title or word in desc for word in study_words):
            return 'study'
        elif any(word in title or word in desc for word in work_words):
            return 'work'
        elif any(word in title or word in desc for word in creative_words):
            return 'creative'
        
        return 'other'
    
    def _get_optimal_hours_for_task_type(self, task_type):
        """
        Return optimal hours for each task type based on research
        
        Search references:
        - "Analytical task performance morning vs evening"
        - "Memory consolidation optimal timing"
        - "Creative thinking circadian patterns"
        """
        optimal_hours = {
            'exam': [9, 10, 14, 15],      # Exam prep: peak cognitive hours
            'study': [9, 10, 15, 16],     # Study: morning + afternoon peaks
            'work': [10, 11, 14, 15],     # Analytical work: late morning + early afternoon
            'creative': [20, 21, 22],     # Creative: evening (divergent thinking)
            'other': [9, 10, 14, 15, 16]  # Default: productive hours
        }
        
        return optimal_hours.get(task_type, [9, 10, 14, 15])
    
    def _calculate_slot_score(self, day, hour, task):
        """
        Calculate fitness score for a time slot
        Combines: Science-based efficiency + Task-type matching + Urgency
        """
        score = 0
        task_type = self._infer_task_type(task)
        
        # === 1. SCIENCE-BASED EFFICIENCY (30% weight) ===
        base_efficiency = self.efficiency_map.get((day, hour), 0.7)
        score += base_efficiency * 100
        
        # === 2. TASK-TYPE OPTIMAL TIMING (40% weight) ===
        optimal_hours = self._get_optimal_hours_for_task_type(task_type)
        if hour in optimal_hours:
            score += 150  # Big boost for optimal timing
        
        # Special adjustments for task types
        if task_type == 'study' and hour == 13:
            score -= 80  # Avoid post-lunch dip for studying
        elif task_type == 'creative' and hour >= 20:
            score += 120  # Evening creative boost
        
        # === 3. DEADLINE URGENCY (30% weight) ===
        deadline = task.get('deadline')
        if deadline:
            try:
                # Nếu deadline đã là datetime object (từ database)
                if isinstance(deadline, datetime):
                    deadline_dt = deadline
                else:
                    deadline_dt = datetime.strptime(deadline, '%Y-%m-%d %H:%M:%S')
                hours_left = (deadline_dt - datetime.now()).total_seconds() / 3600
                
                if hours_left < 24:
                    # URGENT: Earlier is better
                    score += (24 - hour) * 10  # Earlier hours get more points
                elif hours_left < 72:
                    # NEAR: Prefer productive hours
                    if hour in [9, 10, 14, 15]:
                        score += 100
            except:
                pass
        
        # === 4. PRIORITY FOCUS MODE ADJUSTMENTS ===
        if self.priority_focus == 'deadline':
            # Deadline mode: EARLIEST possible slot
            score += (24 - hour) * 15  # Strong preference for early hours
        
        elif self.priority_focus == 'focus':
            # Focus mode: Peak productive hours only
            if hour in [9, 10, 14, 15]:
                score += 200
            elif hour == 13:  # Avoid lunch dip
                score -= 150
        
        elif self.priority_focus == 'relax':
            # Relax mode: Avoid back-to-back scheduling
            # Prefer mid-morning and mid-afternoon
            if hour in [10, 11, 15, 16]:
                score += 80
        
        # === 5. PERSONALIZATION: LEARNING STYLE ===
        ls = self.profile.get('learning_style')
        if ls:
            style = ls.get('primary_style', '').upper()
            
            # Visual learners: Morning light advantage
            if 'VISUAL' in style and hour in [9, 10, 11]:
                score += 60
            
            # Kinesthetic: Afternoon energy advantage
            if 'KINESTHETIC' in style and hour in [15, 16]:
                score += 50
        
        return int(score)
    
    def generate_schedule(self, tasks, existing_schedules):
        """
        MAIN SCHEDULING ALGORITHM - SCIENCE OPTIMIZED
        Uses smart scoring and efficient slot finding
        """
        logging.info("=" * 60)
        logging.info("GENERATING SCIENCE-OPTIMIZED SCHEDULE")
        logging.info(f"Tasks to schedule: {len(tasks)}")
        logging.info(f"Existing constraints: {len(existing_schedules)}")
        logging.info(f"Priority focus: {self.priority_focus}")
        
        # 1. SMART TASK ORDERING
        # Sort by priority score (highest first)
        scored_tasks = [(task, self._get_priority_score(task)) for task in tasks]
        scored_tasks.sort(key=lambda x: x[1], reverse=True)
        sorted_tasks = [task for task, score in scored_tasks]
        
        # Log priority order
        logging.info("\nTASK PRIORITY ORDER:")
        for i, (task, score) in enumerate(scored_tasks[:10]):  # Top 10
            logging.info(f"  {i+1}. {task['title'][:40]:40} Score: {score}")
        
        # 2. CREATE TIME GRID
        time_grid = self._create_time_grid()
        
        # 3. MARK EXISTING SCHEDULES AS BUSY
        self._mark_busy_slots(time_grid, existing_schedules)

        merged_tasks = self._merge_duplicate_tasks(tasks)
        
        # 4. PLACE TASKS IN OPTIMAL SLOTS
        new_schedule = []
        
        for task in sorted_tasks:
            best_slot = self._find_best_slot_for_task(task, time_grid)
            
            if best_slot:
                # Occupy the slot
                self._occupy_slot(time_grid, best_slot)
                
                # Create schedule item với thời gian AM/PM
                new_item = self._create_schedule_item(task, best_slot)
                new_schedule.append(new_item)
                
                # Log placement
                task_title = task['title'][:30]
                start_ampm = format_time_to_ampm(best_slot['start'])
                end_ampm = format_time_to_ampm(best_slot['end'])
                logging.info(f"Placed: '{task_title}' at {best_slot['day']} {start_ampm}-{end_ampm}")
            else:
                logging.warning(f"Could not place: {task['title'][:30]}")
        
        # 5. MERGE WITH EXISTING
        final_schedule = self._merge_schedules(existing_schedules, new_schedule)
        
        # 6. ADD SCHEDULE ANALYSIS
        self._log_schedule_analysis(final_schedule)
        
        return final_schedule
    
    def _merge_duplicate_tasks(self, tasks):
        """Merge tasks with same title và CỘNG DỒN duration"""
        task_dict = {}
        
        for task in tasks:
            title = task.get('title', '').strip().lower()
            if not title:
                continue
                
            # FIX: Convert to int
            duration_raw = task.get('duration', 60)
            try:
                if hasattr(duration_raw, 'as_integer_ratio'):  # Decimal type
                    duration = int(duration_raw)
                else:
                    duration = int(float(duration_raw))
            except (TypeError, ValueError):
                duration = 60
            
            if title not in task_dict:
                # Task mới
                task_dict[title] = task.copy()
                task_dict[title]['merged_count'] = 1
                task_dict[title]['total_duration'] = duration
                task_dict[title]['original_durations'] = [duration]
            else:
                # Cộng dồn duration và tăng count
                existing = task_dict[title]
                existing['merged_count'] = existing.get('merged_count', 0) + 1
                existing['total_duration'] = existing.get('total_duration', 0) + duration
                existing['original_durations'].append(duration)
                
                # Giữ deadline gần nhất
                existing_deadline = existing.get('deadline')
                task_deadline = task.get('deadline')
                if task_deadline and (not existing_deadline or task_deadline < existing_deadline):
                    existing['deadline'] = task_deadline
        
        # Convert back to list với TỔNG duration
        merged_list = []
        for title, task in task_dict.items():
            merged_task = task.copy()
            
            # Sử dụng tổng duration
            merged_task['duration'] = task['total_duration']
            
            # Đánh dấu đã gộp
            merged_task['is_merged'] = True
            merged_task['original_task_count'] = task['merged_count']
            
            if task['merged_count'] > 1:
                logging.info(f"Merged {task['merged_count']} duplicate tasks: '{title}' (total duration: {task['total_duration']} mins)")
            
            merged_list.append(merged_task)
        
        return merged_list
    
    def _create_time_grid(self):
        """Create a 30-minute time grid for the week"""
        grid = {}
        
        for day in self.days:
            grid[day] = {}
            
            # Chỉ tạo grid trong khoảng thời gian làm việc
            dummy_date = datetime(2000, 1, 1).date()
            current = datetime.combine(dummy_date, self.start_time)
            end_dt = datetime.combine(dummy_date, self.end_time)
            
            # Đảm bảo không tạo grid ngoài giờ làm việc
            while current < end_dt:
                time_key = current.strftime("%H:%M")
                grid[day][time_key] = {
                    'available': True,
                    'task_id': None,
                    'hour': current.hour,
                    'minute': current.minute
                }
                current += timedelta(minutes=30)
        
        return grid
    
    def _mark_busy_slots(self, grid, existing_schedules):
        """Mark slots in the grid as busy based on existing schedules"""
        logging.info(f"Marking {len(existing_schedules)} constraints as busy slots")
        
        for idx, item in enumerate(existing_schedules):
            day = item.get('day_of_week')
            start_raw = item.get('start_time')
            end_raw = item.get('end_time')
            subject = item.get('subject', 'Unknown')
            
            if day in grid and start_raw and end_raw:
                # Đơn giản hóa: chuyển mọi format về time
                try:
                    if isinstance(start_raw, str):
                        # Nếu là string
                        if ':' in start_raw:
                            parts = start_raw.split(':')
                            start_time = time(hour=int(parts[0]), minute=int(parts[1]) if len(parts) > 1 else 0)
                        else:
                            continue
                    elif isinstance(start_raw, time):
                        start_time = start_raw
                    elif isinstance(start_raw, timedelta):
                        seconds = start_raw.seconds
                        start_time = time(hour=seconds//3600, minute=(seconds%3600)//60)
                    else:
                        continue
                    
                    if isinstance(end_raw, str):
                        if ':' in end_raw:
                            parts = end_raw.split(':')
                            end_time = time(hour=int(parts[0]), minute=int(parts[1]) if len(parts) > 1 else 0)
                        else:
                            continue
                    elif isinstance(end_raw, time):
                        end_time = end_raw
                    elif isinstance(end_raw, timedelta):
                        seconds = end_raw.seconds
                        end_time = time(hour=seconds//3600, minute=(seconds%3600)//60)
                    else:
                        continue
                    
                    # Đảm bảo end_time > start_time
                    if end_time <= start_time:
                        continue
                    
                    # Log constraint
                    start_ampm = format_time_to_ampm(start_time)
                    end_ampm = format_time_to_ampm(end_time)
                    logging.debug(f"  Constraint {idx+1}: {day} {start_ampm}-{end_ampm} - {subject}")
                    
                    # Mark slots
                    dummy_date = datetime(2000, 1, 1).date()
                    current = datetime.combine(dummy_date, start_time)
                    end_dt = datetime.combine(dummy_date, end_time)
                    
                    slots_marked = 0
                    while current < end_dt:
                        time_key = current.strftime("%H:%M")
                        if time_key in grid[day]:
                            grid[day][time_key]['available'] = False
                            slots_marked += 1
                        current += timedelta(minutes=30)
                    
                    logging.debug(f"    Marked {slots_marked} slots as busy")
                        
                except Exception as e:
                    logging.debug(f"Error marking busy slot: {e}, item: {item}")
    
    def _find_best_slot_for_task(self, task, grid):
        """Find the best available slot for a task"""
        best_score = -1
        best_slot_info = None
        duration_raw = task.get('duration', 60)
        
        # FIX: Convert duration to int (handle Decimal)
        try:
            if isinstance(duration_raw, decimal.Decimal):
                duration = int(duration_raw)
            else:
                duration = int(duration_raw)
        except (TypeError, ValueError):
            duration = 60
        
        # Log task info
        logging.info(f"Looking for slot for: '{task['title'][:30]}' (Duration: {duration} mins)")
        
        # Convert duration to number of 30-minute slots needed
        slots_needed = max(1, int(duration / 30))
        
        for day in self.days:
            day_slots = list(grid[day].items())
            
            for i in range(len(day_slots) - slots_needed + 1):
                # Check if consecutive slots are available
                all_available = True
                for j in range(slots_needed):
                    if not day_slots[i + j][1]['available']:
                        all_available = False
                        break
                
                if not all_available:
                    continue
                
                # Get slot info
                start_time_key = day_slots[i][0]
                start_hour = day_slots[i][1]['hour']
                start_minute = day_slots[i][1]['minute']
                
                # Check if slot is within working hours
                start_dt = datetime.strptime(start_time_key, "%H:%M")
                end_dt = start_dt + timedelta(minutes=duration)
                end_time = end_dt.time()
                
                # Đảm bảo không vượt quá end_time của scheduler
                if end_time > self.end_time:
                    continue  # Skip slot này, tìm slot khác
                
                # Calculate score for this slot
                slot_score = self._calculate_slot_score(day, start_hour, task)
                
                # Bonus for fitting perfectly in available window
                if slot_score > best_score:
                    best_score = slot_score
                    best_slot_info = {
                        'day': day,
                        'start': start_dt.time(),
                        'end': end_time,
                        'score': slot_score
                    }
        
        if best_slot_info:
            start_ampm = format_time_to_ampm(best_slot_info['start'])
            end_ampm = format_time_to_ampm(best_slot_info['end'])
            logging.info(f"  Best slot found: {best_slot_info['day']} {start_ampm}-{end_ampm}")
        else:
            logging.warning(f"  No slot found for task! Duration may be too long or no available slots.")
        
        return best_slot_info
    
    def _occupy_slot(self, grid, slot):
        """Mark a slot as occupied in the grid"""
        day = slot['day']
        start_time = slot['start']
        end_time = slot['end']
        
        # Calculate which slots to occupy
        dummy_date = datetime(2000, 1, 1).date()
        current = datetime.combine(dummy_date, start_time)
        end_dt = datetime.combine(dummy_date, end_time)
        
        while current < end_dt:
            time_key = current.strftime("%H:%M")
            if time_key in grid[day]:
                grid[day][time_key]['available'] = False
            current += timedelta(minutes=30)
    
    def _create_schedule_item(self, task, slot):
        """Create a schedule item with learning style tips - LUÔN dùng AM/PM"""
        # Format thời gian với AM/PM
        start_time_ampm = format_time_to_ampm(slot['start'])
        end_time_ampm = format_time_to_ampm(slot['end'])
        
        # Base item
        item = {
            'task_id': task.get('task_id'),
            'subject': task['title'],
            'description': task.get('description', ''),
            'type': self._infer_task_type(task),
            'day_of_week': slot['day'],
            'start_time': start_time_ampm,  # LUÔN là AM/PM
            'end_time': end_time_ampm,      # LUÔN là AM/PM
            'collection_id': task.get('collection_id', 0)
        }
        
        # Add learning style tips
        ls = self.profile.get('learning_style')
        if ls:
            style = ls.get('primary_style', '').upper()
            tips = {
                'VISUAL': "Dùng sơ đồ tư duy, highlight quan trọng",
                'AUDITORY': "Ghi âm, thảo luận nhóm, giảng lại cho người khác",
                'KINESTHETIC': "Viết ghi chú, làm bài tập thực hành"
            }
            
            for style_key, tip in tips.items():
                if style_key in style:
                    item['description'] += tip
                    break
        
        return item
    
    def _merge_schedules(self, existing, new):
        """Merge existing and new schedules, remove duplicates - LUÔN dùng AM/PM"""
        final = []
        seen_keys = set()
        
        # Helper để tạo key duy nhất
        def create_unique_key(item):
            # Sử dụng format AM/PM cho key
            start_time = format_time_to_ampm(item.get('start_time'))
            end_time = format_time_to_ampm(item.get('end_time'))
            subject = item.get('subject', '').strip().lower()
            day = item.get('day_of_week', '')
            
            return f"{day}_{start_time}_{end_time}_{subject}"
        
        # Thêm các fixed classes (existing)
        for item in existing:
            # Đảm bảo thời gian là AM/PM
            start_time = format_time_to_ampm(item.get('start_time'))
            end_time = format_time_to_ampm(item.get('end_time'))
            
            key = create_unique_key(item)
            
            if key not in seen_keys:
                seen_keys.add(key)
                final.append({
                    'taskId': item.get('task_id'),
                    'subject': item.get('subject', item.get('title', 'Class')),
                    'description': item.get('description', ''),
                    'type': 'class',
                    'dayOfWeek': item.get('day_of_week'),
                    'startTime': start_time,
                    'endTime': end_time,
                    'collectionId': item.get('collection_id'),
                    'isFixed': True
                })
        
        # Thêm scheduled items (new)
        for item in new:
            # Đảm bảo thời gian là AM/PM
            start_time = format_time_to_ampm(item['start_time'])
            end_time = format_time_to_ampm(item['end_time'])
            
            key = create_unique_key(item)
            
            if key not in seen_keys:
                seen_keys.add(key)
                final.append({
                    'taskId': item.get('task_id'),
                    'subject': item['subject'],
                    'description': item.get('description', ''),
                    'type': item.get('type', 'self-study'),
                    'dayOfWeek': item['day_of_week'],
                    'startTime': start_time,
                    'endTime': end_time,
                    'collectionId': item.get('collection_id'),
                    'isFixed': False
                })
        
        return final
    
    def _log_schedule_analysis(self, schedule):
        """Log analysis of the generated schedule"""
        if not schedule:
            return
        
        logging.info("\nSCHEDULE ANALYSIS:")
        
        # Count by day
        day_counts = {}
        for item in schedule:
            day = item.get('dayOfWeek')
            day_counts[day] = day_counts.get(day, 0) + 1
        
        logging.info(f"Total items scheduled: {len(schedule)}")
        for day, count in sorted(day_counts.items()):
            logging.info(f"  {day}: {count} items")
        
        # Calculate total study hours
        total_hours = 0
        for item in schedule:
            try:
                # Parse từ format AM/PM
                start_str = item['startTime']
                end_str = item['endTime']
                
                # Chuyển từ AM/PM sang 24h để tính
                start_dt = datetime.strptime(start_str.replace(' SA', ' AM').replace(' CH', ' PM'), "%H:%M:%S %p")
                end_dt = datetime.strptime(end_str.replace(' SA', ' AM').replace(' CH', ' PM'), "%H:%M:%S %p")
                
                hours = (end_dt - start_dt).seconds / 3600
                total_hours += hours
            except Exception as e:
                logging.debug(f"Error calculating hours: {e}")
        
        logging.info(f"Total study hours: {total_hours:.1f}h")
        
        # Check for exam tasks
        exam_tasks = [item for item in schedule if 'exam' in item.get('type', '').lower() or 
                     any(word in item.get('subject', '').lower() for word in ['thi', 'exam'])]
        
        if exam_tasks:
            logging.info(f"Exam-related tasks scheduled: {len(exam_tasks)}")
            for task in exam_tasks[:3]:  # Show first 3
                logging.info(f"  - {task['dayOfWeek']} {task['startTime'][:8]}: {task['subject'][:40]}")


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
    priority_focus = data.get('priorityFocus', 'balance')
    
    if not user_id or not collection_id:
        return jsonify({'error': 'Missing user_id or collection_id'}), 400
        
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
         # 1. Fetch Context
        profile = fetch_user_profile(conn, user_id)
        all_tasks = fetch_pending_tasks(conn, collection_id)
        
        # 2. Lấy các lớp học cố định
        fixed_classes = fetch_fixed_classes(conn, collection_id)
        
        # DEBUG: Log fixed classes format
        logging.info("DEBUG - Fixed classes format check:")
        for fc in fixed_classes:
            logging.info(f"  {fc['dayOfWeek']}: {fc['startTime']} - {fc['endTime']} (has SA/CH: {'SA' in fc['startTime'] or 'CH' in fc['startTime']})")
        fixed_classes = fetch_fixed_classes(conn, collection_id)
        
        # 3. Lấy các schedule items KHÔNG phải class và KHÔNG phải self-study
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT * FROM user_schedule 
            WHERE collection_id = %s 
              AND type != 'self-study'
              AND type != 'class'
              AND type IS NOT NULL
        """
        cursor.execute(query, (collection_id,))
        other_constraints = cursor.fetchall()
        cursor.close()
        
        # 4. LOG
        logging.info("=" * 60)
        logging.info("FIXED CLASSES (should not be moved):")
        for fc in fixed_classes:
            logging.info(f"  {fc['dayOfWeek']} {fc['startTime'][:8]}-{fc['endTime'][:8]}: {fc['subject']}")
        
        logging.info(f"OTHER CONSTRAINTS: {len(other_constraints)} items")
        
        # 5. TẠO ALL CONSTRAINTS: chỉ fixed classes + other constraints
        all_constraints = []
        
        # Convert fixed classes sang format constraint
        for fc in fixed_classes:
            all_constraints.append({
                'day_of_week': fc['dayOfWeek'],
                'start_time': fc['startTime'],
                'end_time': fc['endTime'],
                'type': 'class',
                'subject': fc['subject'],
                'task_id': fc.get('taskId')
            })
        
        # Thêm other constraints
        for oc in other_constraints:
            # Đảm bảo thời gian là AM/PM
            oc['start_time'] = format_time_to_ampm(oc.get('start_time'))
            oc['end_time'] = format_time_to_ampm(oc.get('end_time'))
            all_constraints.append(oc)
        
        # 6. Tasks to Schedule (chỉ self-study tasks)
        tasks_to_schedule = all_tasks
        
        logging.info(f"Generating schedule. Start: {start_time_str}, End: {end_time_str}")
        logging.info(f"Total constraints: {len(all_constraints)} (fixed classes + other)")
        logging.info(f"Scheduling {len(tasks_to_schedule)} self-study tasks.")
        
        # 7. Run Scheduler với constraints
        scheduler = SmartScheduler(start_time_str, end_time_str, include_weekends, profile, priority_focus)
        
        # Schedule các task self-study, tôn trọng constraints
        scheduled_self_study = scheduler.generate_schedule(tasks_to_schedule, all_constraints)
        
        # 8. Kết hợp: Fixed Classes + Scheduled Self-Study
        # Loại bỏ trùng lặp triệt để bằng key duy nhất
        final_output = []
        seen_keys = set()
        
        # Helper để tạo key duy nhất
        def create_unique_key(item):
            # Chuẩn hóa subject (bỏ khoảng trắng thừa, chuyển lowercase)
            subject = item.get('subject', '').strip().lower()
            day = item.get('dayOfWeek', '')
            start_time = item.get('startTime', '')
            end_time = item.get('endTime', '')
            
            return f"{day}_{start_time}_{end_time}_{subject}"
        
        # Thêm fixed classes trước
        for fc in fixed_classes:
            key = create_unique_key(fc)
            if key not in seen_keys:
                seen_keys.add(key)
                fc['isFixed'] = True
                final_output.append(fc)
        
        # Thêm scheduled self-study (loại bỏ trùng lặp)
        for item in scheduled_self_study:
            key = create_unique_key(item)
            if key not in seen_keys:
                seen_keys.add(key)
                item['isFixed'] = False
                final_output.append(item)
        
        # 9. Log kết quả
        logging.info("\nFINAL SCHEDULE COMPOSITION (AFTER DEDUPLICATION):")
        logging.info(f"  Fixed classes: {len(fixed_classes)}")
        logging.info(f"  Scheduled self-study items: {len(scheduled_self_study)}")
        logging.info(f"  Final unique items: {len(final_output)}")
        
        # Debug: Log tất cả items
        logging.info("\nALL UNIQUE ITEMS IN FINAL SCHEDULE:")
        for i, item in enumerate(final_output):
            is_fixed = item.get('isFixed', False)
            prefix = "FIXED" if is_fixed else "SELF-STUDY"
            start_time = item.get('startTime', 'N/A')
            end_time = item.get('endTime', 'N/A')
            logging.info(f"  {i+1:2d}. {prefix}: {item.get('dayOfWeek')} {start_time}-{end_time} - {item.get('subject')[:40]}")
        
        return jsonify(final_output)

    except Exception as e:
        logging.error(f"Error generating schedule: {e}", exc_info=True)
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

#test
if __name__ == '__main__':
    # Run server
    app.run(host='0.0.0.0', port=5000, debug=True)