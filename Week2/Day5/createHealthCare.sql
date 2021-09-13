DROP DATABASE if exists healthcare;
CREATE DATABASE healthcare;

-- Creating necessary TABLE FROM logical model

--city
CREATE TABLE city(
id serial primary key,
city_code INT not null,
city_name VARCHAR(50) not null
);
SELECT * FROM city;
INSERT INTO city values 
	(1,44600,'Kathmandu'),
	(2,44800,'Bhaktapur'),
	(3,44700,'Lalitpur');



--hospital 
create table hospital ( 
hospital_id serial primary key,
name varchar(50) not null,
location int references city(id)
);
SELECT * FROM hospital;
INSERT INTO hospital values 
		(1,'Kantipur Hospital',1),
		(2,'KMC Hospital',1),
		(3,'Lalitpur Hospital',3),
		(4,'Ivamura Hospital',2),
		(5,'Patan Hospital',3),
		(6,'Civil Hospital',1),
		(7,'Bhaktapur Hospital',2);



--clinic 
CREATE TABLE clinic(
clinic_id serial PRIMARY KEY,
name VARCHAR(50) not null,
location INT REFERENCES city(id) not null
);
SELECT * FROM clinic;
INSERT INTO clinic values 
		(1,'Kantipur Clinic',1),
		(2,'Hamro Clinic',2),
		(3,'Lalitpur Clinic',3),
		(4,'Light Clinic',2),
		(5,'Patan Clinic',3),
		(6,'Rajdhani Clinic',1);


--pharmacy
DROP table pharmacy ;
CREATE TABLE pharmacy(
pharmacy_id serial PRIMARY KEY,
pharmacy_name VARCHAR(50) not null,
location INT REFERENCES city(id) not null 
);
SELECT * FROM pharmacy;
INSERT INTO pharmacy values
		(1,'Ramro Pharmacy',2),
		(2,'Ramro Pharmacy',1),
		(3,'Lalit Pharmacy',2);
		

--medicine 
CREATE TABLE medicine(
med_id serial PRIMARY KEY,
name VARCHAR(50) not null ,
brand VARCHAR(50) not null,
cost INT not null
);
SELECT  * FROM medicine ;
INSERT INTO medicine values
		(1,'Verocil','VDD',1200),
		(2,'Tablet','Nickto',500),
		(3,'Cliveng','Sancho',2000),
		(4,'Pilera','DDD',5000),
		(5,'Saee','DDD',6666);



--services
CREATE TABLE services(
service_id serial PRIMARY KEY,
service_name VARCHAR(50) not null,
cost INT not null
);
SELECT * FROM services;
INSERT INTO services values
		(1,'Covid Check',10000),
		(2,'Psychatricst Help',5000),
		(3,'Dental Help',5000),
		(4,'Skin Care',6000),
		(5,'Skeleton Help',10000);


--specialization 
CREATE TABLE specialization(
specialization_id serial PRIMARY KEY,
specialization_name VARCHAR(50) not null
);
SELECT * FROM specialization;
INSERT INTO specialization values
		(1,'Skeleton'),
		(2,'Skin'),
		(3,'Dental'),
		(4,'Heart'),
		(5,'Hair'),
		(6,'Kidney');


--doctor
CREATE TABLE doctor(
doctor_id serial PRIMARY KEY,
name VARCHAR(50) not null,
phone_no INT unique,
qualification VARCHAR(50) not null,
specialization INT REFERENCES specialization(specialization_id),
service_id INT REFERENCES services(service_id)
);
SELECT * FROM doctor;
INSERT INTO doctor values 
		(1,'Ram Giri',985100000,'MBBS',3,3),
		(2,'Prem Prajapati',984300000,'MBBS',2,4),
		(3,'Mohan Lal',984333333,'MBBS',4,2),
		(4,'Sita Siwakoti',984156656,'MD',1,5),
		(5,'Sa Shah',984332404,'MD',6,null);


