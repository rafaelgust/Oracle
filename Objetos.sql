------------------------------------------------------
-- SCHEMA OBJECTS
------------------------------------------------------

-- Um **schema** é uma coleção de estruturas lógicas de objetos associados a um usuário do banco de dados.
-- Cada usuário em um banco Oracle possui exatamente **um schema**, com o **mesmo nome do seu username**.

------------------------------------------------------
-- PRINCIPAIS OBJETOS DE UM SCHEMA:
------------------------------------------------------

-- 📌 TABELA (TABLE)
-- Estrutura base para armazenamento de dados.
-- Composta por colunas (campos) e linhas (registros).
-- Ex: employees, departments

-- 📌 VIEW
-- Uma **consulta SQL armazenada** no dicionário de dados.
-- Referencia uma ou mais tabelas ou views.
-- Não armazena dados fisicamente.
-- Útil para restringir ou formatar dados exibidos.

-- 📌 MATERIALIZED VIEW
-- Armazena fisicamente os resultados de uma consulta (diferente da view comum).
-- Pode ser atualizada periodicamente (automática ou manualmente).
-- Usada para melhorar desempenho em grandes consultas.

-- 📌 SINÔNIMO (SYNONYM)
-- Nome alternativo para um objeto de banco (tabela, view, função, etc.).
-- Pode ser:
--   - Privado: válido apenas dentro do schema.
--   - Público (PUBLIC SYNONYM): acessível por qualquer usuário.
-- Facilita o acesso a objetos em outros schemas ou nomes longos.

-- 📌 CONSTRAINT
-- Regras de integridade aplicadas às colunas das tabelas.
-- Tipos:
--   - NOT NULL
--   - UNIQUE
--   - PRIMARY KEY
--   - FOREIGN KEY
--   - CHECK

-- 📌 ÍNDICE (INDEX)
-- Objeto usado para acelerar buscas e ordenar registros.
-- Pode ser criado automaticamente (ex: por PRIMARY KEY) ou manualmente.
-- Tipos comuns:
--   - B-tree (padrão)
--   - Bitmap
--   - Composite (múltiplas colunas)

-- 📌 SEQUÊNCIA (SEQUENCE)
-- Gera números automáticos (geralmente para chaves primárias).
-- Muito usada com triggers ou inserts manuais.
-- Parâmetros:
--   - START WITH: valor inicial
--   - INCREMENT BY: incremento entre valores
--   - NOCACHE / CACHE: desempenho
-- Exemplo:
--   CREATE SEQUENCE seq_funcionario START WITH 1 INCREMENT BY 1;

-- 📌 TRIGGER
-- Bloco PL/SQL que **é executado automaticamente** em resposta a eventos (INSERT, UPDATE, DELETE).
-- Pode ser usado para validações, auditoria, preenchimento automático, etc.
-- Tipos:
--   - BEFORE / AFTER
--   - ON INSERT / UPDATE / DELETE
--   - ROW / STATEMENT
-- Exemplo:
--   CREATE TRIGGER trg_insere_data BEFORE INSERT ON funcionarios
--   FOR EACH ROW BEGIN :NEW.data_cadastro := SYSDATE; END;

-- 📌 DATABASE LINK (DBLINK)
-- Objeto que permite acessar dados em **outro banco Oracle remoto**.
-- Utilizado para realizar consultas ou operações DML entre bancos distintos.
-- Sintaxe:
--   CREATE DATABASE LINK nome_link
--   CONNECT TO usuario IDENTIFIED BY senha
--   USING 'alias_tns';
-- Ex: SELECT * FROM tabela@meulink;

-- 📌 PROCEDURE
-- Bloco nomeado de código PL/SQL que **executa ações específicas** (sem retorno direto).
-- Utilizada para lógica de negócio, automatização de tarefas etc.
-- Ex: gerar relatórios, atualizar dados.

-- 📌 FUNÇÃO (FUNCTION)
-- Semelhante à procedure, mas **retorna um valor** (obrigatoriamente).
-- Pode ser usada em instruções SQL, como parte de SELECTs, WHEREs, etc.

-- 📌 PACKAGE
-- Conjunto agrupado de procedures, funções, variáveis e cursores.
-- Divide-se em:
--   - Specification: interface pública do pacote (declarações).
--   - Body: implementação das funcionalidades.
-- Facilita organização, reutilização e encapsulamento de código PL/SQL.

----------- Consultando Objectos do Schema HR - Schema Objects

-- Conectar como usuário HR

DESC user_objects

SELECT   object_name, object_type, status
FROM     user_objects
ORDER BY object_type;

-- Conectar como usuário SYS (DBA)

DESC DBA_OBJECTS

SELECT   owner, object_name, object_type, status
FROM     dba_objects
WHERE    owner = 'HR'
ORDER BY object_type;

-- Exemplos de consultas a Nonschema Objects pelo Dicionário de Dados Oracle

SELECT *
FROM dba_tablespaces;

SELECT *
FROM   dba_users;

-- Referenciando Objetos de outro Schema (Usuário)

-- Conectar como usuário hr

-- Consultando a Tabela employees do schema do usuário HR

SELECT *
FROM   employees;

