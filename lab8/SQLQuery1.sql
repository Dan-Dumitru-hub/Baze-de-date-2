--ex1
drop table employeesclone
drop table employeesclonewithA
drop table departmentsclone

SELECT *
INTO employeesclone
FROM EMPLOYEES


INSERT INTO employeesclone 
SELECT *
FROM employees A
WHERE NOT EXISTS (
          SELECT *
          FROM employeesclone B
          WHERE A.employee_id = B.employee_id
     )


--ex2

update employeesclone
set salary=salary + salary *15/100
from employeesclone e 
where department_id in (select department_id from employees group by department_id having count(department_id) %2=0)



--ex3
delete E
from employeesclone e
inner join departments d on e.department_id=d.department_id
inner join locations l on l.location_id=d.location_id
where l.country_id like 'US';



--ex4
SELECT *
INTO departmentsclone
FROM departments
where department_name like '%E%'

truncate table departmentsclone


--ex5
SELECT *
INTO employeesclonewithA
FROM EMPLOYEES
where employees.first_name like '%A%' or last_name like '%A%'

merge into employees as target
using employeesclonewithA as source on 
target.employee_id=source.employee_id
when matched then 
	update set target.salary=source.salary;


--ex6
declare @truncate_cmd varchar(4000)
declare truncate_cmd cursor
for select 'DROP TABLE [ ' + TABLE_SCHEMA+ '].[' + TABLE_NAME +']'
from INFORMATION_SCHEMA.TABLES
where TABLE_NAME like '%clone%'
and TABLE_TYPE='BASE_TABLE'

open truncate_cmd
while @@FETCH_STATUS !=0
begin 
	fetch truncate_cmd
	into @truncate_cmd
	exec (@truncate_cmd)
end

close truncate_cmd;
deallocate truncate_cmd
go


--ex7
create or alter function getsalary(@ID INT)
returns int as
begin

declare @result int;

select @result=salary
from employees E
where E.employee_id=@ID

return @result;

end
go

--ex8
--ex9