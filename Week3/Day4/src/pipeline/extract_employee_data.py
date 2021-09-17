from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_day2')
cur = con.cursor()

def extract_employee():
    try:
        pass

    except Exception as e:
        print('[-] Exception Occured:',e)



def extract_department():
    try:
        extract_department_sql = file_content_toString('../sql/extract_department_from_raw.sql')
        cur.execute(extract_department_sql)
        con.commit()
        print('[+] Department Extracted !')
    except Exception as e:
        print('[-] Exception Occured:',e)
 


if __name__ == '__main__':
    extract_department()