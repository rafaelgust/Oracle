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

-- =======================================================
-- UPDATE: COMANDO DA DML (Data Manipulation Language)
-- Usado para alterar dados existentes em uma tabela.
-- =======================================================

-- Exemplo 1: Atualização sem cláusula WHERE
UPDATE employees
SET salary = salary * 1.2;
-- Atenção: esse comando atualiza o salário de *todos os empregados*,
-- pois não há filtro (WHERE). Isso pode causar alterações indesejadas.

ROLLBACK;
-- O ROLLBACK desfaz a transação *antes do COMMIT*, revertendo as alterações.

-- Exemplo 2: Atualização com filtro (forma correta)
UPDATE employees
SET salary = salary * 1.2
WHERE last_name = 'King';
-- Aqui, apenas o salário do empregado com sobrenome 'King' será atualizado.

COMMIT;
-- O COMMIT confirma as alterações no banco de dados,
-- tornando-as visíveis para outros usuários.

-- ======================================
-- UPDATE com subconsultas
-- ======================================

-- Exemplo 3: Atualização baseada nos dados de outro empregado
UPDATE employees
SET job_id = (
                SELECT job_id
                FROM employees
                WHERE employee_id = 141
             ),
    salary = (
                SELECT salary
                FROM employees
                WHERE employee_id = 141
             )
WHERE employee_id = 140;
-- Neste caso, o funcionário com ID 140 terá o mesmo cargo (job_id)
-- e salário (salary) que o funcionário com ID 141.

COMMIT;
-- Confirma a atualização dos dados.

-- ======================================
-- Observações importantes:
-- - Sempre utilize a cláusula WHERE para evitar atualizações em massa indesejadas.
-- - Use ROLLBACK antes do COMMIT se identificar erro na transação.
-- - Subconsultas no UPDATE devem retornar apenas um único valor (escalares).

-- =======================================================
-- DELETE: COMANDO DA DML (Data Manipulation Language)
-- Usado para remover registros de uma tabela.
-- =======================================================

-- Exemplo: Remoção de um registro específico
DELETE FROM countries
WHERE country_name = 'Nigeria';
-- Atenção: Sempre utilize a cláusula WHERE para evitar excluir todos os dados da tabela.
-- Neste exemplo, apenas o país com nome 'Nigeria' será removido da tabela countries.

ROLLBACK;
-- O ROLLBACK desfaz a exclusão *caso ela ainda não tenha sido confirmada com COMMIT*.
-- Após o rollback, o registro da 'Nigeria' estará novamente disponível.

-- ======================================
-- Dicas Importantes:
-- - SEMPRE inclua a cláusula WHERE em comandos DELETE para evitar exclusões em massa acidentais.
-- - Utilize ROLLBACK para reverter a transação antes do COMMIT, caso identifique erro ou arrependimento.
-- - Após o COMMIT, a exclusão se torna permanente (a menos que haja mecanismos como backup ou log de recuperação).

-- Exemplo de exclusão perigosa (NUNCA FAÇA ISSO SEM CERTEZA)
-- DELETE FROM countries;
-- Isso removeria *todos* os registros da tabela 'countries'!

-- Finalize com COMMIT se a exclusão for intencional e correta.
-- COMMIT;
