------------CREATING REQUIRED DATABASE TABLES

create database hospital;
---------------------

create table physician (
employeeid serial primary key, 
name varchar(30), 
position varchar(50) ,
ssn int );	


select * from physician ;

---------------------

drop table department;

create table department (
departmentid serial primary key,
name varchar (30),
head int references physician(employeeid)
)

select * from department;


------------
drop table if exists affiliated_with;

create table affiliated_with(
physician int references physician(employeeid),
department int references department(departmentid),
primaryaffiliation boolean,
unique(physician,department)
)

select * from affiliated_with where   primaryaffiliation ;
--


--------------------
drop table if exists procedure;

create table procedure(
code serial primary key,
name varchar(50),
cost real
)

select * from "procedure" ;


--------------

drop table if exists trained_in;

create table trained_in(
physician int references physician(employeeid),
treatment int references procedure(code),
certification date,
certificationexpires date,
unique(physician,treatment)
)

select * from trained_in ;

------------------

drop table if exists patient;

create table  patient(
ssn serial primary key, 
name varchar(30),
address varchar(30),
phone varchar(15),
insuranceid int,
pcp int references physician(employeeid)
)

select * from patient ;

---------

drop table if exists nurse;

create table nurse (
employeeid serial primary key,
name varchar(30),
position varchar(30),
registered boolean, 
ssn int
);

-- select * from nurse where  registered= true ;

-----------------------

drop table if exists appointment;

create table appointment ( 
appointmentid serial primary key,
patient int references patient(ssn),
prepnurse int references nurse(employeeid),
physician int references physician(employeeid),
start_dt_time timestamp,
end_dt_time timestamp ,
examinationroom varchar(10)
)

select * from appointment;

----------

drop table if exists medication;


create table medication (
code serial primary key, 
name varchar(30),
brand varchar(30),
description varchar(100)
);

select * from medication; 

--------------

drop table if exists prescribes;


create table prescribes ( 
physician int references physician(employeeid),
patient int  references patient(ssn),
medication int references medication(code),
date timestamp,
appointment int references appointment(appointmentid),
dose varchar(20),
unique(physician,patient,medication,date)
)

select * from prescribes ;

------------

drop table if exists block;

create table block ( 
blockfloor int ,
blockcode  int ,
primary key(blockfloor, blockcode)
);

select  * from block;


-------------------

drop table if exists room;

create table room (
roomnumber serial primary key, 
roomtype varchar(20),
blockfloor int,
blockcode int ,
unavailable boolean,
foreign key (blockfloor,blockcode) references block(blockfloor,blockcode)
);

-- select * from room where not unavailable;


-----------------

drop table if exists on_call;

create table on_call (
nurse int references nurse(employeeid),
blockfloor int ,
blockcode int ,
oncallstart timestamp ,
oncallend timestamp ,
unique (nurse, blockfloor, blockcode,oncallstart, oncallend),
foreign key (blockfloor, blockcode) references block(blockfloor,blockcode)
);

select  * from on_call;



-----------------------------------


drop table if exists stay;

create table stay (
stayid serial primary key ,
patient int references patient(ssn),
room int references room(roomnumber),
start_time timestamp,
end_time timestamp 
);

select * from stay;

---------------------------------------

drop table if exists undergoes;

create table undergoes (
patient int references patient(ssn),
procedure int references procedure(code),
stay int references stay(stayid),
date  timestamp ,
physician int references physician(employeeid),
assistingnurse int references nurse(employeeid),
unique(patient, procedure, stay, date)
);

select * from undergoes;


--------------------------------------

