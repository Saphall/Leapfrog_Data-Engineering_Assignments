INSERT INTO raw_sales_data (
    User_id,
    username,
    Product_id,
    Product_name,
    category_id,
    category_name,
    Current_price,
    Sold_price,
    Sold_quantity,
    Remainig_quantity,
    Sales_date,
    file_name)
    VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);