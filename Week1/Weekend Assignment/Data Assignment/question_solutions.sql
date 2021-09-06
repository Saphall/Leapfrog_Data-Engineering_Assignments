
-------############################### QUESTIONS ############### 

--1. 
select name as Head_of_Departments from physician 
where employeeid  in (
	select head from department 
);



--2.
select count(*) as no_of_patients_appointed from patient 
where pcp in (
	select employeeid from physician 
);



--3.

----logic couldn't be obtained by me 

-- got only physician name 
select p.name as Physician from physician p  
join affiliated_with aw on aw.physician = p.employeeid 
where aw.primaryaffiliation;
-- deparment here
select d.name as Department from department d 
join affiliated_with aw on aw.department = d.departmentid 
where aw.primaryaffiliation;


select p.name as physician, d.name as department
from physician p
left join department d on p.employeeid = d.head;


--4.
select count(*) as No_of_available_rooms from room 
where not unavailable;



--5.
select p.name as specialized_physician from physician p 
join trained_in on p.employeeid = trained_in.physician 	
group by p."name"; 



--6. --logic couldn't be obtained 

--- name of physician whose department are not affiliated 
select p.name as Physician from physician p  
join affiliated_with aw on aw.physician = p.employeeid 
where aw.primaryaffiliation = FALSE;
--- not affiliated departments here
select d.name as Department from department d 
join affiliated_with aw on aw.department = d.departmentid 
where not aw.primaryaffiliation;

SELECT p.name AS "Physician", p.position, d.name AS "Department"
FROM physician p
INNER JOIN affiliated_with a ON a.physician=p.employeeid
INNER JOIN department d ON a.department=d.departmentid
WHERE primaryaffiliation='false';


--select p.name , d.name from physician p , department d , affiliated_with aw 
--where aw.primaryaffiliation = false
--group by p.name,d.name;




--7.
select p.name as not_specialized_physician from physician p 
where p.name not in (
	select p.name from physician p 
	join trained_in on p.employeeid = trained_in.physician
	)
group by p."name" ;



--8.
select p.name as patient, count(appointment.patient)
from appointment 
inner join patient p on p.ssn=appointment.patient
group by p.name
having count(appointment.patient)>=1;




--9.
SELECT count(DISTINCT patient) AS no_of_patients_in_room_c
FROM appointment
WHERE examinationroom='C';



--10.
select n.name as nurse, a.examinationroom
from appointment a 
inner join nurse n on a.prepnurse =n.employeeid;


--11.
select p.name AS Patient, ph.name AS Physician
from appointment a
inner join patient p on a.patient =p.ssn
inner join physician ph on a.physician = ph.employeeid
where a.prepnurse is null;


--12.
SELECT p.name as Patient , s.room as Room, r.blockfloor as Floor, r.blockcode as Block
FROM stay s
INNER JOIN patient p ON s.patient=p.ssn
INNER JOIN room r ON s.room=r.roomnumber;


--13.
SELECT p.name AS Patient, ph.name AS Physician, m.name AS Medication
FROM patient p
INNER JOIN prescribes ps ON ps.patient=p.ssn
INNER JOIN physician ph ON ps.physician=ph.employeeid
INNER JOIN medication m ON ps.medication=m.code
WHERE ps.appointment IS NOT NULL;


--14.
SELECT p.name AS Patient, m.name AS Medication
FROM patient p
INNER JOIN prescribes ps ON ps.patient=p.ssn
INNER JOIN medication m ON ps.medication=m.code
WHERE ps.appointment IS NULL;



--15.
SELECT name AS Physician
FROM physician
WHERE employeeid in
( 	SELECT undergoes.physician
     FROM undergoes
     LEFT JOIN trained_in ON undergoes.physician=trained_in.physician
     AND undergoes.procedure=trained_in.treatment
     WHERE treatment IS NULL );

	

--16.
SELECT p.name AS Physician, pr.name AS Procedure, u.date, pt.name AS Patient
FROM physician p, undergoes u, patient pt, procedure pr
WHERE u.patient = pt.SSN
  AND u.procedure = pr.Code
  AND u.physician = p.EmployeeID
  AND NOT EXISTS
    ( SELECT *
     FROM trained_in t
     WHERE t.treatment = u.procedure
       AND t.physician = u.physician );


--17.
SELECT pt.name AS Patient, p.name AS Physician
FROM patient pt
INNER JOIN prescribes pr ON pr.patient=pt.ssn
INNER JOIN physician p ON pt.pcp=p.employeeid
WHERE pt.pcp=pr.physician
  AND pt.pcp=p.employeeid;


--18.
SELECT n.name AS Nurse, o.blockcode AS Block
FROM nurse n
JOIN on_call o ON o.nurse=n.employeeid;


--19.
SELECT p.name AS Patient, y.name AS Physician, n.name AS Nurse,s.end_time AS ReleaseDate ,pr.name as Treatment,
       r.roomnumber AS Room, r.blockfloor AS Floor, r.blockcode AS Block
FROM undergoes u
INNER JOIN patient p ON u.patient=p.ssn
INNER JOIN physician y ON u.physician=y.employeeid
LEFT JOIN nurse n ON u.assistingnurse=n.employeeid
INNER JOIN stay s ON u.patient=s.patient
INNER JOIN room r ON s.room=r.roomnumber
INNER JOIN procedure pr on u.procedure=pr.code;



--20.
SELECT n.name FROM nurse n
WHERE employeeid IN
    ( SELECT oc.nurse FROM on_call oc, room r
     WHERE oc.blockfloor = r.blockfloor
       AND oc.blockcode = r.blockcode
       AND r.roomnumber = 122 );


