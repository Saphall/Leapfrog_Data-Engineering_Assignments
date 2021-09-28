import json
from database_connection import *;
from psycopg2.extras import Json

def extract_employee_data_from_json(filePath):
    try:
        con = databaseConnect('etl_day2')
        cur = con.cursor()

        with open(filePath,'r') as employee_json_file:
            data  = json.load(employee_json_file)
            
            values = [list(content.values()) for content in data]
            columns = [list(content.keys()) for content in data][0]
                
            values_str = ''
            for i , record in enumerate(values):
                val_list = []
                for v, val in enumerate(record):
                    if type(val) == str:
                        val = str(Json(val)).replace('"','')
                    val_list += [str(val)]
                values_str += "(" + ', '.join( val_list ) + "),\n"
    
        values_str = values_str[:-2] + ";"
       
        table_name = 'raw_employee'
        
        #empty table before extraction
        cur.execute('DELETE FROM %s' %table_name)
        
        sql = "INSERT INTO %s (%s)\n VALUES %s" %(
                table_name,
                ', '.join(columns),
                values_str)
                
        cur.execute(sql)
        con.commit()
        
        print('[+] Extraction Successful !')
        databaseDisconnect(con,cur)

    except Exception as e:
        print('[-] Exception Occured:',e)




if __name__ == '__main__':
    extract_employee_data_from_json('../../data/employee_2021_08_01.json')