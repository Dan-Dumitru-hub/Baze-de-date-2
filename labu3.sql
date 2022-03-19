set serveroutput on;

declare 
    idangajat number := &idangajat;
    nume varchar2(50);
    functie jobs.job_title%type;
    emp employees%rowtype;
begin
    select e.last_name , j.job_title
    into nume,functie
    from employees e natural join jobs j
    where employee_id = idangajat;
    
    select * into emp
    from employees where employee_id = idangajat;
    
exception
    
    when no_data_found 
    then dbms_output.put_line('nu');
    end;
