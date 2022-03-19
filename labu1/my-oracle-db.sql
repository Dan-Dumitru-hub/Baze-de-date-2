set serveroutput on;

/*
Sa se afiseze folosind o functie si o procedura stocata (minim) urmatoarea lista:
- nume angajat
- daca numarul de subalterni directi este par
- daca functiile distincte subalternilor directi sunt in numar impar
- care este diferenta maxima de salariu din departamentul lui
- din cate tari distincte are subalterni
- care este salariul maxim pe care il poate obtine el sau un subaltern
*/


CREATE OR REPLACE FUNCTION F_salariu(id_ang NUMBER) RETURN VARCHAR2
AS
maxim Integer;
BEGIN
    
    FOR i IN (SELECT  manager_id FROM employees WHERE manager_id IS NOT NULL)
    LOOP 
        IF id_ang = i.manager_id and maxim <i.salary THEN
            maxim := i.salary;
        END IF;
    END LOOP;
    
    RETURN maxim;
END;
/

CREATE OR REPLACE FUNCTION F_tari_distinc(id_ang NUMBER) RETURN VARCHAR2
AS
tari Integer;
BEGIN
    
    FOR i IN (SELECT DISTINCT department_id FROM employees inner join departments WHERE manager_id IS NOT NULL)
    LOOP 
        IF id_ang = i.manager_id  THEN
            tari := tari +1;
        END IF;
    END LOOP;
    
    RETURN tari;
END;
/

CREATE OR REPLACE FUNCTION F_diferentamaxima(id_ang NUMBER) RETURN VARCHAR2
AS
diff Integer;
BEGIN
    
    FOR i IN (SELECT DISTINCT manager_id FROM employees inner join departments WHERE manager_id IS NOT NULL)
    LOOP 
        IF id_ang = i.manager_id and i.department_id =    THEN
            tari := tari +1;
        END IF;
    END LOOP;
    
    RETURN tari;
END;
/





CREATE OR REPLACE PROCEDURE Afisare(nume VARCHAR2, id_ang NUMBER, diff1 NUMBER, diff2 NUMBER, id_dept NUMBER)
AS
BEGIN
    dbms_output.put_line(RPAD(nume, 50) 
        || RPAD(F_diferentamaxima(id_ang), 15) 
        || RPAD(F_tari_distinc(id_ang), 10)
        || LPAD(F_salariu(id_dept), 10)
        );
END;
/

BEGIN
    dbms_output.put_line(RPAD('Nume', 50) 
        
        );
    dbms_output.put_line(RPAD('*', 50, '*') 
       
        );
    FOR angajat IN (
        SELECT e.first_name||' ' ||e.last_name nume,
            e.EMPLOYEE_ID,
            e.department_id,
            ROUND(j.max_sal - j.avg_sal) diff_medie,
            ROUND(d.max_sal - d.avg_sal) diff_medie2
        FROM EMPLOYEES e
        JOIN (SELECT job_id, MAX(salary) max_sal, AVG(salary) avg_sal 
            FROM EMPLOYEES GROUP BY job_id) j ON j.job_id = e.job_id
        JOIN (SELECT department_id, MAX(salary) max_sal, AVG(salary) avg_sal
            FROM EMPLOYEES GROUP BY department_id) d ON d.department_id = e.department_id
    )
    LOOP
        Afisare(angajat.nume, 
            angajat.EMPLOYEE_ID, 
            );
    END LOOP;
END;