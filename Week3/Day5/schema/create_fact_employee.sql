CREATE TABLE fact_employee(
	employee_id serial primary key,
	client_employee_id VARCHAR(200),
	first_name VARCHAR(200),
	last_name VARCHAR(200),
	department_id INT,
	manager_employee_id INT,
	salary FLOAT,
	hire_date DATE,
	terminated_date DATE,
	terminated_reason VARCHAR(200),
	dob DATE,
	fte FLOAT,
	weekly_hours FLOAT,
	role_id INT,
	active_status_id INT,
	foreign key(department_id) references dim_department(department_id),
	FOREIGN KEY(manager_employee_id) REFERENCES dim_manager(id),
	FOREIGN KEY(role_id) REFERENCES dim_role(id),
	FOREIGN KEY(active_status_id) REFERENCES dim_status(status_id)	
);
