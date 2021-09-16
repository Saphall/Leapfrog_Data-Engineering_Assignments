from database_connection import *
from file_content_toString import file_content_toString
from archieveTable import archieveTable


def extract_sales_data_from_db():
    try:
        #connect to source database
        source_database = 'sourcedb'
        conn_source = databaseConnect(source_database)
        cur_source = conn_source.cursor()

        #connect to destination database
        destination_database = 'destinationdb'
        conn_destination = databaseConnect(destination_database)
        cur_destination = conn_destination.cursor()

        
        # Select respective data from source 
        selectSql = file_content_toString('../sql/extract_query_from_source_db.sql')
        cur_source.execute(selectSql)
        source_db_data = cur_source.fetchall()
        

        destination_table_name = 'raw_sales_data'

        # Empty destination table before extraction
        cur_destination.execute('DELETE FROM raw_sales_data;')


        # Extract data into destination table
        insertSql = file_content_toString('../sql/extract_raw_sales_data_into_destination_db.sql')
        for row in source_db_data:
            cur_destination.execute(insertSql,row)
        conn_destination.commit()
        print('[+] Extraction Successful !')


        #archieve destination table after extraction
        archieveTable(destination_database, destination_table_name,'firstArchieve','../sql/extract_sales_data_archieve.sql')
      

        databaseDisconnect(conn_source,cur_source)
        databaseDisconnect(conn_destination,cur_destination)

    except Exception as e:
        print('[-] Exception Occured:',e)




if __name__ == '__main__':
    extract_sales_data_from_db()
   