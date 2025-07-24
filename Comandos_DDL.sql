-- ============================================
-- COMANDOS DDL (Data Definition Language)
-- ============================================

-- TABELA (TABLE): Unidade básica de armazenamento, composta por linhas e colunas.
-- VIEW: Representação lógica de uma consulta em uma ou mais tabelas.
-- SEQUENCE: Objeto usado para gerar números sequenciais automaticamente.
-- INDEX: Otimiza o desempenho de consultas (queries), principalmente em colunas utilizadas em cláusulas WHERE e JOIN.
-- SYNONYM: Nome alternativo (apelido) para um objeto do banco de dados, como tabelas, views, procedures, etc.

-- ============================================
-- REGRAS DE NOMENCLATURA PARA TABELAS E OBJETOS
-- ============================================
-- - Deve iniciar com uma letra.
-- - Ter entre 1 a 30 caracteres.
-- - Pode conter letras (A-Z, a-z), números (0-9), underline (_), cifrão ($) e cerquilha (#).
-- - Não pode ser o nome de outro objeto do mesmo schema.
-- - Não pode ser uma palavra reservada do Oracle.

-- ============================================
-- CONSULTA AOS OBJETOS DO USUÁRIO ATUAL (SCHEMA)
-- ============================================
SELECT *
FROM   user_objects
ORDER BY object_type;

-- ============================================
-- EXEMPLO: CRIAÇÃO DE TABELA COM COLUNAS E TIPOS
-- ============================================
CREATE TABLE projects (
    project_id     NUMBER(6)      NOT NULL,
    project_code   VARCHAR2(10)   NOT NULL,
    project_name   VARCHAR2(100)  NOT NULL,
    creation_date  DATE DEFAULT SYSDATE NOT NULL,
    start_date     DATE,
    end_date       DATE,
    status         VARCHAR2(20)   NOT NULL,
    priority       VARCHAR2(10)   NOT NULL,
    budget         NUMBER(11,2)   NOT NULL,
    description    VARCHAR2(400)  NOT NULL
);

-- Verifica a estrutura da tabela
DESC projects;

-- Consulta os dados da tabela (vazia inicialmente)
SELECT * FROM projects;

-- ============================================
-- TIPOS DE DADOS COMUNS NO ORACLE
-- ============================================
-- NUMBER(p,s): Número com precisão (p) e escala (s).
-- VARCHAR2(n): Cadeia de caracteres variável (até n caracteres).
-- CHAR(n): Cadeia de caracteres de tamanho fixo.
-- DATE: Armazena data e hora.
-- CLOB: Texto longo (até 4GB).
-- BLOB: Dados binários longos (até 4GB).
-- TIMESTAMP: Data e hora com fração de segundo.
-- JSON: Armazena documentos JSON.
-- XMLTYPE: Armazena dados XML estruturados.
-- INTERVAL: Armazena intervalos de tempo (anos, meses, dias, horas, etc).
-- ROWID / UROWID: Identificadores únicos de linha.

-- ============================================
-- CRIAR UMA TABELA A PARTIR DE UMA EXISTENTE
-- ============================================
CREATE TABLE employees_department60 AS
SELECT employee_id, last_name, salary * 12 AS annual_salary, hire_date
FROM employees
WHERE department_id = 60;

-- ============================================
-- TRUNCATE TABLE
-- ============================================
-- Remove todas as linhas da tabela de forma rápida e eficiente.
-- IMPORTANTE: Não permite ROLLBACK. A ação é irreversível.
TRUNCATE TABLE projects;

-- ============================================
-- DROP TABLE
-- ============================================
-- Remove a tabela completamente. No Oracle, ela vai para a "lixeira" (recycle bin),
-- permitindo sua restauração caso necessário.

DROP TABLE projects;

-- Consulta à lixeira do usuário
SELECT * FROM user_recyclebin;

-- Para remover a tabela de forma definitiva, sem ir para a lixeira:
DROP TABLE projects PURGE;

