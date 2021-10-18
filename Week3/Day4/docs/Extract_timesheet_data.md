> # Task done: 
## Extract `timesheet` table from `raw_employee` table.

> ### Steps followed:
#### 1. First, `timesheet` table was created using query from `/schema/create_timesheet_table.sql`:
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
num_teammates_absent INT
);

```

#### 2. Then, data was inserted into `department` table using query from `/sql/extract_timesheet_from_raw.sql`.
This process will be explained below:

Since different tables have to be created to extract the attributes, I choosed to do it with Common Table Expressions (CTE). This helped me from creating additional tables.

#### i. `CTE_shift_info`:
Here I created CTE for the information about the shifts.
```
with cte_shift_info AS(
	SELECT rt.employee_id AS employee_id,
		MIN((CASE WHEN punch_in_time = '' then NULL else to_timestamp(punch_in_time,'yyyy-mm-dd hh24-mi-ss')::time END)) AS shift_start_time,
		MAX((CASE WHEN punch_in_time = '' then NULL else to_timestamp(punch_out_time,'yyyy-mm-dd hh24-mi-ss')::time END)) AS shift_end_time,
		CAST(rt.punch_apply_date AS DATE) AS shift_date
  	FROM raw_timesheet rt
  	GROUP BY rt.employee_id ,punch_apply_date 
  )
  ```
  I could obtain `shift_start_time` , `shift_end_time` and `shift_date` from this.

#### ii. `cte_emp_dept`:
Here I created CTE for employee and department information.
```
cte_emp_dept AS (
	SELECT employee_id , CAST(department_id  AS INT)
	FROM raw_employee re 
),
```
#### iii. `cte_hours_worked`:
I created this CTE for calculating hours worked.
```
cte_hours_worked AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE)  ,SUM(CAST(hours_worked AS FLOAT)) AS hours_worked 	
	FROM raw_timesheet
	WHERE paycode ='wrk'
	GROUP BY employee_id ,punch_apply_date
),
```
The `hours_worked` of an employee can be found with paycode='wrk'.

#### iv. `cte_breaK`:
I created this CTE to get the  `break_hour`.
```
cte_break AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE) ,SUM(CAST(hours_worked AS FLOAT)) AS break_hour
	FROM raw_timesheet 
	WHERE paycode = 'break'
	GROUP BY employee_id ,punch_apply_date
)
```
#### v. `cte_charge`:
This CTE helped me to find the `charge_hour`.
```
cte_charge AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE) ,SUM(CAST(hours_worked AS FLOAT)) AS charge_hour
	FROM raw_timesheet 
	WHERE paycode = 'charge'
	GROUP BY employee_id ,punch_apply_date
),
```

#### vi. `cte_call`:
This CTE helped me to find `on_call_hour` of an employee.
```
cte_call AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE) ,SUM(CAST(hours_worked AS FLOAT)) AS on_call_hour
	FROM raw_timesheet 
	WHERE paycode = 'on_call'
	GROUP BY employee_id ,punch_apply_date
),
```
#### vii. `cte_teammate_absent`:
This CTE helped me to find the number of teammates absent referencing the paycode='absent' for employees having same department_id.
```
cte_teammate_absent AS (
	SELECT DISTINCT  CAST(re.department_id AS INT) , CAST(COUNT(*) AS INT) AS num_teammates_absent , CAST(rt.punch_apply_date  AS DATE)
	FROM raw_employee re JOIN raw_timesheet rt 
	on re.employee_id = rt.employee_id 
	WHERE rt.paycode = 'absent'
	GROUP BY  re.department_id , rt.punch_apply_date  
) 
```

#### viii. `shift_type`:
For shift_type, I used the case statement to check.
```
(CASE WHEN EXTRACT(hour FROM csi.shift_start_time) BETWEEN 5 AND 11 then 'morning' 
	   		WHEN EXTRACT (hour FROM csi.shift_start_time) >= 12 then 'night' else NULL END) AS shift_type,
```

Finally all these CTEs and logics helped me to extract the `timesheet` table from `raw_timesheet`.
```
with cte_shift_info AS(
	SELECT rt.employee_id AS employee_id,
		MIN((CASE WHEN punch_in_time = '' then NULL else to_timestamp(punch_in_time,'yyyy-mm-dd hh24-mi-ss')::time END)) AS shift_start_time,
		MAX((CASE WHEN punch_in_time = '' then NULL else to_timestamp(punch_out_time,'yyyy-mm-dd hh24-mi-ss')::time END)) AS shift_end_time,
		CAST(rt.punch_apply_date AS DATE) AS shift_date
  	FROM raw_timesheet rt
  	GROUP BY rt.employee_id ,punch_apply_date 
  ) ,
