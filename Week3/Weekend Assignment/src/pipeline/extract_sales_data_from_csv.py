from archieveTable import archieveTable
from database_connection import *

def extract_sales_data_from_csv(filePath):
    try:
        con = databaseConnect('etl_weekend')
        cur = con.cursor()

        tableName = 'raw_sales'

        # empty table before extraction
        cur.execute('DELETE FROM %s' %tableName)

        with open(filePath,'r') as file:
            #skip header row
            next(file)
            cur.copy_from(file,tableName,sep=',')
        con.commit() 
        print('[+] Extraction Successful!')

        # archieve table after extraction
        archieveTable('etl_weekend',tableName,filePath,'../sql/extract_raw_sales_archieve.sql')

        databaseDisconnect(con,cur)
    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
   extract_sales_data_from_csv('../../data/sales_dump - Sheet1.csv')
