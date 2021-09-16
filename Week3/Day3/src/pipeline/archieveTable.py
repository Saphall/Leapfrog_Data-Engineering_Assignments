from file_content_toString import file_content_toString
from database_connection import databaseConnect

def archieveTable(database_name,table_name):
    try:
        # Connect to required database
        conn_database = databaseConnect(database_name)
        cur_database = conn_database.cursor()

        # check whether destination table is archieved or not
        compare_archieve = f"select * from {table_name}_archieve where file_name ='{table_name}';"
        cur_database.execute(compare_archieve)
    
        if (cur_database.fetchall()):
                print('[-] Archieve already exists !')
        else:
            extractSql = f'SELECT * from {table_name};'
            cur_database.execute(extractSql)
            datas = cur_database.fetchall()
            # print(datas)

            insert_into_archieveSql = file_content_toString('../sql/extract_sales_data_archieve.sql')
            for row in datas:
                row = list(row)
                row.append(table_name)
                # print(row)
                cur_database.execute(insert_into_archieveSql,row)
                conn_database.commit()
        
            print(f'[+] Archieved "{table_name}" to "{table_name}_archieve" !')

    except Exception as e:
        print('[-] Exception Occured:',e)

        
