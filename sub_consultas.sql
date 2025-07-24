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
-- USAR O NVL() PARA EVITAR NULOS

-- ============================================
-- Subconsultas com EXISTS e NOT EXISTS
-- ============================================

-- ============================================
-- Operador EXISTS
-- Verifica se a subconsulta retorna pelo menos uma linha
-- Se retornar, o resultado da condição é verdadeiro (TRUE)
-- Ideal para verificar a existência de relacionamentos entre tabelas
-- ============================================
SELECT d.department_id, d.department_name
FROM departments d
WHERE EXISTS (
    SELECT e.department_id
    FROM employees e
    WHERE d.department_id = e.department_id
);
-- Para cada linha da tabela departments, a subconsulta é executada
-- Se existir ao menos um funcionário no departamento, a linha será incluída no resultado
-- É funcionalmente equivalente ao uso do operador IN nesse caso
-- Vantagem: normalmente possui melhor performance que IN,
-- pois o EXISTS pode parar a subconsulta assim que encontrar a primeira correspondência

-- ============================================
-- Operador NOT EXISTS
-- Retorna verdadeiro se a subconsulta NÃO retornar nenhuma linha
-- ============================================
SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT e.department_id
    FROM employees e
    WHERE d.department_id = e.department_id
);
-- Retorna os departamentos que não possuem nenhum funcionário associado
-- Ou seja, a subconsulta não retorna nenhuma linha, então a condição é verdadeira

-- ============================================
-- Considerações sobre EXISTS vs IN
-- ============================================

-- EXISTS:
-- - Avalia se a subconsulta retorna pelo menos uma linha
-- - Não se preocupa com o conteúdo das colunas da subconsulta
-- - Melhor performance em tabelas grandes com índices adequados

-- IN:
-- - Compara um valor específico com uma lista retornada pela subconsulta
-- - Pode ser afetado por valores NULL (especialmente com NOT IN)
-- - Pode ser menos eficiente se a subconsulta retornar muitos valores

-- Dica:
-- Use EXISTS para checagem de existência, especialmente em joins com condições
-- Use IN para comparações diretas com uma lista de valores
