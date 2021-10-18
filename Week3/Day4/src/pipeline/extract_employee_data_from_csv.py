from database_connection import *
from archieveTable import archieveTable

def extract_employee_data_from_csv(filePath):
    try:
        con = databaseConnect('etl_day2')
        cur = con.cursor()

        tableName = 'raw_employee'
        
        # empty table before extraction
        cur.execute('DELETE FROM %s' %tableName)

        with open(filePath,'r') as file:
            #skip header row
            next(file)
            cur.copy_from(file,tableName,sep=',')
        con.commit() 
        print('[+] Extraction Successful!')

        # archieve table after extraction
        archieveTable('etl_day2',tableName,filePath,'../sql/extract_raw_employee_archieve.sql')

        databaseDisconnect(con,cur)
    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_employee_data_from_csv('../../data/employee_2021_08_01.csv')
    