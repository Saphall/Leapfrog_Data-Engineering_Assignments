### Here, I will explain process to load into different dimensions and facts.

Our sample warehouse model:
<img src='./Sample DataWarehouse-Star Constellation.jpg'>

#### i. `dim_department`:
This dimension table was loaded with following sql query.
```
TRUNCATE TABLE fact_employee,fact_timesheet,dim_department RESTART IDENTITY;
INSERT INTO dim_department(client_department_id,name)
SELECT DISTINCT department_id,
                department_name
FROM raw_employee;
```
Here tables are truncated with restart identity, for `fact_employee`, `fact_timesheet` and `dim_department` tables because the foreign keys in those tables are associated.

For other load, truncate of different tables are done for same reason.

#### ii. `dim_manager`:
This dimension table is extracted using employee table as below:
```
TRUNCATE TABLE fact_timesheet,fact_employee,dim_manager RESTART IDENTITY;
insert into dim_manager (client_employee_id,firt_name,last_name)
SELECT DISTINCT mgr.client_employee_id ,
                mgr.first_name,
                mgr.last_name
FROM employee e
JOIN employee mgr
	ON e.manager_employee_id  = mgr.manager_employee_id;
```

#### iii. `dim_period`:
This dimension table is loaded with following sql query:
```
TRUNCATE TABLE fact_timesheet,fact_employee,dim_period;
INSERT INTO dim_period VALUES
    (1,'2021-06-22','2021-07-06'),
    (2,'2021-07-06','2021-07-20'),
    (3,'2021-07-20','2021-07-31');
```

#### iv. `dim_role`:
This dimension table is loaded with following sql query.The role describes distinct role of employee.
```
TRUNCATE TABLE fact_timesheet,fact_employee,dim_role RESTART IDENTITY;
INSERT INTO dim_role(name) 
SELECT DISTINCT role 
FROM employee
```

#### v. `dim_shift_types`:
This dimension table is loaded with following sql query.This denotes whether the shift is `Morning` or `Night`.
```
TRUNCATE TABLE fact_timesheet, dim_shift_type RESTART IDENTITY;
INSERT INTO dim_shift_type(name)
SELECT DISTINCT (CASE when shift_type IS NULL THEN '' ELSE INITCAP(shift_type) END) as name
FROM timesheet;
```

#### vi. `dim_status`:
This dimension table is loaded with following sql query.This denotes whether there is termination date for employee already marking them as `terminated` or the employee is still a `active` employee.
```
TRUNCATE TABLE fact_employee, fact_timesheet, dim_status RESTART IDENTITY;
INSERT INTO dim_status(status)
SELECT 
 DISTINCT CASE WHEN term_date IS NULL THEN 'active'
	      ELSE 'terminated'
	      END as status
FROM employee;
```

#### vii. `fact_employee`:
This fact table is loaded with following sql query.This describes different attributes according to the model above.I loaded this using the `employee` table which I extracted earlier from raw.
```
TRUNCATE TABLE fact_timesheet,fact_employee RESTART IDENTITY;
INSERT INTO fact_employee(
    client_employee_id,
    first_name,
    last_name,
    department_id,
    manager_employee_id,
    salary,
    hire_date,
    terminated_date,
    terminated_reason,
    dob,
    fte,
    weekly_hours,
    role_id,
    active_status_id)
SELECT
	e.client_employee_id,
	e.first_name,
	e.last_name,
	d.department_id as department_id,
	mgr.id as manager_id,
	e.salary,
	e.hire_date,
	CASE WHEN e.term_date IS NULL THEN NULL
		 ELSE e.term_date
		 END as terminated_date,
	e.term_reason as terminated_reason,
	e.dob,
    e.fte,
    CAST(fte AS FLOAT)*40 AS weekly_hours,
	r.id AS role_id,
	CASE WHEN e.term_date IS NULL THEN 1
		 ELSE 2
		 END as active_status_id
FROM employee e
LEFT JOIN dim_role r
	ON e.role = r.name
LEFT JOIN dim_department d
	ON e.department_id = d.department_id 
LEFT JOIN dim_manager mgr
	ON e.manager_employee_id = mgr.client_employee_id;
```

