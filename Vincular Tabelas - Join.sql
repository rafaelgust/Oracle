--- MÚLTIPLAS TABELAS

--- As tabelas precisam ter um dado de referência para fazer a conexão
--- EX na tabela usúario tem o ID e na de departamento tem o user_id

SELECT 
    employees.employee_id, employees.last_name, employees.department_id, 
    departments.department_name
FROM employees JOIN departments
    ON (employees.department_id = department.department_id);
    
--- COM ALIAS

SELECT 
    e.employee_id, e.last_name, e.department_id, 
    d.department_name
FROM employees e JOIN departments d
    ON (e.department_id = d.department_id);
    
------ NATURAL JOIN -> LIGAR AS TABELAS COM COLUNAS QUE POSSUEM O MESMO NOME
-------- AMBAS TABELAS POSSUEM A MESMA COLUNA LOCATION_ID
SELECT department_id, department_nome, location_id, city
FROM departments
NATURAL JOIN locations;

------ USING -> DEFINIR O NOME DA TABELA QUE SERÁ VINCULADA
SELECT e.employee_id, e.last_name, d.location_id, department_id, d.department_name
FROM employees e
    JOIN departments d USING(department_id);

------ ON -> CONDIÇÃO QUE LIGA AS TABELAS
SELECT e.employee_id, e.last_name, d.location_id, d.department_id, d.department_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id);

------------- VARIAS TABELAS
SELECT e.employee_id, j.job_title, d.department_name, l.city, l.state_province, l.country_id
    FROM employees e 
        JOIN jobs           j ON e.job_id = j.job_id
        JOIN departments    d ON d.department_id = e.department_id
        JOIN locations      l ON d.location_id = l.location_id
ORDER BY e.employee_id;

----------------- CONDIÇÃO ADICIONAL
SELECT e.employee_id, e.last_name, e.salary, e.department_id, d.department_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id) AND (e.salary BETWEEN 10000 AND 15000); 
----------------- FAZENDO COM WHERE
SELECT e.employee_id, e.last_name, e.salary, e.department_id, d.department_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
WHERE (e.salary BETWEEN 10000 AND 15000);

----- SELF JOIN
SELECT empregado.employee_id 'Id do Empregado', empregado.last_name 'Sobrenome do Empregado' 
    gerente.employee_id 'Id do Gerente', gerente.last_name 'Sobrenome do Gerente'
FROM employees empregado JOIN employees gerente
ON (empregado.manager_id = gerente.employee_id)
ORDER BY empregado.employee_id;


------------------------------- Nonequijoins
--------- JOIN quando a ligação não é definida por uma condição de igualdade

SELECT e.employee_id, e.salary, j.grade_level, j.lowest_sal, j.highest_sal
FROM employees e 
    JOIN job_grades j 
        ON NVL(e.salary, 0) BETWEEN j.lowest_sal AND j.highest_sal --- pega o salario de uma tabela e compara com uma variação de salario de outra tabela
ORDER BY e.salary; 
----
SELECT e.employee_id, e.salary, j.grade_level, j.lowest_sal, j.highest_sal
FROM employees e 
    JOIN job_grades j 
        ON NVL(e.salary,0) >= j.lowest_sal AND ---
        NVL(e.salary,0) <= j.highest_sal --- pega o salario de uma tabela e compara com uma variação de salario de outra tabela
ORDER BY e.salary; 

--------------------------------- INNER JOIN
----------- INNER É UMA NOMENCLATURA OPCIONAL, TODOS OS JOINS APRESENTADOS ANTERIORMENTE UTILIZAM O INNER
----------- NATURAL INNER JOIN
SELECT e.employee_id, j.job_title, d.department_name, l.city, l.state_province, l.country_id
    FROM employees e 
       INNER JOIN jobs           j ON e.job_id = j.job_id
       INNER JOIN departments    d ON d.department_id = e.department_id
       INNER JOIN locations      l ON d.location_id = l.location_id
ORDER BY e.employee_id;

--------------------------------- OUTER JOIN
----------- RETORNA OS REGISTROS QUE NÃO CORRESPONDEM A CONDIÇÃO JOIN

---------- LEFT OUTER JOIN
---- UM JOIN ENTRE DUAS TABELAS QUE RETORNA AS LINHAS QUE RESULTAM DO INNER JOIN E TAMBÉM AS
---- LINHAS QUE NÃO COINCIDEM A PARTIR DA TABELA LEFT É CHAMADO DE LEFT OUTER JOIN

SELECT e.first_name, e.last_name, d.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d --- LEFT -> employees | OS EMPREGADOS QUE NÃO TEM DEPARTAMENTO
    ON (e.department_id = d.department_id) --- vai exibir os empregado que tem relação E OS que não possuem departamento (null)
ORDER BY d.department_id;

