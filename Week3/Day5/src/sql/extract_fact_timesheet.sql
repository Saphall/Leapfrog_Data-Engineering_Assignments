TRUNCATE TABLE fact_timesheet RESTART IDENTITY;
INSERT INTO fact_timesheet(
    employee_id,
	department_id ,
	shift_start_time ,
	shift_end_time ,
	shift_date ,
	shift_type_id ,
	is_weekend ,
	hours_worked ,
	attendance ,
	has_taken_break ,
	break_hour ,
	was_charge ,
	charge_hour ,
	was_on_call ,
	on_call_hour ,
	num_teammates_absent)
SELECT 
	fe.employee_id as employee_id,
	d.department_id,
    t.shift_start_time,
    t.shift_end_time,
    t.shift_date,
    ds.id as shift_type_id,
    (CASE WHEN extract(ISODOW from shift_date) IN (6,7) THEN true 
        ELSE false END) AS is_weekend,-----is_weekend,
    t.hours_worked,
    t.attendance,
    t.has_taken_break,
    t.break_hour,
    t.was_charge,
    t.charge_hour ,
    t.was_on_call,
    t.on_call_hour,
    t.num_teammates_absent
FROM timesheet t
LEFT JOIN fact_employee fe on 
    t.employee_id = fe.client_employee_id
LEFT JOIN dim_department d on 
    cast(t.department_id as varchar) = d.client_department_id
LEFT JOIN dim_shift_type ds on 
    t.shift_type = ds.name