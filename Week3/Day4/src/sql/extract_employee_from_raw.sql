TRUNCATE TABLE employee RESTART IDENTITY;
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