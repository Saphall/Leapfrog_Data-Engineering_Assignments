DROP DATABASE if EXISTS dentist_appointment;
CREATE DATABASE dentist_appointment;


-- dental office 
CREATE TABLE dental_office(
dental_office_id serial PRIMARY KEY,
name VARCHAR(150) NOT NULL,
address VARCHAR (150) NOT NULL,
phone int NOT NULL
);
SELECT * FROM dental_office ;
INSERT into dental_office VALUES (1,'Jawlakhel Office','Jawlakhel,Kathmandu',5090000);
INSERT into dental_office VALUES (2,'Putalisadak Office','Putalisadak,Kathmandu',5091111);




-- dentist 
CREATE TABLE dentist(
dentist_id serial PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(150) NOT NULL,
phone int NOT NULL
);
SELECT * FROM dentist;
INSERT into dentist VALUES
(1,'Rajan','Giri','rajan@gmail.com',984100000),
(2,'Pranav','Pudasaini','prav12@gmail.com',984300000),
(3,'Mohit','Bhatta','mohit@gmail.com',984311111),
(4,'Saphal','Shakha','safal@gmail.com',984312346),
(5,'Samyog','Shah','samyog@gmail.com',984343434);






-- dentist_availability
CREATE TABLE dentist_availability(
dentist_availability_id serial PRIMARY KEY,
dentist_id int NOT NULL,
dental_office_id int NOT NULL,
available_date date,
CONSTRAINT fk_availability_dentist FOREIGN KEY(dentist_id) 
REFERENCES dentist(dentist_id),
CONSTRAINT fk_availability_dentalOffice FOREIGN KEY(dental_office_id) 
REFERENCES dental_office(dental_office_id)
);
SELECT * FROM dentist_availability ;
INSERT into dentist_availability VALUES
		(1,1,1,'2021-09-11'),
		(2,1,2,'2021-09-18'),
		(3,2,1,'2021-09-12'),
		(4,2,2,'2021-09-16'),
		(5,3,1,'2021-09-11'),
		(6,3,2,'2021-09-12'),
		(7,4,1,'2021-09-18'),
		(8,4,2,'2021-09-11'),
		(9,5,1,'2021-09-13'),
		(10,5,2,'2021-09-19');




-- dental_hygienist
CREATE TABLE dental_hygienist(
dental_hygienist_id serial PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
second_name VARCHAR(50) NOT NULL,
phone int NOT NULL,
dental_office_id int NOT NULL,
CONSTRAINT fk_hygienist_office FOREIGN KEY(dental_office_id) 
REFERENCES dental_office(dental_office_id)
);
SELECT * FROM dental_hygienist dh ;
INSERT into dental_hygienist VALUES
(1,'Ram','Giri',985100000,1),
(2,'Prem','Prajapati',984300000,1),
(3,'Mohan','Lal',984333333,2),
(4,'Sita','Siwakoti',984156656,2),
(5,'Sa','Shah',984332404,2);






-- city
CREATE TABLE city (
city_id serial PRIMARY KEY,
zip_code int NOT NULL,
city_name VARCHAR(50) NOT NULL,
unique(zip_code),
unique(city_name)
);
SELECT * FROM city;
INSERT into city VALUES
		(1,44600,'Kathmandu'),
		(2,44800,'Bhaktapur'),
		(3,44700,'Lalitpur');




-- patient
CREATE TABLE patient(
patient_id serial PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(150) unique NOT NULL,
phone int unique NOT NULL,
address int NOT NULL,
CONSTRAINT fk_patient_city FOREIGN KEY(address) 
REFERENCES city(city_id)
);
SELECT * FROM patient p ;
INSERT into patient VALUES
		(1,'Ram','Shr','ram@gmail.com',5055000,1),
		(2,'Sita','Ghr','sita@gmail.com',565654,1),
		(3,'Hari','Sree','hari@gmail.com',985000,2),
		(4,'Sam','Sri','sam@gmail.com',8055000,3),
		(5,'Hom','Shpp','hom@gmail.com',855000,2),
		(6,'Jam','Sho','jam@gmail.com',895000,3),
		(7,'Tan','Shy','tan@gmail.com',55000,1),
		(8,'Raju','Sho','raju@gmail.com',98008,2);





