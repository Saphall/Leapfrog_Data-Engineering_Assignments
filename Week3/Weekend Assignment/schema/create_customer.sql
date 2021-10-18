CREATE TABLE customer(
    customer_id INT PRIMARY KEY,
    user_name VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    country VARCHAR(255),
    town INT,
    active boolean,
    FOREIGN KEY (town) REFERENCES location(location_id) 
);