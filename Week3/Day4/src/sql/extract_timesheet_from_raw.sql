with CTE_shift_info as(
	select rt.employee_id as employee_id,
		min((case when punch_in_time = '' then null else to_timestamp(punch_in_time,'YYYY-MM-DD HH24-MI-SS')::TIME end)) as shift_start_time,
		max((case when punch_in_time = '' then null else to_timestamp(punch_out_time,'YYYY-MM-DD HH24-MI-SS')::TIME end)) as shift_end_time,
		cast(rt.punch_apply_date as DATE) as shift_date
  	from raw_timesheet rt
  	group by rt.employee_id ,punch_apply_date 
  ) ,
CTE_emp_dept as (
	select employee_id , cast(department_id  as int)
	from raw_employee re 
),
CTE_hours_worked as (
	select employee_id , cast(punch_apply_date as date)  ,sum(cast(hours_worked as float)) as hours_worked 	
	from raw_timesheet
	where paycode ='WRK'
	group by employee_id ,punch_apply_date
),
CTE_break as (
	select employee_id , cast(punch_apply_date as date) ,sum(cast(hours_worked as float)) as Break_hour
	from raw_timesheet 
	where paycode = 'BREAK'
	group by employee_id ,punch_apply_date
),
CTE_charge as (
	select employee_id , cast(punch_apply_date as date) ,sum(cast(hours_worked as float)) as charge_hour
	from raw_timesheet 
	where paycode = 'CHARGE'
	group by employee_id ,punch_apply_date
),
CTE_call as (
	select employee_id , cast(punch_apply_date as date) ,sum(cast(hours_worked as float)) as on_call_hour
	from raw_timesheet 
	where paycode = 'ON_CALL'
	group by employee_id ,punch_apply_date
),
CTE_teammate_absent as (
	select distinct  cast(re.department_id as int) , cast(count(*) as int) as num_teammates_absent , cast(rt.punch_apply_date  as date)
	from raw_employee re join raw_timesheet rt 
	on re.employee_id = rt.employee_id 
	where rt.paycode = 'ABSENT'
	group by  re.department_id , rt.punch_apply_date  
) 
insert into timesheet (employee_id ,department_id,shift_start_time,shift_end_time,shift_date,shift_type,hours_worked,attendance,has_taken_break,
		break_hour,was_charge,charge_hour,was_on_call,on_call_hour,num_teammates_absent) 
select employee_id ,a.department_id,a.shift_start_time,a.shift_end_time,a.shift_date,a.shift_type,a.hours_worked,a.Attendance,a.Has_taken_break,
		a.Break_hour,a.Was_charge,a.charge_hour,a.Was_on_call,a.on_call_hour,cta.num_teammates_absent from (
select csi.employee_id,
	   ced.department_id,
	   shift_start_time,
	   shift_end_time,
	   shift_date,
	   (case when extract(hour from csi.shift_start_time) between 5 and 11 then 'Morning' 
	   		when extract (hour from csi.shift_start_time) >= 12 then 'Night' else null end) as shift_type,
	   (case when chw.hours_worked is not null then chw.hours_worked else 0 end) as hours_worked,
	   (case when csi.shift_start_time is null then false else true end) as Attendance,
	   (case when (csi.employee_id, csi.shift_date) in (select employee_id, punch_apply_date from CTE_break) then true else false end) as Has_taken_break, 
	   (case when cb.Break_hour is not null then cb.Break_hour else 0 end) as Break_hour,
	   (case when (csi.employee_id, csi.shift_date) in (select employee_id, punch_apply_date from CTE_charge) then true else false end) as Was_charge, 
	   (case when cchrg.charge_hour is not null then cchrg.charge_hour else 0 end) as charge_hour,
	   (case when (csi.employee_id, csi.shift_date) in (select employee_id, punch_apply_date from CTE_call) then true else false end) as Was_on_call, 
	   (case when ccall.on_call_hour is not null then ccall.on_call_hour else 0 end) as on_call_hour
from CTE_shift_info csi
join CTE_emp_dept ced on
	csi.employee_id = ced.employee_id
left join CTE_hours_worked chw on 
	csi.employee_id = chw.employee_id and csi.shift_date = chw.punch_apply_date
left join CTE_break cb on 
	csi.employee_id = cb.employee_id and csi.shift_date = cb.punch_apply_date
left join CTE_charge cchrg on 
	csi.employee_id = cchrg.employee_id and csi.shift_date = cchrg.punch_apply_date
left join CTE_call ccall on 
	csi.employee_id = ccall.employee_id and csi.shift_date = ccall.punch_apply_date) a 
left join CTE_teammate_absent cta on 
	a.department_id = cta.department_id and a.shift_date = cta.punch_apply_date ;
