from file_content_toString import file_content_toString
from database_connection import * 

con = databaseConnect('etl_day2')
cur = con.cursor()

def extract_timesheet():
    try:
        cur.execute('DELETE FROM timesheet;')
        
        extract_timesheet_sql = file_content_toString('../sql/extract_timesheet_from_raw.sql')
        cur.execute(extract_timesheet_sql)
        con.commit()
        print('[+] Timesheet Extracted from raw!')

    except Exception as e:
        print('[-] Exception Occured:',e)


if __name__ == '__main__':
    extract_timesheet()
    databaseDisconnect(con,cur)
