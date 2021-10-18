CREATE TABLE timesheet (
id SERIAL PRIMARY KEY,
employee_id VARCHAR(255),
department_id INT,
shift_start_time TIME,
shift_end_time TIME,
shift_date DATE,
shift_type VARCHAR(255),
hours_worked FLOAT,
attendance BOOLEAN,
has_taken_break BOOLEAN,
break_hour FLOAT,
was_charge BOOLEAN,
charge_hour FLOAT, 
Was_on_call BOOLEAN,
on_call_hour FLOAT,
num_teammates_absent INT
);
