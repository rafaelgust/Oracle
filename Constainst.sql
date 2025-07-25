--------------------------------------------------------------------------------
-- CRIAÇÃO E GERENCIAMENTO DE CONSTRAINTS EM SQL
-- Objetivo: aplicar regras de integridade para garantir dados válidos
--------------------------------------------------------------------------------

-- Tipos de Constraints:
--   NOT NULL     → Impede valores nulos
--   UNIQUE       → Garante unicidade dos dados
--   PRIMARY KEY  → Identifica unicamente cada registro (NOT NULL + UNIQUE)
--   FOREIGN KEY  → Garante integridade referencial entre tabelas
--   CHECK        → Impõe regras específicas aos valores de uma coluna

-- Definição:
--   - Pode ser feita na criação da tabela ou depois (ALTER TABLE)
--   - Pode ser declarada a nível de coluna ou de tabela

--------------------------------------------------------------------------------
-- CONSTRAINT NOT NULL
--------------------------------------------------------------------------------

DROP TABLE projects;

CREATE TABLE projects (
    project_id     NUMBER(6)     NOT NULL,
    project_code   VARCHAR2(10)  NOT NULL,
    project_name   VARCHAR2(100) NOT NULL,
    department_id  NUMBER(4)     NOT NULL,
    creation_date  DATE DEFAULT SYSDATE NOT NULL,
    start_date     DATE,
    end_date       DATE,
    status         VARCHAR2(20)  NOT NULL,
    priority       VARCHAR2(10)  NOT NULL,
    budget         NUMBER(11,2)  NOT NULL,
    description    VARCHAR2(400) NOT NULL
);

--------------------------------------------------------------------------------
-- CONSTRAINT PRIMARY KEY
--------------------------------------------------------------------------------

-- Nível de coluna:
DROP TABLE projects;

CREATE TABLE projects (
    project_id     NUMBER(6) CONSTRAINT projects_project_id_pk PRIMARY KEY,
    -- demais colunas...
);

-- Nível de tabela:
DROP TABLE projects;

CREATE TABLE projects (
    project_id     NUMBER(6) NOT NULL,
    -- demais colunas...
    CONSTRAINT projects_project_id_pk PRIMARY KEY (project_id)
);

--------------------------------------------------------------------------------
-- CONSTRAINT UNIQUE
--------------------------------------------------------------------------------

-- Nível de coluna:
DROP TABLE projects;

CREATE TABLE projects (
    project_code   VARCHAR2(10) CONSTRAINT projects_project_code_uk UNIQUE,
    -- demais colunas...
);

-- Nível de tabela:
DROP TABLE projects;

CREATE TABLE projects (
    project_code   VARCHAR2(10) NOT NULL,
    -- demais colunas...
    CONSTRAINT projects_project_code_uk UNIQUE (project_code)
);

--------------------------------------------------------------------------------
-- CONSTRAINT FOREIGN KEY
--------------------------------------------------------------------------------

-- Nível de coluna:
DROP TABLE projects;

CREATE TABLE projects (
    department_id NUMBER(4)
        CONSTRAINT projects_department_id_fk REFERENCES departments(department_id),
    -- demais colunas...
);

-- Nível de tabela:
DROP TABLE projects;

