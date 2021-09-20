INSERT INTO customer
SELECT 
    CAST(c.customer_id AS INT),
    c.user_name,
    CAST(INITCAP(c.first_name) AS VARCHAR) AS first_name,
    CAST(INITCAP(c.last_name) AS VARCHAR) AS last_name,
    CAST(INITCAP(c.country) AS VARCHAR) AS country,
    l.location_id,
    CAST(c.active AS bool)
FROM raw_customer c
INNER JOIN location l on l.town=c.town;