--patient 
CREATE TABLE patient(
patient_id serial PRIMARY KEY,
name VARCHAR(50) not null,
dob DATE not null,
phone INT unique,
location INT REFERENCES city(id),
blood_group VARCHAR(10) not null
);
SELECT * FROM patient ;
INSERT INTO patient values 
			(1,'Ram shah','1999-03-01',984454,1,'A+'),
			(2,'Raju lama','1970-08-01',90050,1,'AB+'),
			(3,'Sam Ale','1989-03-11',5064,2,'B-'),
			(4,'Rita Tle','2000-03-01',152054,2,'A-'),
			(5,'Sajana Twane','1994-07-01',15154,3,'O+');



--------------------------------hospital_service 
CREATE TABLE hospital_service(
hospital_service_id serial primary key,
patient_id int references patient(patient_id),
hospital_id INT REFERENCES hospital(hospital_id),
service_id INT REFERENCES services(service_id),
unique(patient_id,hospital_id, service_id),
amount int not null,
service_date date not null
);
SELECT * FROM hospital_service ;
INSERT INTO hospital_service values
			(1,1,1,1,5000,'2021-09-12'),
			(2,2,3,1,10000,'2021-09-10'),
			(3,4,1,3,3000,'2021-09-01'),
			(4,2,2,4,4000,'2021-09-13');

		
------------------------------clinic_service
CREATE TABLE clinic_service(
clinic_service_id serial primary key,
patient_id int references patient(patient_id),
clinic_id INT REFERENCES clinic(clinic_id),
service_id INT REFERENCES services(service_id),
unique(patient_id,clinic_id, service_id),
amount int not null,
service_date date not null
);
SELECT * FROM clinic_service;
INSERT INTO clinic_service values
			(1,2,1,3,2000,'2021-09-03'),
			(2,5,1,4,3000,'2021-09-14'),
			(3,1,2,4,5000,'2021-08-12');


--consultaion
CREATE TABLE consultation(
consultation_id serial PRIMARY KEY,
patient_id INT REFERENCES patient(patient_id),
doctor_id INT REFERENCES doctor(doctor_id),
consultation_date DATE not null,
amount int not null
);
SELECT * FROM consultation ;
INSERT INTO consultation values 
				(1,1,3,'2021-09-12',3000),
				(2,3,4,'2021-09-10',2000),
				(3,4,5,'2021-09-13',5000)




-- discussion 
CREATE TABLE discussion(
discussion_id serial PRIMARY KEY,
patient_id INT REFERENCES patient(patient_id),
question VARCHAR(200),
solution VARCHAR(200)
);
SELECT * FROM discussion;
INSERT INTO discussion values 
			(1, 2, 'How to prevent common cold?','Stay Away FROM cold!'),
			(2, 4,'Where is Bir hospital?','Kathmandu.'),
			(3,5,'How to stop chicken-pox?','Maintain hygiene.');



--feedback
CREATE TABLE feedback(
feedback_id serial PRIMARY KEY,
patinent_id INT REFERENCES patient(patient_id),
doctor_id INT REFERENCES doctor(doctor_id),
description VARCHAR(300)
);
SELECT * FROM feedback;
INSERT INTO feedback values 
	(1, 1, 1 ,'Great consultant!'),
	(2,5, 3,'Happy with your servies!');




-- appointment
CREATE TABLE appointment(
appointment_id serial PRIMARY KEY,
patient_id INT REFERENCES patient(patient_id),
hospital_id INT REFERENCES hospital(hospital_id),
clinic_id INT REFERENCES clinic(clinic_id),
doctor_id INT REFERENCES doctor(doctor_id),
appointment_date DATE not null,
cost INT not null 
);
SELECT * FROM appointment;
INSERT INTO appointment values 
				(1,2,3,null,null,'2021-02-10',4000),
				(2,3,null,null,3,'2021-04-05',5000),
				(3,1,null,3,null,'2021-03-11',2000);


--pharmacy_medicine
CREATE TABLE pharmacy_medicine(
id serial PRIMARY KEY,
pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
med_id INT REFERENCES medicine(med_id)
);
SELECT * FROM pharmacy_medicine;
INSERT INTO pharmacy_medicine values 
			(1,2,3),
			(2,3,5),
			(3,2,1),
			(4,1,4),
			(5,1,1),
			(6,3,2);