cte_emp_dept AS (
	SELECT employee_id , CAST(department_id  AS INT)
	FROM raw_employee re 
),
cte_hours_worked AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE)  ,SUM(CAST(hours_worked AS FLOAT)) AS hours_worked 	
	FROM raw_timesheet
	WHERE paycode ='wrk'
	GROUP BY employee_id ,punch_apply_date
),
cte_break AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE) ,SUM(CAST(hours_worked AS FLOAT)) AS break_hour
	FROM raw_timesheet 
	WHERE paycode = 'break'
	GROUP BY employee_id ,punch_apply_date
),
cte_charge AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE) ,SUM(CAST(hours_worked AS FLOAT)) AS charge_hour
	FROM raw_timesheet 
	WHERE paycode = 'charge'
	GROUP BY employee_id ,punch_apply_date
),
cte_call AS (
	SELECT employee_id , CAST(punch_apply_date AS DATE) ,SUM(CAST(hours_worked AS FLOAT)) AS on_call_hour
	FROM raw_timesheet 
	WHERE paycode = 'on_call'
	GROUP BY employee_id ,punch_apply_date
),
cte_teammate_absent AS (
	SELECT DISTINCT  CAST(re.department_id AS INT) , CAST(COUNT(*) AS INT) AS num_teammates_absent , CAST(rt.punch_apply_date  AS DATE)
	FROM raw_employee re JOIN raw_timesheet rt 
	on re.employee_id = rt.employee_id 
	WHERE rt.paycode = 'absent'
	GROUP BY  re.department_id , rt.punch_apply_date  
) 
INSERT INTO timesheet (employee_id ,department_id,shift_start_time,shift_end_time,shift_date,shift_type,hours_worked,attendance,has_taken_break,
		break_hour,was_charge,charge_hour,was_on_call,on_call_hour,num_teammates_absent) 
SELECT employee_id ,a.department_id,a.shift_start_time,a.shift_end_time,a.shift_date,a.shift_type,a.hours_worked,a.attendance,a.has_taken_break,
		a.break_hour,a.was_charge,a.charge_hour,a.was_on_call,a.on_call_hour,cta.num_teammates_absent FROM (
SELECT csi.employee_id,
	   ced.department_id,
	   shift_start_time,
	   shift_end_time,
	   shift_date,
	   (CASE WHEN EXTRACT(hour FROM csi.shift_start_time) BETWEEN 5 AND 11 then 'morning' 
	   		WHEN EXTRACT (hour FROM csi.shift_start_time) >= 12 then 'night' else NULL END) AS shift_type,
	   (CASE WHEN chw.hours_worked is NOT NULL then chw.hours_worked else 0 END) AS hours_worked,
	   (CASE WHEN csi.shift_start_time is NULL then false else true END) AS attendance,
	   (CASE WHEN (csi.employee_id, csi.shift_date) IN (SELECT employee_id, punch_apply_date FROM cte_break) then true else false END) AS has_taken_break, 
	   (CASE WHEN cb.break_hour is NOT NULL then cb.break_hour else 0 END) AS break_hour,
	   (CASE WHEN (csi.employee_id, csi.shift_date) IN (SELECT employee_id, punch_apply_date FROM cte_charge) then true else false END) AS was_charge, 
	   (CASE WHEN cchrg.charge_hour is NOT NULL then cchrg.charge_hour else 0 END) AS charge_hour,
	   (CASE WHEN (csi.employee_id, csi.shift_date) IN (SELECT employee_id, punch_apply_date FROM cte_call) then true else false END) AS was_on_call, 
	   (CASE WHEN ccall.on_call_hour is NOT NULL then ccall.on_call_hour else 0 END) AS on_call_hour
FROM cte_shift_info csi
JOIN cte_emp_dept ced ON
	csi.employee_id = ced.employee_id
LEFT JOIN cte_hours_worked chw ON 
	csi.employee_id = chw.employee_id AND csi.shift_date = chw.punch_apply_date
LEFT JOIN cte_break cb ON 
	csi.employee_id = cb.employee_id AND csi.shift_date = cb.punch_apply_date
LEFT JOIN cte_charge cchrg ON 
	csi.employee_id = cchrg.employee_id AND csi.shift_date = cchrg.punch_apply_date
LEFT JOIN cte_call ccall ON 
	csi.employee_id = ccall.employee_id AND csi.shift_date = ccall.punch_apply_date) a 
LEFT JOIN cte_teammate_absent cta ON 
	a.department_id = cta.department_id AND a.shift_date = cta.punch_apply_date ;
```

Thus this `sql` file helped me to extract `timesheet` data using the python script from `/src/pipeline/extract_timesheet_data.py`.

**The python file contains `extract_timesheet()` function that helps to extract timesheet from above sql file.**
```
def extract_timesheet():
    try:
        cur.execute('TRUNCATE TABLE timesheet RESTART IDENTITY;')
        extract_timesheet_sql = file_content_toString('../sql/extract_timesheet_from_raw.sql')
        cur.execute(extract_timesheet_sql)
        con.commit()
        print('[+] Timesheet Extracted from raw!')

    except Exception as e:
        print('[-] Exception Occured:',e)
```
The functioning of `file_content_toString()` is explained in [Documentation.md]() , which helps to get content of file as a string.

Thus `timesheet` data was extracted !