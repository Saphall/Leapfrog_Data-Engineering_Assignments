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
### * The model for this task is : 
<img src = '../data/warehouse(employee and timesheet).png'>

## 1. Let me explain about different sql files in schema.
### i. `Schema/create_dim_employee.sql` file:
``` 
CREATE TABLE dim_department(
   department_id serial PRIMARY KEY,
	client_department_id VARCHAR(255),
	name VARCHAR(255)
);
```
Here I created a dimension table `dim_department` with necessary columns from `department` table after transforming.


### ii. `schema/create_dim_manager.sql` file:
```
CREATE TABLE dim_manager(
	id serial primary key,
    client_employee_id VARCHAR(200),
    firt_name VARCHAR(200),
    last_name VARCHAR(200)
);
```
This is SQL file to create `dim_manager` dimesion table according to transformed `manager` table.

### iii.  `schema/create_dim_period.sql` file:
```
CREATE TABLE dim_period(
	id SERIAL primary key,
	start_date DATE,
	end_date DATE
);
```  
This is SQL file to create `dim_period` dimension table.

### iv.  `schema/create_dim_role.sql` file:
```
CREATE TABLE dim_role(
   id serial PRIMARY KEY,
	name varchar(255)
);
```  
This is SQL file to create `dim_role` dimension table.

### v. `schema/dim_shift_type.sql` file:
This file helps to create  `dim_shift_type` dimension table.
```
CREATE TABLE department(
 	id serial PRIMARY KEY,
 	client_department_id VARCHAR(255),
 	department_name VARCHAR(255)
); 
```
### vi. `schema/create_dim_status.sql` file:
This file helps to create `dim_status` dimension table.
```
CREATE TABLE dim_status (
	status_id INT PRIMARY KEY,
	status VARCHAR(10)
);
```


### vii. `schema/create_fact_employee.sql` file:
This file helps to create `employee` fact table.
```
CREATE TABLE fact_employee(
	employee_id serial primary key,
	client_employee_id VARCHAR(200),
	first_name VARCHAR(200),
	last_name VARCHAR(200),
	department_id INT,
	manager_employee_id INT,
	salary FLOAT,
	hire_date DATE,
	terminated_date DATE,
	terminated_reason VARCHAR(200),
	dob DATE,
	fte FLOAT,
	weekly_hours FLOAT,
	role_id INT,
	active_status_id INT,
	foreign key(department_id) references dim_department(department_id),
	FOREIGN KEY(manager_employee_id) REFERENCES dim_manager(id),
	FOREIGN KEY(role_id) REFERENCES dim_role(id),
	FOREIGN KEY(active_status_id) REFERENCES dim_status(status_id)	
);
```


### viiI. `schema/create_fact_timesheet.sql` file:
This file helps to create `timesheet` fact table.
```
CREATE TABLE fact_timesheet(
	id SERIAL PRIMARY KEY,
	employee_id INT,
	department_id VARCHAR(200),
	shift_start_time TIMESTAMP,
	shift_end_time TIMESTAMP,
	shift_date DATE,
	shift_type_id INT,
	is_weekend BOOL,
	time_period_id INT,
	hours_worked NUMERIC,
	attendance VARCHAR(10),
	has_taken_break BOOL,
	break_hour FLOAT,
	was_charge BOOL,
	charge_hour FLOAT,
	was_on_call BOOL,
	on_call_hour FLOAT,
	num_teammates_absent NUMERIC,
	foreign key (employee_id) references fact_employee(employee_id),
	FOREIGN KEY (shift_type_id) REFERENCES dim_shift_type(id),
	FOREIGN KEY (time_period_id) REFERENCES dim_period(id)
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

### i. `extract_dim_department.sql` file:
This file contains `INSERT` query to extract `department` table into `dim_department` table.

### ii. `extract_dim_manager.sql` file:
This file contains `INSERT` query to insert into  `dim_manager` dimension table.

### iii. `extract_dim_period.sql` file:
This file helps to `INSERT` values to `dim_period` dimenstion table.

### iv. `extract_dim_status.sql` file:
This file helps to `INSERT` values to `dim_status` dimenstion table.

### v. `extract_dim_shift.sql` file:
This file helps to `INSERT` values to `dim_shift` dimenstion table.

### vi. `extract_dim_role.sql` file:
This file helps to `INSERT` values to `dim_role` dimenstion table.

### vii. `extract_fact_employee.sql` file:
This file helps to `INSERT` values to `fact_employee` fact table.

### viii. `extract_fact_timesheet.sql` file:
This file helps to `INSERT` values to `fact_timesheet` fact table.