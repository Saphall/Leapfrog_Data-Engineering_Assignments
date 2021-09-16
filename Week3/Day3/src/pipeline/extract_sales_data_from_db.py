from database_connection import *


def extract_sales_data_from_db():
    try:
        conn_source = databaseConnect('sourcedb')
        cur_source = conn_source.cursor()

        conn_destination = databaseConnect('destinationdb')
        cur_destination = conn_destination.cursor()

        table_name = 'raw_sales_data'

        with open ('../sql/extract_raw_sales_data_into_destination_db.sql','r') as sqlFile:
            insert_into_destination = "".join(sqlFile.readlines())
            # print(insert_into_destination)

        #archieve the current table content
        

        #empty table before extraction
        cur_destination.execute('DELETE FROM raw_sales_data;')

        with open ('../sql/extract_query_from_source_db.sql','r') as sqlFile:
            extractSql = "".join(sqlFile.readlines())
            cur_source.execute(extractSql)
            result = cur_source.fetchall()
            for row in result:
                # print(row)
                cur_destination.execute(insert_into_destination,row)
                conn_destination.commit()
        

        databaseDisconnect(conn_source,cur_source)
        databaseDisconnect(conn_destination,cur_destination)
    except Exception as e:
        print('[-] Exception Occured:',e)




if __name__ == '__main__':
    extract_sales_data_from_db()