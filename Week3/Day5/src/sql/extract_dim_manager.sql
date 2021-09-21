TRUNCATE TABLE fact_timesheet,fact_employee,dim_manager RESTART IDENTITY;
insert into dim_manager (client_employee_id,firt_name,last_name)
SELECT DISTINCT mgr.client_employee_id ,
                mgr.first_name,
                mgr.last_name
FROM employee e
JOIN employee mgr
	ON e.manager_employee_id  = mgr.manager_employee_id 
