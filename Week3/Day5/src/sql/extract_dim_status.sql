TRUNCATE TABLE fact_employee, fact_timesheet, dim_status RESTART IDENTITY;
INSERT INTO dim_status(status)
SELECT 
 DISTINCT CASE WHEN term_date IS NULL THEN 'active'
	      ELSE 'terminated'
	      END as status
FROM employee