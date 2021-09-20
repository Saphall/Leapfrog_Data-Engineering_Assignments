DELETE FROM products;
DELETE FROM category;
INSERT INTO category(category)
SELECT DISTINCT category 
    from raw_products;