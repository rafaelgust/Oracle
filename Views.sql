-------------------------------------------------------------
-- O QUE É UMA VIEW (VISÃO)
-------------------------------------------------------------

-- Uma VIEW é uma representação lógica baseada em um SELECT
-- sobre uma ou mais tabelas (ou até mesmo outras views).
-- Ela funciona como um SELECT pré-definido e reutilizável.
-- As views são armazenadas no dicionário de dados,
-- contendo a definição (SELECT) que as representa.

-- Vantagens de usar views:
-- 1. Restringir o acesso a dados sensíveis
-- 2. Simplificar consultas complexas
-- 3. Fornecer independência lógica dos dados
-- 4. Apresentar diferentes perspectivas sobre os dados

-------------------------------------------------------------
-- CRIANDO UMA VIEW SIMPLES
-------------------------------------------------------------

-- View que exibe funcionários apenas do departamento 60
CREATE OR REPLACE VIEW vemployeesdept60 AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 60;

-- Descrição da estrutura da view
DESC vemployeesdept60;

-- Consulta à view criada
SELECT * FROM vemployeesdept60;

-------------------------------------------------------------
-- TABELA COMPARATIVA: VIEW SIMPLES X VIEW COMPLEXA
-------------------------------------------------------------

-- | Característica                  | View Simples | View Complexa |
-- |--------------------------------|--------------|---------------|
-- | Número de Tabelas              | Uma          | Uma ou mais   |
-- | Contém Funções Agregadas       | Não          | Sim           |
-- | Contém Agrupamentos (GROUP BY) | Não          | Sim           |
-- | Permite operações DML          | Sim          | Depende       |

-------------------------------------------------------------
-- CRIANDO UMA VIEW COMPLEXA
-------------------------------------------------------------

-- View que mostra dados agregados de salários por departamento
CREATE OR REPLACE VIEW vdepartments_total (
    department_id, department_name, minsal, maxsal, avgsal
) AS
SELECT 
    e.department_id,
    d.department_name,
    MIN(e.salary),
    MAX(e.salary),
    AVG(e.salary)
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY e.department_id, d.department_name;

-- Consulta à view complexa
SELECT * FROM vdepartments_total;

-------------------------------------------------------------
-- CLÁUSULA WITH CHECK OPTION
-------------------------------------------------------------

-- Garante que qualquer modificação (INSERT/UPDATE) mantenha
-- os registros dentro da condição definida no WHERE da view
CREATE OR REPLACE VIEW vemployeesdept100 AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 100
WITH CHECK OPTION CONSTRAINT vemployeesdept100_ck; --- Mantém a validação no 100

-- COMO funciona a cláusula WITH CHECK OPTION?
-- Se você tentar inserir um funcionário com department_id diferente de 100,
-- a inserção será rejeitada.


-------------------------------------------------------------
-- CLÁUSULA WITH READ ONLY
-------------------------------------------------------------

-- Garante que a view seja apenas para consulta,
-- proibindo alterações (INSERT, UPDATE, DELETE)
CREATE OR REPLACE VIEW vemployeesdept20 AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 20
WITH READ ONLY;

-------------------------------------------------------------
-- REMOVENDO UMA VIEW
-------------------------------------------------------------

DROP VIEW vemployeesdept20;
