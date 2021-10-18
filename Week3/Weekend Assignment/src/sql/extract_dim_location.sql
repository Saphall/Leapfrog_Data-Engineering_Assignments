TRUNCATE fact_sales,dim_customer,dim_location RESTART IDENTITY;
INSERT INTO dim_location 
SELECT * FROM location;

