from database_connection import *
from lxml import etree


def extract_employee_data_from_xml(filePath):
    try:
        con = databaseConnect('etl_day2')
        cur = con.cursor()
        
        # empty table before extraction
        cur.execute('DELETE FROM raw_employee')

        parser = etree.parse(filePath)
        columns = ('employee_id','first_name','last_name','department_id','department_name','manager_employee_id','employee_role','salary','hire_date','terminated_date','terminated_reason','dob','fte','location')
        for i in parser.findall('Employee'):
        #    print(i)
            values = [i.find(n).text for n in columns]
            # print(p)
    
            sql = '''INSERT INTO raw_employee VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'''

            cur.execute(sql,values)
            con.commit()

        print('[+] Extraction Successful!')
        databaseDisconnect(con,cur)

    except Exception as e:
        print('[-] Exception Occured:',e)




if __name__ == '__main__':
    extract_employee_data_from_xml('../../data/employee_2021_08_01.xml')


