> ## The file structure of this repo:
```
data/             # Folder containing the datasets in different formats.
  *.json
  *.csv
  *.xml 
docs/             # Folder containing .md files for assignment.      
  *.md
schema/           # Folder containing different create sql queries.
  *.sql    
src/
  pipeline/       # Folder containing python scripts    
    *.py
  sql/            # Folder containing DQL/DML.
    *.sql
```

## 1. Let me explain about different sql files in schema.
* `create_source_table_with_data.sql` file:
This file contains the SQL queries to create a example source-tables with data in Source Database. The content of this file is [here.](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day3/schema/create_source_table_with_data.sql)

* `create_raw_sales_data_table.sql` file:
```
CREATE TABLE raw_sales_data(
User_id VARCHAR(500),
username VARCHAR(500),
Product_id VARCHAR(500),
Product_name VARCHAR(500),
category_id VARCHAR(500),
category_name VARCHAR(500),
Current_price VARCHAR(500),
Sold_price VARCHAR(500),
Sold_quantity VARCHAR(500),
Remainig_quantity VARCHAR(500),
Sales_date VARCHAR(500)
);
```
Here I created a table `raw_sales_data` in Destination Database with necessary columns to extract data fetched from Source Database.

All entities are declared `VARCHAR(500)` because, for a bulk datas to extract, we may not delare exact datatypes which may cause problems later.
For example: Format for date `2021-12-12` can come as `12-12-2021` and thus declaring datatypes may cause problem later. So, lets create talbe with all VARCHAR types.

* `create_raw_sales_data_archieve_table.sql` file: 
```
CREATE TABLE raw_sales_data_archieve(
User_id VARCHAR(500),
username VARCHAR(500),
Product_id VARCHAR(500),
Product_name VARCHAR(500),
category_id VARCHAR(500),
category_name VARCHAR(500),
Current_price VARCHAR(500),
Sold_price VARCHAR(500),
Sold_quantity VARCHAR(500),
Remainig_quantity VARCHAR(500),
Sales_date VARCHAR(500),
file_name VARCHAR(500)
);
```
Here I created a archieve table to archive a copy of the raw data after extraction. The `file_name` is the name of archieve file which helps to keep track of our archieve.

ALl entities are again declared VARCHAR for same problem above.


## 2. `database_connection.py` file in  src/pipeline/ :

We connect to Postgresql database regularly in each script through `psycohpg2` and use the cursor with connection.
```
import psycopg2
connection = psycopg2.connect(
            user=USER,
            password=PASSWORD,
            host='localhost',
            port='5432',
            database=database_name
            )
cursor = con.cursor()
```
Again, we disonnect this with commands:
```
connection.close()
cursor.close()
```

So, to declare this as module, `__init__.py` was created and following code was kept in this file.

```
import psycopg2

def databaseConnect(database_name):
    try:
        return psycopg2.connect(
            user='postgres',
            password='admin',
            host='localhost',
            port='5432',
            database=database_name
        )
    except Exception as e:
        print('[-] Exception Occured:',e)


def databaseDisconnect(connection,cursor):
    try:
        connection.close()
        cursor.close()
    except Exception as e:
        print('[-] Exception Occured:',e)
```
Here `databaseConnect(database_name):` function helps to connect to any database provided the `database_name` as argument.

And, `databaseDisconnect(connection,cursor):` function helps to close `connection` and `cursor` provided as arguments.

> We can use this file in other python files as:

```
from database_connection import *

con = databaseConnect('etl_day2')
cur = con.cursor()

....

databaseDisconnect(con,cur)
```

Preety easy !

## 3. `file_content_toString.py` file in  src/pipeline/ :
We use the sql file in `src/pipeline/` folder for different DQL/DML queries using the built-in `open()` function as: 

```
with open (filepath,'r') as file:
  content = "".join(file.readlines())
```  
Since, we use this function alot and get the content of file provided as argument as string, I created this python file so that we get the file content as string easily.

The content of this file is:
```
try:
    def file_content_toString(filepath):
        with open (filepath,'r') as file:
            content = "".join(file.readlines())
        return content
except Exception as e:
        print('[-] Exception Occured:',e)
```