--billing
CREATE TABLE billing(
billing_id serial PRIMARY KEY,
patient_id INT REFERENCES patient(patient_id),
appointment_id INT REFERENCES appointment(appointment_id),
hospital_service_id INT REFERENCES hospital_service(hospital_service_id),
clinic_service_id int references clinic_service(clinic_service_id),
consultation_id int references consultation(consultation_id),
pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
amount INT 
);
SELECT * FROM billing;
INSERT INTO billing values 
		(1,2,1,null,null,null,1,6000),
		(2,1,null,null,null,2,null,10000);



	
	
 --------------------------- QUERIES
-- all patients 
SELECT * FROM patient;

-- all hospitals
SELECT * FROM hospital;

-- all clinic 
SELECT * FROM clinic;

-- all pharmacies 
SELECT * FROM pharmacy ;


-- patient feedback
SELECT * FROM feedback f ;
SELECT feedback_id ,
	p."name" as Patient_Name,
		d."name" as Doctor,
		description 
FROM feedback f
JOIN patient p on 
	f.patinent_id = p.patient_id 
JOIN doctor d on
	d.doctor_id = f.doctor_id ;



-- consultaion
SELECT * FROM consultation c ;
SELECT consultation_id ,
		p."name" as Patient,
		d."name" as Doctor,
		consultation_date,
		amount 
FROM consultation c 
JOIN patient p on 
	c.patient_id = p.patient_id 
JOIN doctor d on 
	d.doctor_id  = c.doctor_id 

	
-- appointment to hospital
SELECT * FROM appointment a ;
SELECT appointment_id ,
		p."name" as patient,
		h."name" as Hospital,
		appointment_date ,
		"cost" 
FROM appointment a 
JOIN patient p ON 
	a.patient_id = p.patient_id 
JOIN hospital h on 
	h.hospital_id = a.hospital_id ;


-- appointment to clinic
SELECT * FROM appointment a ;
SELECT appointment_id ,
		p."name" as patient,
		c."name" as clinic ,
		appointment_date ,
		"cost" 
FROM appointment a 
JOIN patient p ON 
	a.patient_id = p.patient_id 
JOIN clinic c on 
	c.clinic_id = a.clinic_id ;


-- appointment to doctor 
SELECT * FROM appointment a ;
SELECT appointment_id ,
		p."name" as patient,
		d.name as Doctor,
		appointment_date ,
		"cost" 
FROM appointment a 
JOIN patient p ON 
	a.patient_id = p.patient_id 
JOIN doctor d  on 
	d.doctor_id = a.doctor_id ;



	
-- patients using hospital services:
SELECT * FROM hospital_service hs2 ;
SELECT hospital_service_id ,
		p."name",
		h."name" ,
		s.service_name ,
		service_date ,
		amount
FROM hospital_service hs 
JOIN patient p on 
		hs.patient_id = p.patient_id 
JOIN hospital h on
		hs.hospital_id = h.hospital_id 
JOIN services s ON 
		hs.service_id = s.service_id ;
	

-- patients using clinic services
SELECT * FROM clinic_service cs ;
SELECT clinic_service_id ,
		p."name" ,
		c."name" ,
		s.service_name ,
		service_date ,
		amount
FROM clinic_service cs
JOIN patient p on
		cs.patient_id = p.patient_id 
JOIN clinic c on 
		cs.clinic_id = c.clinic_id 
JOIN services s on 
		s.service_id = cs.service_id;
	
	
-- patients consulting doctors
SELECT * FROM consultation c ;
SELECT consultation_id ,
		p."name" as Patient ,
		d."name" as Doctor ,
		consultation_date ,
		amount 
FROM consultation c 
JOIN patient p on
	c.patient_id = p.patient_id 
JOIN doctor d on
	d.doctor_id = c.doctor_id ;
	


-- billing for pharmacy info
SELECT * FROM billing b ;
SELECT billing_id ,
		p."name" as Patient_Name,
		c.city_name as patient_address,
		p2.pharmacy_name ,
		amount 
FROM billing b 
JOIN patient p on 
		p.patient_id = b.patient_id 
JOIN city c on
		p."location" = c.id 
JOIN pharmacy p2 ON 
		b.pharmacy_id = p2.pharmacy_id ;