USE hr;
GO

--ex1
SELECT  N'am vrut sa folosim unicode'

--ex2
select employee_id 'De ce nu mai avem diacritice în clauza de mai sus?'
, first_name 'pt ca in unicode nu folosim diacritice'
from employees

--ex3 unii employees nu au manager
select E.first_name + E.last_name +M.first_name + M.last_name 
from employees E left join employees M on E.manager_id= M.employee_id

--ex4 
select E.employee_id , E.first_name + E.last_name , De.department_name,E.manager_id
from employees E left Join departments De on E.department_id = De.department_id
left join employees M on E.manager_id=M.employee_id

--ex5
select M.first_name + M.last_name 
from employees E  join employees M on E.manager_id= M.employee_id

--ex6

select D.department_name , E.manager_id
from departments D 
inner join employees E on D.department_id=E.department_id
where E.manager_id = (SELECT manager_id  FROM employees)
group by D.department_name,E.manager_id
having count(D.department_name)%2 =1;

--ex7


--ex8
select * from
employees E, employees M , departments D
where E.employee_id=M.manager_id and
D.department_id=(SELECT department_id  FROM departments ) and 
STDEV(M.salary)>1 and 1.5<STDEV(M.salary)

