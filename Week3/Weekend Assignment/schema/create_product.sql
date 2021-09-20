CREATE TABLE products(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    description VARCHAR(255),
    price FLOAT,
    mrp  FLOAT,
    pieces_per_case  NUMERIC,
    weight_per_piece  NUMERIC,
    uom VARCHAR(255),
    brand VARCHAR(155), 
    category_id INT,
    tax_percent  FLOAT,
    active  BOOLEAN,
    created_by VARCHAR(255),
    created_date  TIMESTAMP,
    updated_by VARCHAR(255),
    updated_date TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES category(id) 
);