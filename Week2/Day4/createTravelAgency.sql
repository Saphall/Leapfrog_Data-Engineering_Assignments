drop database if exists healthcare;

CREATE DATABASE travelagency;


-- Creating necessary tables from logical model 

--hotel 
CREATE TABLE hotel(
hotel_id serial PRIMARY KEY,
name VARCHAR(50),
location INT REFERENCES city(city_code),
description VARCHAR(150),
cost INT 
);


--transport 
CREATE TABLE transport(
transport_id serial PRIMARY KEY,
type VARCHAR(20),
cost INT 
);


--destination 
CREATE TABLE destination(
destination_id serial PRIMARY KEY,
location_name VARCHAR(50),
description VARCHAR(150)
);


-- package 
CREATE TABLE package(
package_id serial PRIMARY KEY,
name VARCHAR(50),
start_date DATE,
end_date DATE,
description VARCHAR(150),
cost INT ,
active_status BOOLEAN,
hotel_id INT REFERENCES hotel(hotel_id),
transport_id INT REFERENCES transport(transport_id),
destination_id INT REFERENCES destination(destination_id)
);


--package_hotel
CREATE TABLE package_hotel(
hotel_id INT REFERENCES hotel(hotel_id),
package_id INT REFERENCES package(package_id),
unique(hotel_id, package_id)
);


--package_transport
CREATE TABLE package_transport(
transport_id INT REFERENCES transport(transport_id),
package_id INT REFERENCES package(package_id),
unique(transport_id,package_id)
);


--package_destination
CREATE TABLE package_destination(
destination_id INT REFERENCES destination(destination_id),
package_id INT REFERENCES package(package_id),
unique(destination_id,package_id)
);


--city
CREATE TABLE city(
city_code INT PRIMARY KEY,
city_name VARCHAR(50)
);


--customer
CREATE TABLE customer(
customer_id serial PRIMARY KEY,
name VARCHAR(50),
dob DATE ,
email VARCHAR(30) unique,
phone INT not null, 
location INT REFERENCES city(city_code)
);


--booking 
CREATE TABLE booking(
customer_id INT REFERENCES customer(customer_id),
package_id INT REFERENCES package(package_id),
booking_date DATE ,
package_status BOOLEAN
)

--payment
CREATE TABLE payment(
payment_id serial PRIMARY KEY,
customer_id INT REFERENCES customer(customer_id),
package_id INT REFERENCES package(package_id),
type VARCHAR(30),
payment_date DATE,
amount INT 
);







