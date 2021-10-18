from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_weekend')
cur = con.cursor()


def extract_employee():
    try:
        extract_employee_sql = file_content_toString('../sql/extract_employee_from_raw.sql')
        cur.execute(extract_employee_sql)
        con.commit()
        print('[+] Employee Extracted from raw!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_sales():
    try:
        extract_sales_sql = file_content_toString('../sql/extract_sales_from_raw.sql')
        cur.execute(extract_sales_sql)
        con.commit()
        print('[+] Sales Extracted from raw!')

    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_employee()
    extract_sales()
    databaseDisconnect(con,cur)