from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_weekend')
cur = con.cursor()


def extract_dim_location():
    try:
        extract_dim_location_sql = file_content_toString('../sql/extract_dim_location.sql')
        cur.execute(extract_dim_location_sql)
        con.commit()
        print('[+] Dimension Location Extracted from Location!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_customers():
    try:
        extract_products_sql = file_content_toString('../sql/extract_dim_customer.sql')
        cur.execute(extract_products_sql)
        con.commit()
        print('[+] Dimension Customer Extracted from Customer!')

    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_dim_location()
    extract_dim_customers()
    databaseDisconnect(con,cur)