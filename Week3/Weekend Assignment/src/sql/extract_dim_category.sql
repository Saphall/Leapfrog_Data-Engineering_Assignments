TRUNCATE fact_sales,dim_products,dim_category RESTART IDENTITY;
INSERT INTO dim_category 
SELECT * FROM category;

