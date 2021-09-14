## Logical Modeling :

> ## Business Requirements:
The given domain comes under health sector according to dataset provided.

* Employee information about working on particular day or not.
* Employee information about start time, left time , working hours.
* Know if employee was on_call or not.
* Employee working shift info.
* Analyze based on employee role.
* Analyze salary distribution by department.

According to the requirements and dataset provided, the dimension and fact table can be: 

> ### Dimensions:
*  **employee_dimension** - employee_id (PK) , first_name, last_name, dob, location, manager_employee_id, hired_date, terminated_date, terminated_reason, cost_center
*  **employee_role_dimension** - role_id (PK), employee_role
*  **department_dimension**  - department_id (PK), department_name
*  **punch_dimension** - punch_id (PK), year, month, day , week, weekday
*  **shift_dimension** - shift_id (PK), shift_type, shift_start_time, shift_end_time
*  **paycode_dimension** - paycode_id, paycode

> ### Fact:
* **employee_work_fact** : This table contains the data related to employee timesheet , salary info, hours_worked.

The description of Entities, Attributes and their domain:


| **Entities**         | **Description**                         | **Domain** |
|----------------------|-----------------------------------------|------------|
|**employee_dimension**| Information about working employee.     |            |
|<p>**Attributes :**</p><p>employee_id</p><p></p><p>first_name</p><p></p><p>last_name</p><p></p><p>dob</p><p></p><p>location</p><p></p><p>manager_employee_id</p><p></p><p>hired_date</p><p></p><p>terminated_date</p><p></p><p>terminated_reason</p><p></p><p>cost_center</p><p></p>|<p></p><p></p><p>Identifier of entity, PK</p><p>First name of employee</p><p>Last name of employee</p><p>Date of Birth</p><p>Location of employee</p><p>ID referencing employee_id of same table (FK)</p><p>Hired Date</p><p>Terminated Date</p><p>Reason for termination</p><p>Cost Center</p>|<p></p><p>Auto Increment</p><p>Text</p><p>Text</p><p>Text</p><p>Valid Id from same table</p><p>Date</p><p>Date</p><p>Text</p><p>Number</p>|
|**employee_role_dimension**| Information about employee role.   |            |
|<p>**Attributes :**</p><p>role_id</p><p></p><p>employee_role</p>|<p></p><p></p><p>Identifier of entity, PK</p><p>Role of employee</p>|<p></p><p>Auto Increment</p><p>Text</p>|
|**department_dimension**| Information about department.         |            |
|<p>**Attributes :**</p><p>department_id</p><p></p><p>department_name</p>|<p></p><p></p><p>Identifier of entity, PK</p><p>Name of department</p>|<p></p><p>Auto Increment</p><p>Text</p>|
|**punch_dimension**| Information about punch dates.             |            |
|<p>**Attributes :**</p><p>punch_id</p><p></p><p>year</p><p>month</p><p>day</p><p>week</p><p>weekday</p>|<p></p><p></p><p>Identifier of entity, PK</p><p>Year</p><p>Month</p><p>Day</p><p>Day of the week</p><p>Which week</p>|<p></p><p>Auto Increment</p><p>Number</p><p>Number</p><p>Number</p><p>Text</p><p>Number</p>|
|**shift_dimension**| Information about which shift, its start time and end time.                          |            |
|<p>**Attributes :**</p><p>shift_id</p><p></p><p>shift_type</p><p>shift_start_time</p><p>shift_end_time</p>|<p></p><p>Identifier of entity, PK<p><p>Shift type<p/><p>Shift Starting Time</p><p>Shift end time</p>|</p><p>Auto Increment</p><p>Text</p><p>Timestamp</p><p>Timestamp</p>|
|**paycode_dimension**| Information about paycode.               |            |
|<p>**Attributes :**</p><p>paycode_id</p><p></p><p>paycode</p>|<p></p><p></p><p>Identifier of entity, PK</p><p>Paycode info</p>|<p>Auto Increment</p><p>Text</p>|
|**employee_work_fact**|The data related to employee facts i.e.timesheet, salary info, hours_worked.       |            |
|<p>**Attributes :**</p><p>employee_id</p><p></p><p>department_id</p><p></p><p>role_id</p><p></p><p>shift_id</p><p></p><p>paycode_id</p><p></p><p>punch_in_time</p><p></p><p>punch_out_time</p><p></p><p>hours_worked</p><p></p><p>fte</p><p></p><p>salary</p><p></p>|<p></p><p></p><p>Id referencing employee_dimension table, FK</p><p>Id referencing department_dimension table, FK</p><p>Id referencing role_dimension table, FK</p><p>Id referencing shift_dimension table, FK</p><p>Id referencing paycode_dimension table, FK</p><p>Punch in time of employee</p><p>Punch out time of employee</p><p>Total hours worked</p><p>fte of employee</p><p>Salary of employee</p>|<p></p><p>Valid id from employee_dimension table</p><p>Valid id from department_dimension table</p><p>Valid id from role_dimension table</p><p>Valid id from shift_dimension table</p><p>Valid id from paycode_dimension table</p><p>Timestamp</p><p>Timestamp</p><p>Number</p><p>Float</p><p>Number</p>|

> ### Logical Model :

<img src = 'https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/main/Week3/Day1/ETL%20logical%20Diagram.jpg'>


## Physical Modeling:

The physical model implementd through logical model is : 
> ### [Physical Model](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/main/Week3/Day1/src/pipeline/create_schema.ipynb)

Requirements:

a) The clients can know what time the employee started and left and hours worked from the fact table by querying the punch_in_time and punch_out_time from the Fact table. We can use the paycode_id referencing paycode_dimension table to know the paycode, and fetch the respective paycode whether they were on charge or on call.

b) The shift info can be know relating the fact table of employee with the shift_dimension table.

c) The information about whether employees are working on weekend or not can be found referencing the punch_dimension table.

d) To analyze whether employee has to cover for other team members, can be known by referencing  aycode_dimension table with paycode 'CHARGE'.

e) To analyze biweekly basis, we can reference the punch_dimension table that contains all the dates with weeks.

f) To analyze data based on employee role, employee_role_dimension can be referenced.

g) To analyze the salary distribution fact, the fact table can be referenced with the department_dimension table to know about salary distribution by department.