SELECT *
FROM   hr.employees;

-- Conectar como usuário sys (DBA)

-- Criar o usuário ALUNO

create user aluno
identified by aluno
default tablespace users
temporary tablespace temp
quota unlimited on users;

grant create session to aluno;


-- Criar uma conexão no SQL Developer para o usuário ALUNO para o banco XEPDB1


-- Conectar como usuário aluno

-- Consultando a Tabela employees do schema do usuário HR

SELECT *
FROM   hr.employees;

-- Erro ORA-00942: a tabela ou view não existe

-- Conectar como usuário hr ou como usuário sys (DBA)

-- Passar o privilégo SELECT no objeto hr.employees para o usuário aluno

GRANT SELECT on hr.employees to aluno;

-- Conectar como usuário aluno

SELECT *
FROM   hr.employees;

-- Conectar como usuário sys (DBA)

-- criar um sinonimo público employees para hr.employees

drop public synonym employees;

create public synonym employees for hr.employees;

-- Conectar como usuário aluno

SELECT *
FROM   employees;


------------------------------------------------------
-- NON-SCHEMA OBJECTS
------------------------------------------------------

-- ❗ Diferente dos objetos de schema (como tabelas, views, procedures),
-- os **non-schema objects** não pertencem a um usuário específico,
-- e sim ao ambiente global do banco de dados.

------------------------------------------------------
-- PRINCIPAIS NON-SCHEMA OBJECTS
------------------------------------------------------

-- 📌 TABLESPACE
-- Estrutura lógica usada para armazenar objetos de banco.
-- Está associada a arquivos físicos no disco.
-- Tipos comuns:
--   - SYSTEM (obrigatória)
--   - SYSAUX (auxiliar)
--   - USERS (default para usuários comuns)
--   - TEMP (operações temporárias)
--   - UNDO (armazenar dados antes de uma transação ser confirmada)

-- Exemplo:
--   CREATE TABLESPACE exemplo_tbs
--   DATAFILE '/caminho/exemplo_tbs01.dbf' SIZE 100M;

------------------------------------------------------

-- 📌 PROFILE
-- Conjunto de regras para controle de recursos e segurança de usuários.
-- Controla:
--   - Tempo máximo de sessão (IDLE_TIME)
--   - Tentativas de login (FAILED_LOGIN_ATTEMPTS)
--   - Expiração de senha (PASSWORD_LIFE_TIME)

-- Exemplo:
--   CREATE PROFILE perfil_restrito LIMIT
--     FAILED_LOGIN_ATTEMPTS 3
--     PASSWORD_LIFE_TIME 30;

------------------------------------------------------

-- 📌 ROLE
-- Conjunto de permissões que pode ser atribuído a usuários.
-- Facilita o gerenciamento de privilégios.

-- Exemplo:
--   CREATE ROLE gerente;
--   GRANT SELECT, INSERT ON vendas TO gerente;
--   GRANT gerente TO usuario1;

------------------------------------------------------

-- 📌 USER
-- Conta de acesso ao banco de dados.
-- Cada usuário possui um schema com o mesmo nome.
-- Pode ser configurado com profile, role, quota, etc.

-- Exemplo:
--   CREATE USER fulano IDENTIFIED BY senha
--   DEFAULT TABLESPACE users
--   TEMPORARY TABLESPACE temp
--   PROFILE default;

------------------------------------------------------

-- 📌 SYSTEM PRIVILEGE
-- Permissões para realizar operações administrativas no banco.
-- Ex: criar tabelas, views, usuários, roles etc.

-- Exemplo:
--   GRANT CREATE USER, DROP USER TO admin;

------------------------------------------------------

-- 📌 OBJECT PRIVILEGE
-- Permissões sobre objetos específicos (tabelas, views, procedures).
-- Ex: SELECT, INSERT, EXECUTE

-- Exemplo:
--   GRANT SELECT ON funcionarios TO usuario;

------------------------------------------------------

-- 📌 RESOURCE LIMIT
-- Define os limites de uso de recursos por sessão (com base no PROFILE).
-- Como tempo de CPU, tempo de inatividade, conexões simultâneas etc.

-- Requer:
--   ALTER SYSTEM SET RESOURCE_LIMIT = TRUE;

------------------------------------------------------

-- 📌 AUDIT
-- Mecanismo para monitorar e registrar ações dos usuários.
-- Pode auditar comandos específicos (como DROP TABLE) ou acessos a objetos.

-- Exemplo:
--   AUDIT DELETE ON funcionarios BY ACCESS;

------------------------------------------------------

-- 📌 DATABASE
-- Representa a instância global do Oracle, incluindo os arquivos físicos,
-- memória, estrutura lógica, parâmetros, etc.

-- Configurações como nome, arquivos de controle, redo logs, e etc
-- fazem parte do contexto de database.

------------------------------------------------------
-- RESUMO COMPARATIVO
------------------------------------------------------

-- SCHEMA OBJECTS: Pertencem a usuários específicos (ex: TABELAS, VIEWS, TRIGGERS)
-- NON-SCHEMA OBJECTS: Pertencem ao banco de dados como um todo (ex: TABLESPACE, ROLE, PROFILE)

