-- ============================================
-- Exemplos de Subconsultas em SQL
-- ============================================

-- ============================================
-- Subconsulta no SELECT
-- Retorna o nome do funcionário e o maior salário do seu departamento
-- ============================================
SELECT nome, 
       (SELECT MAX(salario) 
        FROM funcionarios f2 
        WHERE f2.departamento = f1.departamento) AS salario_maximo
FROM funcionarios f1;

-- ============================================
-- Subconsulta no WHERE
-- Retorna os funcionários que têm o maior salário do seu departamento
-- ============================================
SELECT nome, salario
FROM funcionarios f1
WHERE salario = (
    SELECT MAX(salario) 
    FROM funcionarios f2 
    WHERE f2.departamento = f1.departamento
);

-- ============================================
-- Subconsulta no FROM
-- Retorna os funcionários com o maior salário por departamento
-- ============================================
SELECT f1.nome, f1.salario
FROM funcionarios f1,
     (SELECT departamento, MAX(salario) AS salario_maximo 
      FROM funcionarios 
      GROUP BY departamento) f2
WHERE f1.departamento = f2.departamento 
  AND f1.salario = f2.salario_maximo;

-- ============================================
-- Boas práticas com subconsultas
-- ============================================

-- A subconsulta deve estar sempre entre parênteses
-- É recomendável colocá-la à direita do operador de comparação para melhor legibilidade
-- Exemplo: coluna = (subconsulta)

-- Use operadores compatíveis com o tipo de subconsulta:
-- - Subconsulta que retorna uma linha (single-row): =, >, <, >=, <=, <>
-- - Subconsulta que retorna várias linhas (multiple-row): IN, ANY, ALL, EXISTS

-- ============================================
-- Subconsulta do tipo SINGLE-ROW
-- Retorna os funcionários com salário acima da média da empresa
-- ============================================
SELECT first_name, last_name, job_id, salary
FROM employees
WHERE salary > (
    SELECT AVG(NVL(salary, 0)) 
    FROM employees
);

-- ============================================
-- Subconsulta com HAVING
-- Retorna departamentos cuja maior faixa salarial é inferior à média geral
-- ============================================
SELECT e1.department_id, MAX(e1.salary)
FROM employees e1
GROUP BY e1.department_id
HAVING MAX(e1.salary) < (
    SELECT AVG(e2.salary) 
    FROM employees e2
);

-- ============================================
-- Erro comum: subconsulta retorna múltiplas linhas com operador single-row
-- Esta consulta resultará em erro, pois o operador "=" espera apenas um valor
-- ============================================
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary = (
    SELECT AVG(salary)
    FROM employees
    GROUP BY department_id
);

-- ============================================
-- Quando a subconsulta não retorna nenhuma linha
-- Se nenhum sobrenome 'Suzuki' for encontrado, o resultado da principal será nulo
-- ============================================
SELECT employee_id, first_name, last_name
FROM employees
WHERE last_name = (
    SELECT last_name 
    FROM employees 
    WHERE last_name = 'Suzuki'
);

-- ============================================
-- Subconsultas do tipo MULTIPLE-ROW
-- ============================================

-- ============================================
-- Operador IN
-- Compara o valor da consulta principal com uma lista de valores retornados pela subconsulta
-- A subconsulta deve retornar múltiplas linhas
-- ============================================
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary IN (
    SELECT AVG(NVL(salary, 0))
    FROM employees
    GROUP BY department_id
);
-- A consulta principal retornará funcionários cujo salário está presente
-- na lista de médias salariais por departamento
-- A cada linha, o salário do funcionário é comparado com a lista retornada

-- ============================================
-- Operador NOT IN
-- Retorna registros cujo valor NÃO está na lista retornada pela subconsulta
-- ============================================
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary NOT IN (
    SELECT AVG(NVL(salary, 0))
    FROM employees
    GROUP BY department_id
);
-- A consulta retorna os funcionários com salários que não correspondem
-- a nenhuma das médias por departamento

-- ⚠️ CUIDADO:
-- Se a subconsulta retornar pelo menos um valor NULL, o operador NOT IN
-- pode fazer com que a consulta principal retorne zero resultados
-- Isso ocorre porque qualquer comparação com NULL resulta em UNKNOWN

-- ============================================
-- Operador ANY
-- Compara o valor da consulta principal com **qualquer** valor da lista da subconsulta
-- Use com operadores como =, >, <, etc.
-- ============================================
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary > ANY (
    SELECT salary 
    FROM employees 
    WHERE job_id = 'IT_PROG'
);
-- Retorna os funcionários com salário maior que pelo menos um salário
-- de alguém com o cargo 'IT_PROG'

-- ============================================
-- Operador ALL
-- Compara o valor da consulta principal com **todos** os valores da subconsulta
-- ============================================
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary < ALL (
    SELECT salary 
    FROM employees 
    WHERE job_id = 'IT_PROG'
);
-- Retorna os funcionários com salário menor que todos os salários
-- das pessoas com cargo 'IT_PROG'

-- ============================================
-- Considerações importantes sobre NULL
-- ============================================

-- O operador IN ignora valores NULL dentro da subconsulta,
-- pois internamente utiliza OR entre as comparações
-- Ex: salary = valor1 OR salary = valor2 OR ...

-- Já o operador NOT IN falha silenciosamente quando a subconsulta
-- retorna pelo menos um valor NULL, pois:
-- Ex: salary != valor1 AND salary != NULL -> resultado UNKNOWN
-- Isso faz com que nenhuma linha seja retornada

