from archieveTable import archieveTable
from database_connection import *

def extract_timesheet_data_from_csv(filePath):
    try:
        con = databaseConnect('etl_day2')
        cur = con.cursor()

        tableName = 'raw_timesheet'

        
        # empty table before extraction
        cur.execute('DELETE FROM %s' %tableName)

        with open(filePath,'r') as file:
            # reader = csv.reader(f)
            # print(reader)
            # next(reader) 
            #skip header row
            next(file)
            # for row in reader:
            #     print(row)
            #     cur.execute('INSERT INTO raw_timesheet VALUES (%s,%s,%s,%s,%s,%s,%s)',row)
            cur.copy_from(file,tableName,sep=',')
        con.commit() 
        print('[+] Extraction Successful!')

        # archieve table after extraction
        archieveTable('etl_day2',tableName,filePath,'../sql/extract_raw_timesheet_archieve.sql')

        databaseDisconnect(con,cur)
    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_timesheet_data_from_csv('../../data/timesheet_2021_05_23.csv')
    extract_timesheet_data_from_csv('../../data/timesheet_2021_06_23.csv')
    extract_timesheet_data_from_csv('../../data/timesheet_2021_07_24.csv')
