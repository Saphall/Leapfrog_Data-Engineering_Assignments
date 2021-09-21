> ## ETL Weekend Assignment

### Logical Modeling :

> ### Business Requirements:
* To analyze sales data.
* Find trends among customers.
* Fast selling products.
* Remove products that are not doing good..

According to the requirements and dataset provided, the dimension and fact table can be: 

> #### Dimensions:
*  **dim_location** - location_id (PK) , town
*  **dim_customer** - customer_id (PK), town(FK) ,user_name,name, country ,active , total_items_bought 
*  **dim_category**  - id (PK), category
*  **dim_products** - product_id (PK), category_id (FK),product_name,description, price, mrp, pieces_per_case, weight_per_pieces,uom,brand,tax_percent, active, created_by, updated_by, updated_date
*  **dim_employee** - id (PK), employee_namede

> #### Fact:
* **fact_sales** : This table contains the data related to sales, product, customer, gross_profit, duration_for_sale,net_bill_amount etc.

> #### Logical Model:

<img src = './ETL Weekend.png'>

## 1. Let me explain about different sql files in schema.
* ### Extract:
### i. `Schema/Extract/create_raw_customer.sql` file:
This file is used to create `raw_customer` table used to store data of customer from csv.

### ii. `Schema/Extract/create_raw_product.sql` file:
This file is used to create `raw_product` table used to store data of product from csv.

### iii. `Schema/Extract/create_raw_sales.sql` file:
This file is used to create `raw_sales` table used to store data of sales from csv.

### iv. `Schema/Extract/create_raw_customer_archieve.sql` file:
This file is used to create `raw_customer_archieve` table from `raw_customer` table.

### v. `Schema/Extract/create_raw_product_archieve.sql` file:
This file is used to create `raw_product_archieve` table from `raw_product` table.

### vi. `Schema/Extract/create_raw_sales_archieve.sql` file:
This file is used to create `raw_sales_archieve` table from `raw_sales` table.

* ### Transform:
### i. `Schema/Transform/create_location.sql` file:
This file is used to create `location` table to keep transformed data from `raw_location` table.

### Ii. `Schema/Transform/create_customer.sql` file:
This file is used to create `customer` table to keep transformed data from `raw_customer` table.

### iii. `Schema/Transform/create_category.sql` file:
This file is used to create `category` table to keep transformed data from `raw_category` table.

### iv. `Schema/Transform/create_product.sql` file:
This file is used to create `product` table to keep transformed data from `raw_product` table.

### v. `Schema/Transform/create_employee.sql` file:
This file is used to create `employee` table to keep transformed data from `raw_employee` table.

### vi. `Schema/Transform/create_sales.sql` file:
This file is used to create `sales` table to keep transformed data from `raw_sales` table.

* ### Load:
### i. `Schema/Load/create_dim_location.sql` file:
This file is used to create `dim_location`  dimension table to load data from `location` table.

### ii. `Schema/Load/create_dim_customer.sql` file:
This file is used to create `dim_customer`  dimension table to load data from `customer` table.

### iii. `Schema/Load/create_dim_category.sql` file:
This file is used to create `dim_category`  dimension table to load data from `category` table.

### iv. `Schema/Load/create_dim_products.sql` file:
This file is used to create `dim_products`  dimension table to load data from `products` table.

### v. `Schema/Load/create_dim_employee.sql` file:
This file is used to create `dim_employee`  dimension table to load data from `employee` table.

### vi. `Schema/Load/create_fact_sales.sql` file:
This file is used to create `fact_sales`  fact table to load data from `sales` table.



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
## 6. Differnt python files in src/pipeline/ :
* ### Extract : 
### i. `extract_customer_data_from_csv.py` file:
This file helps to extract `raw_customer` data from csv file and also helps to create `raw_customer_archieve` at the same time.

### ii. `extract_product_data_from_csv.py` file:
This file helps to extract `raw_product` data from csv file and also helps to create `raw_product_archieve` at the same time.

### iii. `extract_sales_data_from_csv.py` file:
This file helps to extract `raw_sales` data from csv file and also helps to create `raw_sales_archieve` at the same time.

* ### Transform : 
### i. `transform_customer.py` file :
This file helps to transform data from `raw_custormer` to two tables: `location` and `customer`.

### ii. `transform_product.py` file :
This file helps to transform data from `raw_product` to two tables: `category` and `products`.

### iii. `transform_sales.py` file :
This file helps to transform data from `raw_sales` to two tables: `employee` and `sales`.

* ### Load :
### i. `load_customer_dimension` file:
This file helps to load transformed data from `transform_customer.py` to dimension tables : `dim_location` and `dim_customer`.

### ii. `load_product_dimension` file: 
This file helps to load trnasformed data from `transform_product.py` to dimension tables: `dim_category` and `dim_products`.

### iii. `load_sales_fact.py` file:
This file helps to load transformed data from `transform_sales.py` to dimension table: `dim_employee` and fact table: `fact_sales`.

Detail of these file process are expalined in [ETL_process.md]().

## 5. Different sql files in src/sql/ :

### i. `extract_raw_customer_archieve.sql` file:
This file helps to archieve `raw_customer` by updating new archieves.

### ii. `extract_raw_product_archieve.sql` file:
This file helps to archieve `raw_products`.

### iii. `extract_raw_sales_archieve.sql` file:
This file helps to archieve `raw_sales`.

### iv. `extract_location_from_raw.sql` file:
This file helps to `INSERT` values to `location` table after selecting the distinct location from `raw_customer` table.
First, the data in table are deleted and then inserted with values.

### v. `extract_customer_from_raw.sql` file:
This file helps to `INSERT` values to `customer` table after transforming from `raw_customer` table.
First, the data in table are deleted and then inserted with values.

### vi. `extract_category_from_raw.sql` file:
This file helps us to `INSERT` data from `raw_products` after selecting distinct category to `category` table.

### vi. `extract_product_from_raw.sql` file:
This file helps to `INSERT` values to `products` table after transforming from `raw_products` table.

### vii. `extract_employee_from_raw.sql` file:
This file helps us to `INSERT` data from `raw_sales` after selecting distinct employee to `employee` table.

### vii. `extract_sales_from_raw.sql` file:
This file helps to `INSERT` values to `sales` table after transforming from `raw_sales` table.

### viii. `extract_dim_category.sql` file:
This file helps to `INSERT` values to `dim_category` dimension table.

### ix. `extract_dim_product.sql` file:
This file helps to `INSERT` values to `dim_product` dimension table.

### x. `extract_dim_location.sql` file:
This file helps to `INSERT` values to `dim_location` dimension table.

### xi. `extract_dim_customer.sql` file:
This file helps to `INSERT` values to `dim_customer` dimension table.

### xii. `extract_dim_employee.sql` file:
This file helps to `INSERT` values to `dim_employee` dimension table.

### xiii. `extract_fact_sales.sql` file:
This file helps to `INSERT` values to `fact_sales` fact table.