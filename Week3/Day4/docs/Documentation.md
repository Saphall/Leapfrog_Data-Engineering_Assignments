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
### i. `Schema/create_raw_employee_table.sql` file:
``` 
CREATE TABLE raw_employee(
	employee_id VARCHAR(500),
    first_name VARCHAR(500),
    last_name VARCHAR(500),
    department_id VARCHAR(500),
    department_name VARCHAR(500),
    manager_employee_id VARCHAR(500),
    employee_role VARCHAR(500),
    salary VARCHAR(500),
    hire_date VARCHAR(500),
    terminated_date VARCHAR(500),
    terminated_reason VARCHAR(500),
    dob VARCHAR(500),
    fte VARCHAR(500),
    location VARCHAR(500)
);
```
Here I created a table `raw_employee` with necessary columns from dataset in data/.

All entities are declared `VARCHAR(500)` because, for a bulk datas to extract, we may not delare exact datatypes which may cause problems later.
For example: Format for date `2021-12-12` can come as `12-12-2021` and thus declaring datatypes may cause problem later. So, lets create talbe with all VARCHAR types.

### ii. `schema/create_raw_timesheet_table.sql` file:
```
CREATE TABLE raw_timesheet(
	employee_id VARCHAR(500),	
	cost_center	VARCHAR(500),
	punch_in_time VARCHAR(500),	
	punch_out_time VARCHAR(500),	
	punch_apply_date VARCHAR(500),	
	hours_worked VARCHAR(500),	
	paycode VARCHAR(500)
);
```
This is SQL file to create `raw_timesheet` table according to dataset in data/.

### iii.  `schema/create_employee_table_archieve.sql` file:
```
CREATE TABLE raw_employee_archieve(
	employee_id VARCHAR(500),
    first_name VARCHAR(500),
    last_name VARCHAR(500),
    department_id VARCHAR(500),
    department_name VARCHAR(500),
    manager_employee_id VARCHAR(500),
    employee_role VARCHAR(500),
    salary VARCHAR(500),
    hire_date VARCHAR(500),
    terminated_date VARCHAR(500),
    terminated_reason VARCHAR(500),
    dob VARCHAR(500),
    fte VARCHAR(500),
    location VARCHAR(500),
    file_name VARCHAR(500)
);
```  
This is SQL file to create `raw_employee_archieve` table to archieve `raw_employee` table after extraction.

### iv.  `schema/create_timesheet_table_archieve.sql` file:
```
CREATE TABLE raw_timesheet_archieve(
	employee_id VARCHAR(500),	
	cost_center	VARCHAR(500),
	punch_in_time VARCHAR(500),	
	punch_out_time VARCHAR(500),	
	punch_apply_date VARCHAR(500),	
	hours_worked VARCHAR(500),	
	paycode VARCHAR(500),
    file_name VARCHAR(500)
);
```  
This is SQL file to create `raw_timesheet_archieve` table to archieve `raw_timesheet` table after extraction.

### v. `schema/create_department_table.sql` file:
This file helps to create distinct `department` table.
```
CREATE TABLE department(
 	id serial PRIMARY KEY,
 	client_department_id VARCHAR(255),
 	department_name VARCHAR(255)
); 
```
### vi. `schema/create_employee_table.sql` file:
This file helps to create `employee` table.
```
CREATE TABLE employee(
id SERIAL PRIMARY KEY,
client_employee_id VARCHAR(255),
first_name VARCHAR(255),
last_name VARCHAR(255),
department_id INT,
manager_employee_id VARCHAR(255),
salary FLOAT,
hire_date DATE,
term_date DATE,
term_reason VARCHAR(255),
dob DATE,
fte FLOAT,
weekly_hours FLOAT,
role VARCHAR(255),
FOREIGN KEY (department_id) REFERENCES department(id) 
);
```


### vii. `schema/create_timesheet_table.sql` file:
This file helps to create `timesheet` table.
```
CREATE TABLE timesheet (
id SERIAL PRIMARY KEY,
employee_id VARCHAR(255),
department_id INT,
shift_start_time TIME,
shift_end_time TIME,
shift_date DATE,
shift_type VARCHAR(255),
hours_worked FLOAT,
attendance BOOLEAN,
has_taken_break BOOLEAN,
break_hour FLOAT,
was_charge BOOLEAN,
charge_hour FLOAT, 
Was_on_call BOOLEAN,
on_call_hour FLOAT,
num_teammates_absent INT,
FOREIGN KEY (department_id) REFERENCES department(id) 
);
```


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

`file_name` = Name of file to keep as file_name in insert-into-archieve sql query.

`insertArchieveSqlFilePath` = Path of file that contains insert-into-archieve query.

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

archieveTable(destination_database, destination_table_name,filePath,'../sql/extract_raw_timesheet_archieve.sql')

```


## 5. Different sql files in src/sql/ :

### i. `extract_raw_employee_archieve.sql` file:
This file contains `INSERT` query to archieve `raw_employee` table into `raw_employee_archieve` data like:
```
INSERT INTO raw_employee_archieve(
    employee_id ,
    first_name ,
    last_name ,
    department_id ,
    department_name ,
    manager_employee_id ,
    employee_role ,
    salary ,
    hire_date ,
    terminated_date ,
    terminated_reason ,
    dob ,
    fte ,
    location ,
    file_name 
) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);
```

### ii. `extract_raw_timesheet_archieve.sql` file:
This file contains `INSERT` query to archieve `raw_timesheet` table into `raw_timesheet_archieve` data like:
```
INSERT INTO raw_timesheet_archieve(
	employee_id ,	
	cost_center	,
	punch_in_time ,	
	punch_out_time ,	
	punch_apply_date ,	
	hours_worked ,	
	paycode ,
    file_name 
) 
VALUES (%s,%s,%s,%s,%s,%s,%s,%s);
```

### iii. `extract_department_from_raw.sql` file:
This file helps to `INSERT` values to `department` dimenstion table after selecting the distinct department from `raw_employee` table.
First, the data in table are deleted and then inserted with values.

### iv. `extract_employee_from_raw.sql` file:
This file helps us to transform data in `raw_employee` table to data of our need. 
The data is transformed as per our need and inserted into `employee` fact table. Steps are expalined in [Extract_employee_data.md]() clearly.

### v. `extract_timesheet_from_raw.sql` file:
This file helps us to transfrom data from `raw_timesheet` table into data of our need. First, the data of our need is seleced , then it is inserted into `timesheet` fact table. Steps are explained in [Extract_timesheet_data.md]() clearly.
