INSERT INTO raw_products_archieve(
    product_id ,
    product_name ,
    description ,
    price ,
    mrp ,
    pieces_per_case ,
    weight_per_piece ,
    uom ,
    brand ,
    category ,
    tax_percent ,
    active ,
    created_by ,
    created_date ,
    updated_by ,
    updated_date ,
    file_name 
)
VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);