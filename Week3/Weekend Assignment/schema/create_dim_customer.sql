CREATE TABLE dim_customer(
    customer_id INT PRIMARY KEY,
    user_name VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    country VARCHAR(255),
    town INT,
    active boolean,
    total_items_bought INT,
    FOREIGN KEY (town) REFERENCES dim_location(location_id) 
);