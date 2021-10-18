TRUNCATE TABLE sales,employee RESTART IDENTITY;
INSERT INTO employee(employee_name)
SELECT DISTINCT
 INITCAP(created_by) 
FROM  raw_sales;