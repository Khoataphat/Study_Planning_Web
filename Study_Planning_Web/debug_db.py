
import mysql.connector
import datetime

def my_converter(o):
    if isinstance(o, datetime.timedelta):
        return str(o)
    if isinstance(o, datetime.time):
        return str(o)

try:
    conn = mysql.connector.connect(host='localhost', user='root', password='Anhang@204', database='study_planning_db')
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM user_schedule WHERE collection_id = 15')
    rows = cursor.fetchall()
    for r in rows:
        try:
            print(f"ID: {r.get('schedule_id')} | Subject: {r.get('subject', b'').decode('utf-8', 'ignore') if isinstance(r.get('subject'), bytes) else r.get('subject')} | Start: {r.get('start_time')} | TaskID: {r.get('task_id')}")
        except Exception as e:
            print(f"Error printing row: {r} -> {e}")
    conn.close()
except Exception as e:
    print(e)
