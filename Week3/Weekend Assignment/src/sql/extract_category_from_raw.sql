TRUNCATE TABLE sales,products,category RESTART IDENTITY;
INSERT INTO category(category)
SELECT DISTINCT category 
    from raw_products;