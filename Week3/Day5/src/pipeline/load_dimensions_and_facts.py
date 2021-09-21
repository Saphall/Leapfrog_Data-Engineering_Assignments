from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_day2')
cur = con.cursor()


# Dimensions
def extract_dim_department():
    try:
        extract_department_sql = file_content_toString('../sql/extract_dim_department.sql')
        cur.execute(extract_department_sql)
        con.commit()
        print('[+] Dimension Department Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_manager():
    try:
        extract_manager_sql = file_content_toString('../sql/extract_dim_manager.sql')
        cur.execute(extract_manager_sql)
        con.commit()
        print('[+] Dimension Manager Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_period():
    try:
        extract_period_sql = file_content_toString('../sql/extract_dim_period.sql')
        cur.execute(extract_period_sql)
        con.commit()
        print('[+] Dimension Period Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)

def extract_dim_role():
    try:
        extract_role_sql = file_content_toString('../sql/extract_dim_role.sql')
        cur.execute(extract_role_sql)
        con.commit()
        print('[+] Dimension Role Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_shift_type():
    try:
        extract_shift_type_sql = file_content_toString('../sql/extract_dim_shift_type.sql')
        cur.execute(extract_shift_type_sql)
        con.commit()
        print('[+] Dimension Shift_type Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_status():
    try:
        extract_status_sql = file_content_toString('../sql/extract_dim_status.sql')
        cur.execute(extract_status_sql)
        con.commit()
        print('[+] Dimension Status Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


# Facts
def extract_fact_employee():
    try:
        extract_employee_sql = file_content_toString('../sql/extract_fact_employee.sql')
        cur.execute(extract_employee_sql)
        con.commit()
        print('[+] Fact Employee Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_fact_timesheet():
    try:
        extract_timesheet_sql = file_content_toString('../sql/extract_fact_timesheet.sql')
        cur.execute(extract_timesheet_sql)
        con.commit()
        print('[+] Fact Timesheet Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


if __name__ == '__main__':
    extract_dim_department()
    extract_dim_manager()
    extract_dim_period()
    extract_dim_role()
    extract_dim_shift_type()
    extract_dim_status()

    extract_fact_employee()
    extract_fact_timesheet()
    databaseDisconnect(con,cur)