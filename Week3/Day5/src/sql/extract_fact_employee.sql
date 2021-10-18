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