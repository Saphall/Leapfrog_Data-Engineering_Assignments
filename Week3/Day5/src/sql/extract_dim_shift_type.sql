TRUNCATE TABLE fact_timesheet, dim_shift_type RESTART IDENTITY;
INSERT INTO dim_shift_type(name)
SELECT DISTINCT (CASE when shift_type IS NULL THEN '' ELSE INITCAP(shift_type) END) as name
FROM timesheet
