DELETE FROM sales;
DELETE FROM employee;
INSERT INTO employee(employee_name)
SELECT DISTINCT
 INITCAP(created_by) 
FROM  raw_sales;