SELECT u.id as User_id,
		u.username,
		p.id as Product_id,
		p."name" as Product_name,
		c.id as category_id,
		c."name" as category_name,
		p.price as Current_price,
		s.price as Sold_price,
		s.quantity as Sold_quantity,
		(p.quantity - s.quantity) as Remaining_quantity,
		s.updated_at as Sales_date
FROM users u 
JOIN sales s on 
	u.id = s.user_id 
JOIN products p on
	s.product_id = p.id 
JOIN categories c on
	p.category_id = c.id ;