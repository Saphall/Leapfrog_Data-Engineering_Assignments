TRUNCATE TABLE fact_employee,fact_timesheet,dim_department RESTART IDENTITY;
INSERT INTO dim_department(client_department_id,name)
SELECT DISTINCT department_id,
                department_name
FROM raw_employee;