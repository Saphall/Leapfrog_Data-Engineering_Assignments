-- #### Execute the SQL file in PostgreSQL from the terminal

-- psql postgres -h 127.0.0.1 -d hospital -f insert_Queries_from_CSV.sql

-- #### postgres: role, hospital: database , insert_Queries_from+CSV.sql: sql file containing insert commands


\COPY physician FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/physician.csv' DELIMITER ',' CSV HEADER;

\COPY department FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/department.csv' DELIMITER ',' CSV HEADER;

\COPY affiliated_with FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/affiliated_with.csv' DELIMITER ',' CSV HEADER;

\COPY procedure FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/procedure.csv' DELIMITER ',' CSV HEADER;

\COPY trained_in FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/trained_in.csv' DELIMITER ',' CSV HEADER;

\COPY patient FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/patient.csv' DELIMITER ',' CSV HEADER;

\COPY nurse FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/nurse.csv' DELIMITER ',' CSV HEADER;

\COPY appointment FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/appointment.csv' DELIMITER ',' CSV HEADER;

\COPY medication FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/medication.csv' DELIMITER ',' CSV HEADER;

\COPY prescribes FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/prescribes.csv' DELIMITER ',' CSV HEADER;

\COPY undergoes FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/undergoes.csv' DELIMITER ',' CSV HEADER;

\COPY block FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/block.csv' DELIMITER ',' CSV HEADER;

\COPY room FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/room.csv' DELIMITER ',' CSV HEADER;

\COPY on_call FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/on_call.csv' DELIMITER ',' CSV HEADER;

\COPY stay FROM   '/home/saphal/1Saphal/20Data_Engineering/Leapfrog_Intern/Week1/Weekend Assignment/Data Assignment/learn/stay.csv' DELIMITER ',' CSV HEADER;


SELECT * FROM physician;
SELECT * FROM department;
SELECT * FROM affiliated_with;
SELECT * FROM procedure;
SELECT * FROM trained_in;
SELECT * FROM patient;
SELECT * FROM nurse;
SELECT * FROM appointment;
SELECT * FROM medication;
SELECT * FROM prescribes;
SELECT * FROM block;
SELECT * FROM room;
SELECT * FROM on_call;
SELECT * FROM stay;
SELECT * FROM undergoes;



