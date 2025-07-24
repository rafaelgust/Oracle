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


-- ============================================
-- Subconsultas Relacionadas (Correlated Subqueries)
-- ============================================

-- Subconsulta relacionada: usa valores da consulta externa em sua condição
-- Para cada linha da consulta externa, a subconsulta é reavaliada
-- Custo computacional alto em tabelas grandes
-- ============================================

SELECT e1.employee_id, e1.first_name, e1.last_name, e1.department_id, e1.salary
FROM employees e1
WHERE e1.salary >= (
    SELECT TRUNC(AVG(NVL(e2.salary, 0)), 0)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

-- Explicação:
-- Para cada funcionário, a subconsulta calcula a média salarial do departamento dele
-- Em seguida, compara o salário do funcionário com essa média
-- Custo: a subconsulta é executada uma vez para **cada linha** da consulta externa
-- Isso pode causar impacto significativo de performance em grandes volumes de dados
-- Pode ser reescrita com JOINs e CTEs para otimização

-- ============================================
-- Subconsultas com Múltiplas Colunas (Multiple-Column Subquery)
-- ============================================

-- Subconsulta retorna múltiplas colunas (ex: job_id e maior salário por cargo)
-- A comparação também deve ser feita com múltiplas colunas do SELECT externo
-- ============================================

SELECT e1.employee_id, e1.first_name, e1.job_id, e1.salary
FROM employees e1
WHERE (e1.job_id, e1.salary) IN (
    SELECT e2.job_id, MAX(e2.salary)
    FROM employees e2
    GROUP BY e2.job_id
);

-- Explicação:
-- A subconsulta agrupa por cargo (job_id) e retorna o maior salário de cada um
-- A consulta externa retorna os funcionários cujo par (cargo, salário) corresponde
-- ao par (cargo, maior salário) da subconsulta
-- Útil para encontrar o funcionário com maior salário em cada cargo


-- ============================================
-- Subconsulta na cláusula FROM com JOIN
-- ============================================

-- A subconsulta é usada na cláusula FROM como uma "tabela derivada" (tabela temporária resultante da subconsulta)
-- Essa técnica permite o uso de JOINs com os resultados da subconsulta
-- Muito útil quando queremos agregar dados e ainda combinar com outras tabelas
-- ============================================

SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.job_id,
    e.salary,
    ROUND(msj.max_salary, 2) AS max_salary,
    e.salary - ROUND(msj.max_salary, 2) AS diferenca
FROM employees e
LEFT JOIN (
    SELECT job_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY job_id
) msj
    ON e.job_id = msj.job_id;

-- Explicação:
-- A subconsulta nomeada como 'msj' (max_salary_job) retorna o maior salário por cargo (job_id)
-- Essa subconsulta funciona como uma tabela derivada temporária
-- O LEFT JOIN conecta cada funcionário com o maior salário do seu cargo
-- A consulta também calcula a diferença entre o salário atual e o salário máximo do cargo

-- Observações:
-- LEFT JOIN garante que todos os funcionários sejam retornados,
-- mesmo que o cargo não exista na subconsulta (embora raro nesse caso)
-- ROUND é usado para limitar a precisão da exibição do salário máximo e da diferença

-- ============================================
-- 📌 RECOMENDAÇÕES GERAIS SOBRE SUBCONSULTAS
-- ============================================

-- ✅ USE PARENTESES EM TODAS AS SUBCONSULTAS
-- Todas as subconsultas devem estar entre parênteses, mesmo quando a sintaxe parecer opcional.

-- ✅ ESCOLHA O OPERADOR ADEQUADO PARA O TIPO DE SUBCONSULTA
-- - SINGLE-ROW: =, <, >, <=, >=, <>
-- - MULTIPLE-ROW: IN, NOT IN, ANY, ALL, EXISTS, NOT EXISTS

-- ✅ PREFIRA EXISTS A IN QUANDO VERIFICAR EXISTÊNCIA
-- EXISTS geralmente oferece melhor desempenho que IN em grandes conjuntos de dados,
-- especialmente quando há índices envolvidos.

-- ⚠️ EVITE NOT IN COM VALORES NULL
-- Se a subconsulta retornar NULL, NOT IN pode causar a consulta principal a não retornar nenhuma linha.
-- Prefira usar NOT EXISTS nesse tipo de verificação.

-- ⚠️ ATENÇÃO A SUBCONSULTAS CORRELACIONADAS
-- Subconsultas correlacionadas (que usam valores da consulta externa) são executadas repetidamente,
-- uma vez para cada linha da consulta principal, o que pode gerar impacto de performance.
-- Sempre que possível, reescreva usando JOINs ou CTEs.

-- ✅ NOMEIE AS SUBCONSULTAS QUANDO USADAS NO FROM
-- Ao usar uma subconsulta no FROM, sempre dê um nome a ela (alias),
-- pois isso é obrigatório e melhora a clareza do código.

-- ✅ USE ROUND OU TRUNC EM CÁLCULOS MONETÁRIOS
-- Para manter a precisão e legibilidade de valores salariais, arredonde os resultados conforme necessário.

-- ✅ COMENTE SEU CÓDIGO
-- Explicações em forma de comentários ajudam na manutenção e entendimento do código
-- por outros desenvolvedores (ou por você mesmo no futuro).

-- ✅ TESTE A SUBCONSULTA ISOLADAMENTE
-- Sempre que possível, execute a subconsulta sozinha para validar seu comportamento antes de integrá-la.

-- ✅ PREFIRA JOINs PARA AGREGAÇÕES COMPARATIVAS
-- Em muitos casos, um JOIN com uma subconsulta agregada no FROM pode substituir subconsultas correlacionadas,
-- oferecendo melhor desempenho e legibilidade.
