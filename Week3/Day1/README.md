## Logical Modeling :

> ## Business Requirements:
The given domain comes under health sector.

* Employee information about working on particular day or not.
* Employee information about start time, left time , working hours.
* Know if employee was on_call or not.
* Employee working shift info.
* Analyze based on employee role.
* Analyze salary distribution by department.

According to the requirements and dataset provided, the dimension and fact table can be: 

> ### Dimensions:
*  **employee** - employee_id (PK) , first_name, last_name, dob, location, manager_employee_id, hired_date, terminated_date, terminated_reason, cost_center
*  **employee_role** - role_id (PK), employee_role
*  **department**  - department_id (PK), department_name
*  **punch** - punch_id (PK), year, month, day , week, weekday
*  **shift** - shift_id (PK), shift_type, shift_start_time, shift_end_time
*  **paycode** - paycode_id, paycode

> ### Fact:
* **employee_work** : This table contains the data related to employee timesheet , salary info, hours_worked.


> ### Logical Model :

<img src = 'https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/main/Week3/Day1/ETL%20logical%20Diagram.jpg'>


## Physical Modeling:

The physical model implementd through logical model is : 
> ### [Physical Model](https://github.com/Saphall/Leapfrog_Data-Engineering_Assignments/blob/main/Week3/Day1/src/pipeline/create_schema.ipynb)
