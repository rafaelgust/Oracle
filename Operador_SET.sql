-- ============================================
-- OPERADORES DE CONJUNTO (SET OPERATORS)
-- ============================================

-- São usados para combinar os resultados de dois ou mais SELECTs
-- Os SELECTs devem ter o mesmo número de colunas e tipos de dados compatíveis
-- A ordenação deve ser feita no SELECT final, após a aplicação do operador

-- ============================================
-- UNION
-- Une os resultados de dois SELECTs eliminando duplicatas
-- Retorna apenas valores distintos
-- ============================================

SELECT employee_id, job_id, hire_date, salary 
FROM employees 
WHERE department_id IN (60, 90, 100)

UNION

SELECT employee_id, job_id, hire_date, salary 
FROM employees 
WHERE job_id = 'IT_PROG'

ORDER BY employee_id;

-- Explicação:
-- Retorna todos os registros dos dois SELECTs, mas remove as linhas duplicadas
-- A ordenação ocorre apenas sobre o resultado final (após o UNION)

-- ============================================
-- UNION ALL
-- Une os resultados de dois SELECTs mantendo as duplicatas
-- Mais performático que UNION
-- ============================================

SELECT employee_id, job_id, hire_date, salary 
FROM employees 
WHERE job_id = 'IT_PROG'

UNION ALL

SELECT employee_id, job_id, hire_date, salary 
FROM employees 
WHERE department_id = 60

ORDER BY employee_id;

-- Explicação:
-- Retorna todos os registros de ambos os SELECTs, incluindo duplicatas
-- Útil quando se deseja contabilizar todos os registros sem filtragem

-- ============================================
-- INTERSECT
-- Retorna apenas os registros que estão presentes em ambos os SELECTs
-- ============================================

SELECT employee_id, job_id
FROM employees
WHERE job_id = 'IT_PROG'

INTERSECT

SELECT employee_id, job_id
FROM employees
WHERE department_id IN (60, 90, 100)

ORDER BY employee_id;

-- Explicação:
-- Retorna os funcionários que possuem job_id = 'IT_PROG' 
-- e também pertencem aos departamentos 60, 90 ou 100

-- ============================================
-- MINUS
-- Retorna os registros do primeiro SELECT que não estão no segundo SELECT
-- Exclusivo do Oracle SQL
-- ============================================

SELECT employee_id, job_id 
FROM employees 
WHERE department_id IN (60, 90, 100)

MINUS

SELECT employee_id, job_id 
FROM employees 
WHERE job_id = 'IT_PROG'

ORDER BY employee_id;

-- Explicação:
-- Retorna os funcionários dos departamentos 60, 90 ou 100
-- exceto os que têm job_id = 'IT_PROG'

-- ============================================
-- BOAS PRÁTICAS E CUIDADOS
-- ============================================

-- 1. Todos os SELECTs combinados por operadores de conjunto
--    devem ter o mesmo número de colunas e tipos de dados compatíveis

-- 2. A ordenação (ORDER BY) só deve ser aplicada **no final** do conjunto completo

-- 3. Para alterar a ordem de execução dos operadores, utilize parênteses:
--    Exemplo: (SELECT ...) UNION ((SELECT ...) MINUS (SELECT ...))

-- 4. UNION vs UNION ALL:
--    - UNION elimina duplicatas → menor performance
--    - UNION ALL mantém duplicatas → melhor performance

-- 5. Operadores INTERSECT e MINUS também eliminam duplicatas por padrão
--    e são exclusivos do Oracle SQL
