DELETE FROM sales;
INSERT INTO sales
SELECT s.id, 
CAST(s.transaction_id AS INT), 
CAST(s.bill_no AS INT), 
(case when bill_date ='2017-02-30 11:00:00' then cast('2017-02-28 11:00:00'  as TIMESTAMP)
    else CAST(bill_date as TIMESTAMP) end) ,
CAST(s.customer_id AS INT),
CAST(s.product_id AS INT), 
CAST(s.qty AS INT ), 
CAST(s.gross_price AS FLOAT) ,
CAST(s.tax_pc AS FLOAT),
CAST(s.tax_amt AS FLOAT),
CAST(s.discount_pc AS FLOAT),
CAST (s.discount_amt AS FLOAT),
CAST(s.net_bill_amt AS FLOAT),
e.id,
(case when created_date ='2017-02-30 11:00:00' then cast('2017-02-28 11:00:00'  as TIMESTAMP)
    else CAST(created_date as TIMESTAMP) end)
FROM raw_sales s
JOIN employee e ON e.employee_name= INITCAP(s.created_by);