-- appointment
CREATE TABLE appointment(
appointment_id serial PRIMARY KEY,
patient_id int NOT NULL,
dentist_id int NOT NULL,
dental_hygienist_id int NOT NULL,
datetime_of_appointment timestamp NOT NULL,
service VARCHAR(100),
CONSTRAINT fk_appointment_patient FOREIGN KEY(patient_id) 
REFERENCES patient(patient_id),
CONSTRAINT fk_appointment_dentist FOREIGN KEY(dentist_id) 
REFERENCES dentist(dentist_id),
CONSTRAINT fk_appointment_hygienist FOREIGN KEY(dental_hygienist_id) 
REFERENCES dental_hygienist(dental_hygienist_id)
);
SELECT * FROM appointment ;
INSERT into appointment VALUES 
			(1,1,3,4,'2021-09-12 10:00:00','Removing Teeth'),
			(2,3,5,1,'2021-09-13 9:15:00','Plaster Teeth'),
			(3,4,2,3,'2021-09-16 1:00:00','Cleaning teeth'),
			(4,8,4,1,'2021-09-18 12:00:00','Filling'),
			(5,2,1,1,'2021-09-11 11:00:00','Regular checkup'),
			(6,7,4,3,'2021-09-11 1:30:00','Wire fit'),
			(7,1,2,1,'2021-09-12 3:00:00','Removing Teeth');
			



-- invoice 
CREATE TABLE invoice(
invoice_id serial NOT NULL,
patient_id int NOT NULL,
appointment_id int NOT NULL,
datetime_of_invoice timestamp NOT NULL,
amount int NOT NULL,
CONSTRAINT fk_invoice_patient FOREIGN KEY(patient_id) 
REFERENCES patient(patient_id),
CONSTRAINT fk_invoice_appointment FOREIGN KEY(appointment_id) 
REFERENCES appointment(appointment_id)
);
SELECT * FROM invoice;
INSERT into invoice VALUES
		(1,1,1,'2021-09-11 10:00:00',2000),
		(2,3,2,'2021-09-12 9:15:00',5000),
		(4,4,3,'2021-09-14 1:00:00',2000),
		(5,8,4,'2021-09-16 12:00:00',3000),
		(6,2,5,'2021-09-09 11:00:00',2000),
		(3,7,6,'2021-09-10 1:30:00',10000),
		(7,1,7,'2021-09-11 3:00:00',2000);


	
	
	
	
-- DQL 

-- all patients
SELECT * FROM patient p ;

-- all dentist
SELECT * FROM dentist d ;

-- all dental_hygienist
SELECT * FROM dental_hygienist dh ;

-- all the dental_offices
SELECT * 
FROM dental_office;


-- dentist availability at offices ;
SELECT da.dentist_availability_id ,
		concat( d.first_name,' ',d.last_name) as Dentist ,
		available_date,
		doff."name" 
FROM dentist_availability da 
JOINdentist d 
		on da.dentist_id = d.dentist_id
JOINdental_office doff 
		on da.dental_office_id = doff.dental_office_id ; 


-- all appointments information with dentist, dental_office and dental_hygienist
SELECT * FROM appointment a ;
SELECT appointment_id ,
		concat(p.first_name,' ',p.last_name) as patient ,
		concat( d.first_name,' ',d.last_name ) as Dentist,
		concat(dh.first_name,' ',dh.second_name) as Dental_Hygienist, 
		do2."name" 
		datetime_of_appointment , 
		service 
FROM appointment a 
JOINpatient p on
	a.patient_id = p.patient_id 
JOINdentist d on 
	a.dentist_id = d.dentist_id 
JOINdental_hygienist dh on
	a.dental_hygienist_id = dh.dental_hygienist_id 
JOINdental_office do2 on
	dh.dental_office_id = do2.dental_office_id 


	
	
	

