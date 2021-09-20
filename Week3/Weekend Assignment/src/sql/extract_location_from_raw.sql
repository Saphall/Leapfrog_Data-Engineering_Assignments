DELETE FROM customer;
DELETE FROM location;
INSERT INTO location(town)
SELECT DISTINCT town 
FROM raw_customer;