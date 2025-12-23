import logging
import sys
import os
from datetime import datetime

# Reset logging to ensure output goes to stdout
root = logging.getLogger()
if root.handlers:
    for handler in root.handlers:
        root.removeHandler(handler)
logging.basicConfig(level=logging.INFO, stream=sys.stdout, format='[AI] %(message)s')

# Import app logic
sys.path.append(os.getcwd())
from app import SmartScheduler

def create_mock_tasks():
    return [
        {'task_id': 1, 'title': 'High Priority Task', 'priority': 'high', 'duration': 60, 'description': 'Urgent work', 'type': 'work'},
        {'task_id': 2, 'title': 'Medium Task', 'priority': 'medium', 'duration': 60, 'description': 'Normal', 'type': 'misc'},
        {'task_id': 3, 'title': 'Low Priority Task', 'priority': 'low', 'duration': 60, 'description': 'Learning', 'type': 'study'},
    ]

def create_existing_schedule():
    # Only one existing meeting on Monday 10:00 - 11:00
    return [
        {'day_of_week': 'Mon', 'start_time': '10:00:00', 'end_time': '11:00:00', 'subject': 'Existing Meeting (Fixed)', 'task_id': 0}
    ]

def run_test(mode):
    print(f"\n{'='*20} TESTING MODE: {mode.upper()} {'='*20}")
    
    # Profile
    profile = {'work_style': {'analysis_score': 50, 'creativity_score': 50, 'teamwork_score': 50}}
    
    # Scheduler: 8am - 5pm
    scheduler = SmartScheduler('08:00', '17:00', False, profile, priority_focus=mode)
    scheduler.days = ['Mon'] # Force Mon only for simulation
    
    tasks = create_mock_tasks()
    existing = create_existing_schedule()
    
    # Run
    schedule = scheduler.generate_schedule(tasks, existing)
    
    # Sort
    schedule.sort(key=lambda x: x['startTime'])
    
    # Print Resulttable
    print(f"{'Time':<20} | {'Subject':<30} | {'Score/Info'}")
    print("-" * 70)
    
    for item in schedule:
        start = item['startTime']
        end = item['endTime']
        subj = item['subject']
        
        # Check if it was fixed (manual)
        is_fixed = item.get('isFixed', False)
        
        # Try to find log info from app logs (simulated by just checking type)
        extra = ""
        if is_fixed:
            extra = "(Manual Constraint)"
        else:
            # We can't easily see the score calculated inside the function unless we return it
            # But we can verify order and placement
            extra = f"Type: {item['type']}"
            
        print(f"{start[:5]}-{end[:5]:<14} | {subj:<30} | {extra}")

if __name__ == "__main__":
    run_test('balance')
    run_test('deadline')
    run_test('relax')
    run_test('focus')