We can thus use this file after importing in other python file as 
```
from file_content_toString import file_content_toString
```
Then, call the function in file like :
```
file_content_toString('../sql/extract_query_from_source_db.sql')
```

## 4. `archieveTable.py` file in  src/pipeline/ :
This file helps to keep the archive of table. Lets see how it works:

The `archieveTable()` funcion within this file takes four arguments `database_name`, `table_name`, `file_name` and `insertArchieveSqlFilePath`.

```
archieveTable(database_name,table_name,file_name,insertArchieveSqlFilepath):
```
Here , 

`database_name` = Name of Database which contains table to archieve
`table_name` = Name of Table to archieve
`file_name` = Name of file to keep as file_name in insert-into-archieve sql query like [here.](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/68ed78fdf7754809d8453bf8f16080ce54155d85/Week3/Day3/src/sql/extract_sales_data_archieve.sql#L13) 
`insertArchieveSqlFilePath` = Path of file that contains insert-into-archieve query. e.g. ['../sql/extract_sales_data_archieve.sql'](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day3/src/sql/extract_sales_data_archieve.sql)

Let me explain how this file helps to archieve:

First of all , it connect to required database.
```
conn_database = databaseConnect(database_name)
cur_database = conn_database.cursor()
```
Then, check whether destination table is archieved or not using the `file_name` to fetch whether there already a archieve or not.
     
        compare_archieve = f"select * from {table_name}_archieve where file_name ='{file_name}';"
        cur_database.execute(compare_archieve)
    
        if (cur_database.fetchall()):
                print('[-] Archieve already exists !')

Else, the archieve of `table_name` is made as `table_name_archieve` using the `insertArchieveSqlFilePath` query content.

```
else:
            extractSql = f'SELECT * from {table_name};'
            cur_database.execute(extractSql)
            datas = cur_database.fetchall()
            
            insert_into_archieveSql = file_content_toString(insertArchieveSqlFilepath)
            for row in datas:
                row = list(row)
                row.append(file_name)
                cur_database.execute(insert_into_archieveSql,row)
                conn_database.commit()
        
            print(f'[+] Archieved "{table_name}" to "{table_name}_archieve" !')
```

Thus this file can be used easily to archieve any table from any database eaily with the call like:
```
from archieveTable import archieveTable

...

archieveTable(destination_database, destination_table_name,'firstArchieve','../sql/extract_sales_data_archieve.sql')

```


## 5. Different sql files in src/sql/ :

### i. `extract_query_from_source_db.sql` file:
This file contains `SELECT` query to fetch necessary data from source database table.
```
SELECT u.id as User_id,
		u.username,
		p.id as Product_id,
		p."name" as Product_name,
		c.id as category_id,
		c."name" as category_name,
		p.price as Current_price,
		s.price as Sold_price,
		s.quantity as Sold_quantity,
		(p.quantity - s.quantity) as Remaining_quantity,
		s.updated_at as Sales_date
FROM users u 
JOIN sales s on 
	u.id = s.user_id 
JOIN products p on
	s.product_id = p.id 
JOIN categories c on
	p.category_id = c.id ;
```

### ii. `extract_raw_sales_data_into_destination_db.sql` file:
This file contains `INSERT` query to insert data ,selected from source, to destination database table.
```
INSERT INTO raw_sales_data (
    User_id,
    username,
    Product_id,
    Product_name,
    category_id,
    category_name,
    Current_price,
    Sold_price,
    Sold_quantity,
    Remainig_quantity,
    Sales_date)
    VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
  ```

  ### iii.`extract_sales_data_archieve.sql` file:
  This file contains `INSERT` query to archieve `raw_sales_data` table into `raw_sales_data_archieve` data like:
  ```
  INSERT INTO raw_sales_data_archieve (
    User_id,
    username,
    Product_id,
    Product_name,
    category_id,
    category_name,
    Current_price,
    Sold_price,
    Sold_quantity,
    Remainig_quantity,
    Sales_date,
    file_name
    )
    VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);

  ```
