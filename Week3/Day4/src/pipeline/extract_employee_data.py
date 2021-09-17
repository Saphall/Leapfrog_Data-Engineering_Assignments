from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_day2')
cur = con.cursor()


def extract_department():
    try:
        extract_department_sql = file_content_toString('../sql/extract_department_from_raw.sql')
        cur.execute(extract_department_sql)
        con.commit()
        print('[+] Department Extracted from raw!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_employee():
    try:
        cur.execute('DELETE FROM employee;')
        extract_employee_sql = file_content_toString('../sql/extract_employee_from_raw.sql')
        cur.execute(extract_employee_sql)
        con.commit()
        print('[+] Employee Extracted from raw!')

    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_department()
    extract_employee()
    databaseDisconnect(con,cur)