#### vii. `fact_timesheet`:
I loaded fact_timesheet using `timesheet` table which I extracted earlier in previous assignment. Thus following query was used to load the data here.
```
TRUNCATE TABLE fact_timesheet RESTART IDENTITY;
INSERT INTO fact_timesheet(
    employee_id,
	department_id ,
	shift_start_time ,
	shift_end_time ,
	shift_date ,
	shift_type_id ,
	is_weekend ,
	hours_worked ,
	attendance ,
	has_taken_break ,
	break_hour ,
	was_charge ,
	charge_hour ,
	was_on_call ,
	on_call_hour ,
	num_teammates_absent)
SELECT 
	fe.employee_id as employee_id,
	d.department_id,
    t.shift_start_time,
    t.shift_end_time,
    t.shift_date,
    ds.id as shift_type_id,
    (CASE WHEN extract(ISODOW from shift_date) IN (6,7) THEN true 
        ELSE false END) AS is_weekend,-----is_weekend,
    t.hours_worked,
    t.attendance,
    t.has_taken_break,
    t.break_hour,
    t.was_charge,
    t.charge_hour ,
    t.was_on_call,
    t.on_call_hour,
    t.num_teammates_absent
FROM timesheet t
LEFT JOIN fact_employee fe on 
    t.employee_id = fe.client_employee_id
LEFT JOIN dim_department d on 
    cast(t.department_id as varchar) = d.client_department_id
LEFT JOIN dim_shift_type ds on 
    t.shift_type = ds.name
```


### Hence, the process to load into dimensions and facts was done using `/src/pipeline/load_dimensions_and_facts.py` python script.

The content of this file is :
```
from database_connection import *
from file_content_toString import file_content_toString

con = databaseConnect('etl_day2')
cur = con.cursor()


# Dimensions
def extract_dim_department():
    try:
        extract_department_sql = file_content_toString('../sql/extract_dim_department.sql')
        cur.execute(extract_department_sql)
        con.commit()
        print('[+] Dimension Department Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_manager():
    try:
        extract_manager_sql = file_content_toString('../sql/extract_dim_manager.sql')
        cur.execute(extract_manager_sql)
        con.commit()
        print('[+] Dimension Manager Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_period():
    try:
        extract_period_sql = file_content_toString('../sql/extract_dim_period.sql')
        cur.execute(extract_period_sql)
        con.commit()
        print('[+] Dimension Period Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)

def extract_dim_role():
    try:
        extract_role_sql = file_content_toString('../sql/extract_dim_role.sql')
        cur.execute(extract_role_sql)
        con.commit()
        print('[+] Dimension Role Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_shift_type():
    try:
        extract_shift_type_sql = file_content_toString('../sql/extract_dim_shift_type.sql')
        cur.execute(extract_shift_type_sql)
        con.commit()
        print('[+] Dimension Shift_type Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_dim_status():
    try:
        extract_status_sql = file_content_toString('../sql/extract_dim_status.sql')
        cur.execute(extract_status_sql)
        con.commit()
        print('[+] Dimension Status Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


# Facts
def extract_fact_employee():
    try:
        extract_employee_sql = file_content_toString('../sql/extract_fact_employee.sql')
        cur.execute(extract_employee_sql)
        con.commit()
        print('[+] Fact Employee Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


def extract_fact_timesheet():
    try:
        extract_timesheet_sql = file_content_toString('../sql/extract_fact_timesheet.sql')
        cur.execute(extract_timesheet_sql)
        con.commit()
        print('[+] Fact Timesheet Extracted!')
    except Exception as e:
        print('[-] Exception Occured:',e)


if __name__ == '__main__':
    extract_dim_department()
    extract_dim_manager()
    extract_dim_period()
    extract_dim_role()
    extract_dim_shift_type()
    extract_dim_status()

    extract_fact_employee()
    extract_fact_timesheet()
    databaseDisconnect(con,cur)
```
The working of `database_connection` and `file_content_toString` modules are described in [Documentation.md]() in detail.

Here, I loaded data serially into dimensions first and then into facts with queries listed above, using this script. 

Finally the load part of ETL design was also done !