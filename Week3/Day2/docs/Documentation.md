> ## The file structure of this repo:
```
data/             # Folder containing the datasets in different formats.
  *.json
  *.csv
  *.xml 
docs/           # Folder containing .md files for assignment.      
   *.md
schema/          # Folder containing different create sql queries.
  *.sql    
src/
  pipeline/      # Folder containing python scripts    
    *.py
```

## 1. Let me explain about different sql files in schema.
* `Schema/create_raw_employee_table.sql` file:
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

* `schema/create_raw_timesheet_table.sql` file:
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

ALl entities are again declared VARCHAR for same problem above.


## 2. `database_connection.py` file in  src/pipeline/database_connection.py.

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

