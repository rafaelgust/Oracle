------------------------------------------------------
-- O QUE É UM ÍNDICE (INDEX)
------------------------------------------------------

-- Um ÍNDICE é um objeto do banco de dados que melhora o desempenho das consultas (SELECT),
-- permitindo localizar dados mais rapidamente.
-- Funciona como um índice de livro: acelera a busca, mas ocupa espaço em disco e 
-- pode impactar a performance de operações DML (INSERT, UPDATE, DELETE).

------------------------------------------------------
-- VANTAGENS DOS ÍNDICES
------------------------------------------------------

-- ✅ Aceleram buscas com cláusulas WHERE, JOIN, ORDER BY
-- ✅ Melhoram a performance em tabelas grandes
-- ✅ Podem ser usados automaticamente pelo otimizador de consultas

-- ⚠️ Mas cuidado:
-- ❌ Podem prejudicar performance em operações de escrita
-- ❌ Ocupam espaço adicional em disco

------------------------------------------------------
-- TIPOS DE ÍNDICES
------------------------------------------------------

-- -> ÍNDICE ÚNICO (UNIQUE INDEX)
--    - Garante que não haja valores duplicados na coluna indexada.

-- -> ÍNDICE NÃO ÚNICO (NON-UNIQUE INDEX)
--    - Melhora a performance, mas não impõe unicidade.

-- -> ÍNDICE COMPOSTO
--    - Cria um índice sobre duas ou mais colunas.

------------------------------------------------------
-- CRIANDO UM ÍNDICE
------------------------------------------------------

-- Índice simples (não único)
CREATE INDEX idx_employees_lastname
ON employees (last_name);

-- Índice único
CREATE UNIQUE INDEX idx_employees_email
ON employees (email);

-- Índice composto
CREATE INDEX idx_employees_dept_salary
ON employees (department_id, salary);

------------------------------------------------------
-- CONSULTANDO ÍNDICES EXISTENTES
------------------------------------------------------

-- Exibir índices criados por você
SELECT index_name, table_name, uniqueness
FROM user_indexes;

-- Exibir colunas de cada índice
SELECT index_name, column_name, column_position
FROM user_ind_columns;

-- Consultando Indices
SELECT ix.index_name,
       ic.column_position,
       ic.column_name,
       ix.index_type,
       ix.uniqueness,
       ix.status
FROM    user_indexes ix
  JOIN user_ind_columns ic ON (ix.index_name = ic.index_name) AND 
                              (ix.table_name = ic.table_name)
WHERE ix.table_name = 'EMPLOYEES'
ORDER BY ix.index_name, ic.column_position; 

------------------------------------------------------
-- RECONSTRUIR O ÍNDICE
------------------------------------------------------

DROP REBUILD idx_employees_lastname;

------------------------------------------------------
-- REMOVENDO UM ÍNDICE
------------------------------------------------------

-- Sintaxe:
-- DROP INDEX nome_indice;

DROP INDEX idx_employees_lastname;

------------------------------------------------------
-- OBSERVAÇÕES IMPORTANTES
------------------------------------------------------

-- 1. Índices são usados automaticamente pelo otimizador de consultas.
-- 2. Não é necessário (e nem recomendado) criar muitos índices em tabelas pequenas.
-- 3. Um índice sobre uma coluna com muitos valores repetidos pode não trazer benefício.
-- 4. Índices não afetam diretamente a lógica da aplicação, mas sim sua performance.

-- DICA: Use EXPLAIN PLAN para analisar se sua consulta está usando um índice.


