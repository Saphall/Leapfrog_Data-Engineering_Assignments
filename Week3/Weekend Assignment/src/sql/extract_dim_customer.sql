TRUNCATE fact_sales,dim_customer RESTART IDENTITY;
INSERT INTO dim_customer (customer_id,user_name,name,country,town,active,total_items_bought)
SELECT 
    c.customer_id ,
    c.user_name,
    concat(c.first_name,'',c.last_name) as name, 
    c.country,
    c.town,
    c.active,
    s.total_items_bought
FROM customer c
left join (
	SELECT  customer_id, count(*) AS total_items_bought
	FROM sales s where qty > 0 GROUP BY customer_id) AS s ON 
c.customer_id  = s.customer_id;




