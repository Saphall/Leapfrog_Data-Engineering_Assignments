TRUNCATE TABLE fact_sales RESTART IDENTITY;
INSERT INTO fact_sales (
    id ,transaction_id ,bill_no , bill_date , customer_id , product_id ,
    qty ,gross_price ,tax_amt ,discount_amt ,net_bill_amt ,employee ,
    created_date ,duration_for_sale)
SELECT s.id ,s.transaction_id ,s.bill_no , s.bill_date , s.customer_id , s.product_id ,
    s.qty ,s.gross_price ,s.tax_amt ,s.discount_amt ,s.net_bill_amt ,s.employee ,
    p.created_date,( s.bill_date - p.created_date) as duration_for_sale 
FROM sales s
JOIN employee e on s.employee = e.id
JOIN customer c on c.customer_id = s.customer_id
JOIN products p on s.product_id = p.product_id
