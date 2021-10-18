> # Task to be done:
## Q. Write a script to extract data from a CSV files into the database.

The script for this task can be found [here.](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day2/src/pipeline/extract_timesheet_data_from_csv.py)

Let me explain how I did this:

* # First Solution: 

## 1. Imported necessary libraries:
```
import csv
from database_connection import *
from archieveTable import archieveTable
```
Here `database_connection` is the module made in pipeline directory which I have explained in [Documentation.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day2/docs/Documentation.md) file. This helps in easy database connection.
Importing CSV helps to implement our .csv dataset.

The `archieveTable` helps to archieve tables described in [Documentaion.md](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day2/docs/Documentation.md) as well.


## 2. Function Defination 
I defined the `extract_timesheet_data_from_csv(filePath):` function which takes `filePath` as argument. `filePath` is the location of `.csv` file which is to be extracted into database.
```
def extract_timesheet_data_from_csv(filePath):
     ......
```
> ## Let me explain what this fuction does.

Fist of all, it connects to required database i.e. `etl_day2` in my context. Then we define cursor to implement queries later.
```
 con = databaseConnect('etl_day2')
 cur = con.cursor()
```

Now I declared the table where, data are to be extraceted.

```
tableName = 'raw_timesheet'
```

Lets empty this table before extraction :
```
cur.execute('DELETE FROM %s' %table_name)
```

Now I opened the dataset file as :
```
with open(filePath,'r') as file:
            reader = csv.reader(f)
            # skip header row
            next(reader)
            for row in reader:
                cur.execute('INSERT INTO raw_timesheet VALUES (%s,%s,%s,%s,%s,%s,%s)',row)
           
        con.commit() 
```

After extracting the data, we archieve table as :
```
archieveTable('etl_day2',tableName,filePath,'../sql/extract_raw_timesheet_archieve.sql')
```

Then close the connection using `databaseDisconnect(con,cur)` declared in `database_connection` which we imported earlier.

## 3. Function call with correct file-path:

Since three timesheet data are to be inserted, we call this funcion three times.

```
if __name__ == '__main__':
    extract_timesheet_data_from_csv('../../data/timesheet_2021_05_23.csv')
    extract_timesheet_data_from_csv('../../data/timesheet_2021_06_23.csv')
    extract_timesheet_data_from_csv('../../data/timesheet_2021_07_24.csv')
```
And the csv data was extracted to `etl_day2` database into `raw_timesheet` table !


* # Second Solution: 
The Postgres command to load files directy into tables is called COPY.
`psycopg2` has a method written solely for this query.
The method to load a file into a table is called copy_from. 

Hence Second solution is what is in [this script](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/Day3_Assignment/Week3/Day2/src/pipeline/extract_timesheet_data_from_csv.py).

```
from database_connection import *
from archieveTable import archieveTable

def extract_timesheet_data_from_csv(filePath):
    try:
        con = databaseConnect('etl_day2')
        cur = con.cursor()

        tableName = 'raw_timesheet'

        #empty table before extraction
        cur.execute('DELETE FROM %s' %tableName)


        with open(filePath,'r') as file:
            #skip header row
            next(file)
            cur.copy_from(file,tableName,sep=',')
        con.commit() 
        print('[+] Extraction Successful!')

        # archieve table after extraction
        archieveTable('etl_day2',tableName,filePath,'../sql/extract_raw_timesheet_archieve.sql')
        
        databaseDisconnect(con,cur)
    except Exception as e:
        print('[-] Exception Occured:',e)



if __name__ == '__main__':
    extract_timesheet_data_from_csv('../../data/timesheet_2021_05_23.csv')
    extract_timesheet_data_from_csv('../../data/timesheet_2021_06_23.csv')
    extract_timesheet_data_from_csv('../../data/timesheet_2021_07_24.csv')
```
Here opening the required file and using `copy_from()` command helps to extarct data withou using CSV module.
```
 cur.copy_from(file,tableName,sep=',')
 ```
 And hence the .csv data was extracted to `raw_timesheet` table !


 
