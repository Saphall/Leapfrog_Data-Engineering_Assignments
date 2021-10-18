TRUNCATE TABLE fact_sales,dim_employee RESTART IDENTITY;
INSERT INTO dim_employee(employee_name)
SELECT employee_name 
FROM  employee;