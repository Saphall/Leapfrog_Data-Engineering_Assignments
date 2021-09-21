from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_weekend')
cur = con.cursor()


def extract_dim_employee():
    try:
        extract_dim_employee_sql = file_content_toString('../sql/extract_dim_employee.sql')
        cur.execute(extract_dim_employee_sql)
        con.commit()
        print('[+] Dimension Employee Extracted from Employee!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_fact_sales():
    try:
        extract_fact_sales_sql = file_content_toString('../sql/extract_fact_sales.sql')
        cur.execute(extract_fact_sales_sql)
        con.commit()
        print('[+] Fact Sales Extracted from Sales!')

    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_dim_employee()
    extract_fact_sales()
    databaseDisconnect(con,cur)