---------- RIGHT OUTER JOIN
---- UM JOIN ENTRE DUAS TABELAS QUE RETORNA AS LINHAS QUE RESULTAM DO INNER JOIN E TAMBÉM AS
---- LINHAS QUE NÃO COINCIDEM A PARTIR DA TABELA RIGHT É CHAMADO DE RIGHT OUTER JOIN

SELECT e.first_name, e.last_name, d.department_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d --- LEFT -> departments | O DEPARTAMENTO QUE NÃO TEM EMPREGADOS
    ON (e.department_id = d.department_id) --- vai exibir os departamentos que tem relação E OS que não possuem empregados (null)
ORDER BY d.department_id;

---------- FULL OUTER JOIN

SELECT e.first_name, e.last_name, d.department_id, d.department_name
FROM employees e FULL OUTER JOIN departments d --- FULL -> pega os empregados que não tem departamento e os departamentos que não tem empregados
    ON (e.department_id = d.department_id) --- vai exibir a relação e o RIGHT e LEFT
ORDER BY d.department_id;

--------------------------------- CROSS JOIN - Produto Cartesiano
------------ RETORNA UMA COMBINAÇÃO DE TODAS AS LINHAS DAS TABELAS
------------ COMBINAÇÃO MUITOS PARA MUITOS
SELECT last_name, department_name
FROM employees
    CROSS JOIN departments;
    
------------------------------------------- Sintaxe Oracle
------------------------------- Equijoins 
SELECT e.employee_id, e.salary, d.department_id, d.location_id
FROM employees e,
     departments d
WHERE (e.department_id = d.department_id) --- condição de ligação
ORDER BY e.department_id; 

----- multiplos
SELECT  e.employee_id, e.salary, 
        d.department_id, d.location_id
        l.city, l.state_province, l.country_id
FROM employees e,
     jobs j,
     departments d,
     locations l
WHERE (e.job_id = j.job_id)                 AND
      (d.department_id = e.department_id)   AND
      (d.location_id = l.location_id)
ORDER BY e.employee_id; 
----- multiplos com adicional
SELECT  e.employee_id, e.salary, 
        d.department_id, d.location_id
        l.city, l.state_province, l.country_id
FROM employees e,
     jobs j,
     departments d,
     locations l
WHERE (e.job_id = j.job_id)                 AND
      (d.department_id = e.department_id)   AND
      (d.location_id = l.location_id)       AND
      (e.salary >= 1000)
ORDER BY e.employee_id; 

------------------------------- Nonequijoins
SELECT e.employee_id, e.salary, j.grade_level, j.lowest_sal, j.highest_sal
FROM employees e,
     job_grades j
WHERE NVL(e.salary,0) BETWEEN j.lowest_sal AND j.highest_sal
ORDER BY e.salary;
------------------------------- Outer Join (+)
--- SELECT tabela1.coluna, tabela2.coluna
--- FROM tabela1, tabela2
--- WHERE tabela1.coluna(+) = tabela2.coluna;
------- Lado esquerdo pode não ter valor (null)

--- SELECT tabela1.coluna, tabela2.coluna
--- FROM tabela1, tabela2
--- WHERE tabela1.coluna = tabela2.coluna(+);
------- Lado direito pode não ter valor (null)

--- SELECT tabela1.coluna, tabela2.coluna
--- FROM tabela1, tabela2
--- WHERE tabela1.coluna(+) = tabela2.coluna(+);
------- Ambos podem não ter valor (null)


------------------------------- Self Join (+)
----------- Tabela com ela mesma por meio do alias

SELECT  empregado.employee_id 'Id do Empregado', empregado.last_name 'Sobrenome do Empregado' 
        gerente.employee_id 'Id do Gerente', gerente.last_name 'Sobrenome do Gerente'
FROM    employees empregado,
        employees gerente
WHERE (empregado.manager_id = gerente.employee_id) --- o id do manager_id é o id de um empregado - Self consulta
ORDER BY empregado.employee_id;

SELECT  empregado.employee_id 'Id do Empregado', empregado.last_name 'Sobrenome do Empregado' 
        gerente.employee_id 'Id do Gerente', gerente.last_name 'Sobrenome do Gerente'
FROM    employees empregado,
        employees gerente
WHERE (empregado.manager_id = gerente.employee_id(+)) --- vai aparecer os empregados com seus gerentes E o empregado que não possui gerente
ORDER BY empregado.employee_id;


--------------------------------- CROSS JOIN - Produto Cartesiano
SELECT e.employee, e.first_name, e.last_name, j.job_id, j.job_title
FROM employee e, jobs j;
---- combina todas as linhas de empregados com cada cargo E cada cargo com todos os empregados
---- MUITOS PARA MUITOS
-------* NÃO FAZER - ERRO DE LOGICA QUE VAI CONSUMIR MUITO PROCESSAMENTO/LEITURA
-------* COLOQUE UM WHERE



