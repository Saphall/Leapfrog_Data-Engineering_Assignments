> # Task done: 
## Extract `employee` fact table from `raw_employee` table.

> ### Steps followed: 
1. Unique department id and name extracted
2. Update department in employee
3. role distinction
4. cleaning terminated_date
5. first_name,last_name formating
6. weekly_hours derived
7. '-' to null
8. employee id generate

---
#### i. First, `department` dimension table was created using query from `/schema/create_department_table.sql`:
```
CREATE TABLE department(
 	id serial PRIMARY KEY,
 	client_department_id VARCHAR(255),
 	department_name VARCHAR(255)
); 
```

#### ii. Then, data was inserted into `department` table using query from `/sql/extract_department_from_raw.sql`.
```
DELETE FROM department;
INSERT INTO department(client_department_id,department_name) 
SELECT DISTINCT 
	department_id,
	department_name 	
from raw_employee;
```


### iii. `employee` table was created using query in `/schema/create_employee_table.sql`:
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
Right `datatypes` as well as `primary key` and `foreign keys` are choosen in this table.

#### iv. Then, data was inserted into `employee` table using query from `/sql/extract_employee_from_raw.sql`.
```
INSERT INTO employee (client_employee_id,first_name,last_name,department_id,manager_employee_id,salary,hire_date,term_date
,term_reason,dob,fte,weekly_hours,role)
SELECT 
employee_id AS client_employee_id, 
INITCAP(re.first_name) AS first_name,
INITCAP(re.last_name) AS last_name,
d.id AS department_id,
(CASE WHEN re.manager_employee_id = '-' THEN NULL ELSE re.manager_employee_id END) AS manager_employee_id,
CAST(re.salary AS FLOAT),
CAST(re.hire_date AS DATE),
CAST(CASE WHEN terminated_date = '01-01-1700' THEN NULL ELSE terminated_date END AS DATE) AS term_date,
re.terminated_reason AS term_reason ,
CAST(dob AS DATE) AS dob,
CAST(fte AS FLOAT) AS fte,
CAST(fte AS FLOAT) * 40 AS weekly_hours,
(CASE WHEN re.employee_role LIKE '%Mgr%' OR re.employee_role LIKE '%Supv%' THEN 'Manager' ELSE 'Employee' END) AS role
FROM raw_employee re
JOIN department d ON 
    re.department_id = d.client_department_id;
```
