---- sales.csv into table
COPY sales
FROM '/home/saphal/sales.csv'
DELIMITER ','
CSV HEADER;
------- this gave an error of permission so: done through \copy in CLI.


--DML QUERIES
---1. 
select  * from product 
where brand = 'Cacti Plus'

--2.
select count(*) as TOTAL_SKIN_CARE_PRODUCTS from product 
where category  = 'Skin Care'

--3.
select count(*) as MRP_MORE_THAN_100 from product 
where mrp > 100

--4.
select count(*) as SKIN_CARE_and_MRP_mt100 from product 
where category = 'Skin Care' and mrp > 100

--5.
select brand,count(*) from product 
group by brand ;


--6.
select brand,active,count(*) from product 
group by brand ,active ;

--7.
select * from product 
where category = 'Skin Care' or category = 'Hair Care';

--8.
select * from product 
where category in ('Skin Care', 'Hair Care') and mrp > 100;
	
--9.
select * from product
where category  = 'Skin Care' and brand  = 'Pondy' and mrp > 100

--10. 
select * from product 
where (category = 'Skin Care' or brand  ='Pondy') and mrp > 100

--11.
select product_name  from product 
where  product_name  like 'P%'

--12. 
select product_name from product  
where  product_name like '%Bar%'

--13.
select * from product join sales  on (sales.product_id = product.product_id)
where qty > 2

--14. //counldn't understand the differences question asked
select * from product join sales on (sales.product_id = product.product_id)
where qty > 2



---------------------------------------------------------------------------------------



--Create a new table with columns username and birthday, and dump data from dates file
DROP TABLE IF EXISTS dates;

create table dates (
username varchar(20),
birthday date
)


	-- converting excel file to csv using python script
	import pandas as pd
	read_file = pd.read_excel('dates.xlsx')
	read_file.to_csv('dates.csv', index=None, header=True)

	-- Dump data into table 
	COPY dates
	FROM '/home/saphal/dates.csv'
	DELIMITER ','
	CSV HEADER;




--1. (same birthdate) 
select count(username) as no_of_people_with_same_dob from dates 
where birthday  in (
	select birthday from dates
	group by birthday
	having count(birthday) >1) 
	
	
 
--2. (same birth month) !could extract the month but couldn't get comparison logic :)
select count(username) as no_born_in_same_month from dates  
where extract (month from dates.birthday) in (1,2,3,4,5,6,7,8,9,10,11,12)



--3. (same weekday) !could extract the weekday but couldn't get comparison logic :)
select username, 
extract(week from dates.birthday) as birth_week_day 
from dates;


--4. (same month and weekday) !could extract the weekday and month but couldn't get comparison logic :)
select  username ,
extract (week from dates.birthday) as birth_week_day,
extract(month from dates.birthday) as birth_month
from dates;


--5. Current age of all people
select 
	username, 
	birthday,
	AGE(birthday) as current_age_till_now
from 
	dates; 


