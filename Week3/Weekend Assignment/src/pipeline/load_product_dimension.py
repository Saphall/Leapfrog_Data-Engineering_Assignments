from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_weekend')
cur = con.cursor()


def extract_dim_category():
    try:
        extract_dim_category_sql = file_content_toString('../sql/extract_dim_category.sql')
        cur.execute(extract_dim_category_sql)
        con.commit()
        print('[+] Dimension Category Extracted from Category!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_products():
    try:
        extract_dim_products_sql = file_content_toString('../sql/extract_dim_products.sql')
        cur.execute(extract_dim_products_sql)
        con.commit()
        print('[+] Dimension Products Extracted from Products!')

    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_dim_category()
    extract_dim_products()
    databaseDisconnect(con,cur)