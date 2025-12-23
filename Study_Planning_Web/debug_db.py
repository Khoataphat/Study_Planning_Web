
import mysql.connector
import datetime

def my_converter(o):
    if isinstance(o, datetime.timedelta):
        return str(o)
    if isinstance(o, datetime.time):
        return str(o)

import sys
import codecs

# Force stdout to handle utf-8
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

try:
    conn = mysql.connector.connect(host='localhost', user='root', password='Anhang@204', database='study_planning_db')
    cursor = conn.cursor(dictionary=True)
    # Check all days for collection 19
    cursor.execute("SELECT * FROM user_schedule WHERE collection_id = 19 ORDER BY day_of_week, start_time")
    rows = cursor.fetchall()
    
    print(f"Found {len(rows)} records for Collection 19 on Wed.")
    
    for r in rows:
        try:
            coll_id = r.get('collection_id')
            day = r.get('day_of_week')
            start = r.get('start_time')
            end = r.get('end_time')
            
            s_seconds = start.total_seconds() if hasattr(start, 'total_seconds') else 0
            e_seconds = end.total_seconds() if hasattr(end, 'total_seconds') else 0
            
            sanity_marker = ""
            if s_seconds >= e_seconds:
                sanity_marker = "🟥 INVALID TIME (Start >= End)"

            subject = r.get('subject', b'').decode('utf-8', 'ignore') if isinstance(r.get('subject'), bytes) else r.get('subject')
            print(f"{sanity_marker} Coll: {coll_id:<4} | Day: {day:<3} | Time: {start} - {end} | Sub: {subject} | ID: {r.get('schedule_id')}")
        except Exception as e:
            print(f"Error printing row: {r.get('schedule_id')} -> {e}")
        except Exception as e:
            print(f"Error printing row: {r.get('schedule_id')} -> {e}")
            
    conn.close()
except Exception as e:
    print(f"Global Error: {e}")
