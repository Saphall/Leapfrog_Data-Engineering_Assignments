INSERT INTO raw_employee_archieve(
    employee_id ,
    first_name ,
    last_name ,
    department_id ,
    department_name ,
    manager_employee_id ,
    employee_role ,
    salary ,
    hire_date ,
    terminated_date ,
    terminated_reason ,
    dob ,
    fte ,
    location ,
    file_name 
) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);