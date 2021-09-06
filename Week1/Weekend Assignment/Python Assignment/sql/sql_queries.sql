---------------------- ############# 2.
-- # Create a table named 'users'
-- # -- columns -> id, name, dob, profession 

CREATE TABLE IF NOT EXISTS users(
        id INT generated always as identity primary key,
        name VARCHAR(30) NOT NULL,
        dob date,
        profession VARCHAR(100) NOT NULL
    );
    



---------------- ############ 3. 
-- # Create table names `address`
-- #    -- Columns -> id, user_id (FK -> users), permanent_address, temporary_address

CREATE TABLE IF NOT EXISTS address(
        id  INT generated always as identity primary key,
        user_id int,
        permanent_address VARCHAR(50) NOT NULL,
        temporary_address VARCHAR(50),
        constraint fk_user_id foreign key (user_id) references users(id) 
    );

    

---------------------- ########### 4.
-- # Insert dummy data in the tables using psycopg connection

INSERT INTO users (name, dob, profession)  values
    ('Saphal Shakha', '1998/03/05', 'Programmer'),
    ('Lionel Messi', '1977/05/24', 'AllRounder'),
    ('Cristiano Ronaldo', '1977/01/04', 'Striker'),
    ('Frankie Dejong', '2010/06/05', 'Midfielder');
    

INSERT INTO address (user_id, permanent_address, temporary_address)  Values
    (1, 'Bhaktapur', 'Nepal'),
    (2, 'Rojario', 'Argentina'),
    (3, 'Porto', 'Portugal'),
    (4, 'Barcelona', 'Spain')



    
    
------------------------- ########### 5. 
-- # Fetch data from the joined users and address table 
-- #    -- given user_id
-- #    -- given profession and permanent_address

SELECT u.id, u.profession, a.permanent_address
    FROM users u join address a
    on u.id = a.user_id;





------------------------- ########## 6. 
-- # Update table users and add column gender

ALTER TABLE users add column gender varchar(10) DEFAULT NULL;




--------------------- ########## 7. 
-- # Delete records from user whose age is less than 20 yrs

 DELETE FROM users where users.id in (
        SELECT u.id from users u where  date_part('year', AGE('2021-09-05', u.dob))<20
        );

