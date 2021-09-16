> # Task to be done:
## Q. Extract data using a database as source.


The script for this task can be found [here.](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day3/src/pipeline/extract_sales_data_from_db.py)

Let me explain how I did this:

## 1. Imported necessary libraries:
```
from database_connection import *
from file_content_toString import file_content_toString
from archieveTable import archieveTable
```

Here `database_connection` is the module made in pipeline directory which I have explained in [Documentation.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day3/docs/Documentation.md) file. This helps in easy database connection.

The `archieveTable` helps to archieve tables described in [Documentaion.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day3/docs/Documentation.md) as well.

The `file_content_toString` helps to get the content of file provided as argument as string, I created this python file so that we get the file content as string easily.

## 2. Function Defination 
I defined the `extract_sales_data_from_db()::` function which connects to Source database and get required data. And this data is used to extract to `raw_sales_data` table in Destination database. Then after extraction, table is archieved.
```
def extract_sales_data_from_db():
    .....
```
> ## Let me explain what this fuction does serially.

Fist of all, it connects to source database i.e. `sourcedb` in my context. Then we define cursor to implement queries later.
```
source_database = 'sourcedb'
conn_source = databaseConnect(source_database)
cur_source = conn_source.cursor()
```

Secondly, destination database i.e. `destinationdb` in my context is also connected.Cursor for destination database is also defined.

```
destination_database = 'destinationdb'
conn_destination = databaseConnect(destination_database)
cur_destination = conn_destination.cursor()
```
Then, required source data is fetched from source database like:
```
selectSql = file_content_toString('../sql/extract_query_from_source_db.sql')
cur_source.execute(selectSql)
source_db_data = cur_source.fetchall()
```
The `file_content_toString` helps to get the content of filepath provided as argument as string. This is explained in [Documentation.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day3/docs/Documentation.md) as well.


Then we empty the destination database table as :
```
destination_table_name = 'raw_sales_data'

# Empty destination table before extraction
cur_destination.execute('DELETE FROM raw_sales_data;')
```

Then source data is extracted to destination database table as:
```
 # Extract data into destination table
insertSql = file_content_toString('../sql/extract_raw_sales_data_into_destination_db.sql')
for row in source_db_data:
    cur_destination.execute(insertSql,row)
conn_destination.commit()
print('[+] Extraction Successful !')

```

After extraction the table is archieved as:
```
#archieve destination table after extraction
archieveTable(destination_database, destination_table_name,'firstArchieve','../sql/extract_sales_data_archieve.sql')
``` 
How the `archieveTable()` function works has been described in [Documentation.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day3/docs/Documentation.md) file already.     

After successfully implementing extraction and archieve, we disconnect from source and destination database.
```
databaseDisconnect(conn_source,cur_source)
databaseDisconnect(conn_destination,cur_destination)
```

The code are kept in `try:` and `except:` block to verify any exception occuring.

## 3. Function call :
```
if __name__ == '__main__':
    extract_sales_data_from_db()
  
```
And thus `raw_sales_data` table in destination database was populated with data from source database table.After extraction, archieve table was created too !




