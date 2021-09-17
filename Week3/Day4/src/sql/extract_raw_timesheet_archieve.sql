INSERT INTO raw_timesheet_archieve(
	employee_id ,	
	cost_center	,
	punch_in_time ,	
	punch_out_time ,	
	punch_apply_date ,	
	hours_worked ,	
	paycode ,
    file_name 
) 
VALUES (%s,%s,%s,%s,%s,%s,%s,%s);
