> # Task to be done:
## Q. Write a script to extract data from a JSON file into the database.

The script for this task can be found [here.](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day2_Assignment/Week3/Day2/src/pipeline/extract_employee_data_from_json.py)

Let me explain how I did this:

## 1. Imported necessary libraries:
```
import json
from database_connection import *;
from psycopg2.extras import Json
from archieveTable import archieveTable
```
Here `database_connection` is the module made in pipeline directory which I have explained in [Documentation.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day2_Assignment/Week3/Day2/docs/Documentation.md) file. This helps in easy database connection.

The `archieveTable` helps to archieve tables described in [Documentaion.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day2_Assignment/Week3/Day2/docs/Documentation.md) as well.

## 2. Function Defination 
I defined the `extract_employee_data_from_json(filePath)` function which takes `filePath` as argument. `filePath` is the location of `.json` file which is to be extracted into database.
```
def extract_employee_data_from_json(filePath):
     ......
```
> ## Let me explain what this fuction does.

Fist of all, it connects to required database i.e. `etl_day2` in my context. Then we define cursor to implement queries later.
```
 con = databaseConnect('etl_day2')
 cur = con.cursor()
```

Now I open this file as :
```
with open(filePath,'r') as employee_json_file:
     data  = json.load(employee_json_file)
```

Get values and column names from data using nested list.
```
values = [list(content.values()) for content in data]
columns = [list(content.keys()) for content in data][0]
```

Then declare value string for the SQL string which will be clear once I use this below.
```
values_str = ""
``` 
Then for some piece of code:
```
for i , record in enumerate(values):
   val_list = []
   for v, val in enumerate(record):
      if type(val) == str:
          val = str(Json(val)).replace('"','')
          val_list += [str(val)]
          values_str += "(" + ', '.join( val_list ) + "),\n"
```
I enumerate over the values,declare empty list for new values, append each value to a new list of values, and put parenthesis around each `values_str` string.

Then remove the last comma and end SQL with a semicolon:
```
values_str = values_str[:-2] + ";"
```

Declare TableName as `table_name = 'raw_employee'`.Lets empty this table before extraction :
```
cur.execute('DELETE FROM %s' %table_name)
```

And execute SQL script:
```
 sql = "INSERT INTO %s (%s)\n VALUES %s" %(
                table_name,
                ', '.join(columns),
                values_str)
cur.execute(sql)
con.commit()
```
After extracting the data, we archieve table as :
```
archieveTable('etl_day2',table_name,filePath,'../sql/extract_raw_employee_archieve.sql')
```
The `archieveTable()` functionality is described in [Documentation.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day2_Assignment/Week3/Day2/docs/Documentation.md)


Then close the connection using `databaseDisconnect(con,cur)` declared in database_connection which we imported earlier.

## 3. Function call with correct file-path:
```
if __name__ == '__main__':
    extract_employee_data_from_json('../../data/employee_2021_08_01.json')
```
And the json data was extracted to `etl_day2` database and `raw_employee` table !




