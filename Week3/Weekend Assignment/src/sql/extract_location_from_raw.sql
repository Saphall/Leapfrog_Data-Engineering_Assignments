TRUNCATE TABLE sales,customer,location RESTART IDENTITY;
INSERT INTO location(town)
SELECT DISTINCT town 
FROM raw_customer;