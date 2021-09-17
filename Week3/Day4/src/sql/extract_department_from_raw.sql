DELETE FROM department;
INSERT INTO department(client_department_id,department_name) 
SELECT DISTINCT 
	department_id,
	department_name 	
from raw_employee;