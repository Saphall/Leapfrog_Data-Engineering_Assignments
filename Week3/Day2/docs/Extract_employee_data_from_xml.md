> # Task to be done:
## Q. Write a script to extract data from a XML file into the database.

The script for this task can be found [here.](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day2_Assignment/Week3/Day2/src/pipeline/extract_employee_data_from_xml.py)

Let me explain how I did this:

## 1. Imported necessary libraries:
```
from database_connection import *
from lxml import etree
```
Here `database_connection` is the module made in pipeline directory which I have explained in [Documentation.md]() file. This helps in easy database connection.
`etree` from `lxml` module helps us in parsing .xml files.

## 2. Funcion Defination 
I defined the `extract_employee_data_from_xml(filePath):` function which takes `filePath` as argument. `filePath` is the location of `.xnl` file which is to be extracted into database.
```
def extract_employee_data_from_xml(filePath):
    .....
```
> ## Let me explain what this fuction does.

Fist of all, it connects to required database i.e. `etl_day2` in my context. Then we define cursor to implement queries later.
```
 con = databaseConnect('etl_day2')
 cur = con.cursor()
```

Now I parse the file from `filePath`as :
```
parser = etree.parse(filePath)
```

The required columns in this dataset is :
```
columns = ('employee_id',
          'first_name',
          'last_name',
          'department_id',
          'department_name',
          'manager_employee_id',
          'employee_role',
          'salary',
          'hire_date',
          'terminated_date',
          'terminated_reason',
          'dob',
          'fte',
          'location')
```

Since the `.xml` file is in format:
```
<?xml version="1.0" ?>
<EmployeeList>
	<Employee>
		<employee_id> ... </employee_id>
		<first_name> ....</first_name>
	<Employee>
<EmployeeList>
```

We have to parse and get all values of `<Employee>` and get list with values of parameters under `<Employee>` i.e. <employee_id>, <first_name> et.
```
for i in parser.findall('Employee'):
   values = [i.find(n).text for n in columns]
```
Hence we get values of parameters which are declared in `columns`.

Then `SQL query` is executed to insert data into table `raw_employee`.
```
sql = '''INSERT INTO raw_employee VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'''

cur.execute(sql,values)
con.commit()
```
Then close the connection using `databaseDisconnect(con,cur)` declared in database_connection which we imported earlier.

## 3. Function call with correct file-path:
```
if __name__ == '__main__':
    extract_employee_data_from_xml('../../data/employee_2021_08_01.xml')
```
And thus xml data was extracted to `etl_day2` database and `raw_employee` table !




