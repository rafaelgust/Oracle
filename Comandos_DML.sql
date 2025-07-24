-- ============================================
-- DML — Data Manipulation Language
-- ============================================

-- Comandos DML são usados para manipular dados nas tabelas:
-- - INSERT → Inserção de dados
-- - UPDATE → Atualização de dados
-- - DELETE → Remoção de dados
-- - COMMIT/ROLLBACK → Controle de transações

-- Uma transação é um conjunto de comandos DML que formam uma unidade lógica de trabalho

-- ============================================
-- INSERT — Inserção de Dados
-- ============================================

-- Sintaxe básica:
-- INSERT INTO nome_da_tabela [(colunas)] VALUES (valores);

-- Strings devem ser colocadas entre aspas simples ('valor')
-- Para valores nulos, pode-se usar NULL explicitamente ou omitir a coluna

-- Inserção com todas as colunas especificadas
INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (208, 'Project Management', 103, 1400);

-- Inserção com NULL explícito
INSERT INTO departments
VALUES (290, 'Data Science', NULL, NULL);

-- Inserção com NULL explícito, mas colunas especificadas
INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (290, 'Data Science', NULL, NULL);

-- Inserção com NULL implícito (colunas omitidas)
INSERT INTO departments (department_id, department_name)
VALUES (300, 'Business Intelligence');

-- COMMIT → comando que confirma (efetiva) as alterações feitas pela transação
COMMIT;

-- ============================================
-- Inserindo valores de data
-- ============================================

-- Inserindo com a data atual do sistema (SYSDATE)
INSERT INTO employees (
    employee_id, first_name, last_name, email, phone_number,
    hire_date, job_id, salary, comission_pct, manager_id, department_id
)
VALUES (
    208, 'Vito', 'Carleone', 'VCORL', '000.000.000',
    SYSDATE, 'IT_PROG', 7000, NULL, 103, 60
);

-- Inserindo com data informada manualmente usando TO_DATE
INSERT INTO employees (
    employee_id, first_name, last_name, email, phone_number,
    hire_date, job_id, salary, comission_pct, manager_id, department_id
)
VALUES (
    209, 'Vitor', 'Carleoner', 'VCORL', '000.000.000',
    TO_DATE('11/02/2020', 'DD/MM/YYYY'), 'IT_PROG', 7000, NULL, 103, 60
);

-- Observação:
-- O usuário que executa o INSERT pode visualizar os dados inseridos com SELECT,
-- mas enquanto não for executado o COMMIT, os dados não estarão disponíveis para outros usuários.
-- O COMMIT grava permanentemente a transação no banco de dados.

-- ============================================
-- INSERT com SELECT
-- ============================================

-- Permite inserir múltiplas linhas de uma vez, copiando dados de outra tabela
INSERT INTO sales_reps (id, name, salary, comission_pct)
SELECT employee_id, last_name, salary, comission_pct
FROM employees
WHERE job_id = 'SA_REP';

-- Esse tipo de INSERT é útil para popular uma nova tabela baseada em critérios específicos de outra tabela
