TRUNCATE TABLE fact_timesheet,fact_employee,dim_role RESTART IDENTITY;
INSERT INTO dim_role(name) 
SELECT DISTINCT role 
FROM employee