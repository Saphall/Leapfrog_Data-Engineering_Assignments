INSERT INTO raw_sales_archieve(
    id ,
    transaction_id ,
    bill_no ,
    bill_date ,
    bill_location ,
    customer_id ,
    product_id ,
    qty ,
    uom ,
    price ,
    gross_price ,
    tax_pc ,
    tax_amt ,
    discount_pc ,
    discount_amt ,
    net_bill_amt ,
    created_by ,
    updated_by ,
    created_date ,
    updated_date ,
    file_name 
)
VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);