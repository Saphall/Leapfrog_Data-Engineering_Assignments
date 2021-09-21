CREATE TABLE fact_sales(
    id VARCHAR(500),
    transaction_id INT,
    bill_no INT,
    bill_date TIMESTAMP,
    customer_id INT,
    product_id INT,
    qty INT,
    gross_price FLOAT,
    tax_amt FLOAT,
    discount_amt FLOAT,
    net_bill_amt FLOAT,
    employee INT,
    created_date TIMESTAMP,
    duration_for_sale TIMESTAMP,
    FOREIGN KEY (employee) REFERENCES dim_employee(id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id)
);