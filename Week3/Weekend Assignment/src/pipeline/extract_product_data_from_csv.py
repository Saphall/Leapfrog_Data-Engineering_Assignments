from archieveTable import archieveTable
from database_connection import *

def extract_product_data_from_csv(filePath):
    try:
        con = databaseConnect('etl_weekend')
        cur = con.cursor()

        tableName = 'raw_products'

        # empty table before extraction
        cur.execute('DELETE FROM %s' %tableName)

        with open(filePath,'r') as file:
            #skip header row
            next(file)
            cur.copy_from(file,tableName,sep=',')
        con.commit() 
        print('[+] Extraction Successful!')

        # archieve table after extraction
        archieveTable('etl_weekend',tableName,filePath,'../sql/extract_raw_product_archieve.sql')

        databaseDisconnect(con,cur)
    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
   extract_product_data_from_csv('../../data/product_dump - Sheet1.csv')
