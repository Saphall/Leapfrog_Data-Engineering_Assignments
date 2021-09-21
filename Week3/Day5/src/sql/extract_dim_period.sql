TRUNCATE TABLE fact_timesheet,fact_employee,dim_period;
INSERT INTO dim_period VALUES
    (1,'2021-06-22','2021-07-06'),
    (2,'2021-07-06','2021-07-20'),
    (3,'2021-07-20','2021-07-31');