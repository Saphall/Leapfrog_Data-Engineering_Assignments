from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_weekend')
cur = con.cursor()


def extract_category():
    try:
        extract_category_sql = file_content_toString('../sql/extract_category_from_raw.sql')
        cur.execute(extract_category_sql)
        con.commit()
        print('[+] Category Extracted from raw!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_products():
    try:
        extract_products_sql = file_content_toString('../sql/extract_product_from_raw.sql')
        cur.execute(extract_products_sql)
        con.commit()
        print('[+] Products Extracted from raw!')

    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_category()
    extract_products()
    databaseDisconnect(con,cur)