CREATE TABLE projects (
    department_id NUMBER(4) NOT NULL,
    -- demais colunas...
    CONSTRAINT projects_department_id_fk FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

--------------------------------------------------------------------------------
-- FOREIGN KEY COM REGRAS DE EXCLUSÃO
--------------------------------------------------------------------------------

-- ON DELETE NO ACTION (comportamento padrão)
DROP TABLE teams;

CREATE TABLE teams (
    project_id  NUMBER(6),
    employee_id NUMBER(6),
    CONSTRAINT teams_project_id_fk FOREIGN KEY (project_id) REFERENCES projects(project_id),
    CONSTRAINT teams_employee_id_fk FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- ON DELETE CASCADE
DROP TABLE teams;

CREATE TABLE teams (
    project_id  NUMBER(6),
    employee_id NUMBER(6),
    CONSTRAINT teams_project_id_fk FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    CONSTRAINT teams_employee_id_fk FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- ON DELETE SET NULL
DROP TABLE teams;

CREATE TABLE teams (
    project_id  NUMBER(6),
    employee_id NUMBER(6),
    CONSTRAINT teams_project_id_fk FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE SET NULL,
    CONSTRAINT teams_employee_id_fk FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

--------------------------------------------------------------------------------
-- CONSTRAINT CHECK
--------------------------------------------------------------------------------

-- Restrições:
--   Não pode usar: SYSDATE, USER, ROWNUM, etc.
--   Só valida valores da própria linha

-- Nível de coluna:
DROP TABLE projects CASCADE CONSTRAINTS;

CREATE TABLE projects (
    budget NUMBER(11,2)
        CONSTRAINT projects_budget_ck CHECK (budget > 0),
    -- demais colunas...
);

-- Nível de tabela:
DROP TABLE projects CASCADE CONSTRAINTS;

CREATE TABLE projects (
    budget NUMBER(11,2) NOT NULL,
    -- demais colunas...
    CONSTRAINT projects_budget_ck CHECK (budget > 0)
);

--------------------------------------------------------------------------------
-- TESTANDO VIOLAÇÃO DE FOREIGN KEY
--------------------------------------------------------------------------------

-- ❌ Falha (department_id = 77 não existe)
INSERT INTO projects (...) VALUES (..., 77, ...);

-- ✅ Correto (department_id existente)
INSERT INTO projects (...) VALUES (..., 60, ...);

--------------------------------------------------------------------------------
-- GERENCIAMENTO DE CONSTRAINTS (ALTER TABLE)
--------------------------------------------------------------------------------

-- REMOVER CONSTRAINT
ALTER TABLE projects DROP CONSTRAINT projects_project_id_pk;
-- Ou com CASCADE se houver dependências:
ALTER TABLE projects DROP CONSTRAINT projects_project_id_pk CASCADE;

-- ADICIONAR CONSTRAINT
ALTER TABLE projects ADD CONSTRAINT projects_project_id_pk PRIMARY KEY (project_id);
ALTER TABLE projects ADD CONSTRAINT projects_department_id_fk FOREIGN KEY (department_id)
    REFERENCES departments(department_id);

-- DESABILITAR CONSTRAINT
ALTER TABLE projects DISABLE CONSTRAINT projects_project_id_pk;
ALTER TABLE projects DISABLE CONSTRAINT projects_project_id_pk CASCADE;

-- HABILITAR CONSTRAINT
ALTER TABLE projects ENABLE CONSTRAINT projects_project_id_pk;
ALTER TABLE projects ENABLE CONSTRAINT projects_project_id_pk CASCADE;

--------------------------------------------------------------------------------
-- CONSULTANDO CONSTRAINTS NO DICIONÁRIO DE DADOS
--------------------------------------------------------------------------------

-- Estrutura das views:
DESC user_constraints;
DESC user_cons_columns;

-- Consulta completa da tabela PROJECTS:
SELECT
    co.constraint_name,
    co.constraint_type,         -- P (PK), U (UNIQUE), R (FK), C (CHECK/NOT NULL)
    co.search_condition,        -- Condição CHECK (se existir)
    co.r_constraint_name,       -- Constraint referenciada (para FKs)
    co.delete_rule,             -- CASCADE, SET NULL, etc.
    cc.column_name,
    cc.position,
    co.status                   -- ENABLED / DISABLED
FROM user_constraints co
JOIN user_cons_columns cc
    ON co.constraint_name = cc.constraint_name
   AND co.table_name = cc.table_name
WHERE co.table_name = 'PROJECTS'
ORDER BY co.constraint_name, cc.position;
