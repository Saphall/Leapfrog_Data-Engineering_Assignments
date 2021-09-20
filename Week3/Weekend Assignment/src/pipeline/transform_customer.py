from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_weekend')
cur = con.cursor()


def extract_location():
    try:
        extract_location_sql = file_content_toString('../sql/extract_location_from_raw.sql')
        cur.execute(extract_location_sql)
        con.commit()
        print('[+] Location Extracted from raw!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_customers():
    try:
        cur.execute('DELETE FROM customer;')
        extract_products_sql = file_content_toString('../sql/extract_customer_from_raw.sql')
        cur.execute(extract_products_sql)
        con.commit()
        print('[+] Customer Extracted from raw!')

    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_location()
    extract_customers()
    databaseDisconnect(con,cur)