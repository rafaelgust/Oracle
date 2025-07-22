---- DEFINIR VARIAVEIS

DEFINE employee = 101

SELECT employee_id, last_name, salary, department_id
    FROM employees
        WHERE employee_id = &employee_id;
        
UNDEFINE employee_id
