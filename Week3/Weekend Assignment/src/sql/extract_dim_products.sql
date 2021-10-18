TRUNCATE TABLE fact_sales,dim_products RESTART IDENTITY;
INSERT INTO dim_products
SELECT * FROM  products;