------------------------------------------------------
-- USO DE SINÔNIMOS (SYNONYMS)
------------------------------------------------------

-- Um SINÔNIMO é um nome alternativo para um objeto do banco de dados,
-- como tabelas, views, procedures, etc.

-- ✅ VANTAGENS:
-- - Facilita o acesso a objetos que pertencem a outros usuários
-- - Permite usar nomes mais simples ou amigáveis
-- - Evita a necessidade de referenciar o schema do dono original
-- - Ajuda na portabilidade de código entre ambientes

------------------------------------------------------
-- CRIAÇÃO DE SINÔNIMO PRIVADO
-- (Disponível apenas para o usuário que o criou)
------------------------------------------------------

-- Sintaxe:
-- CREATE SYNONYM nome_sinonimo FOR schema.objeto;

-- Exemplo: criando sinônimos privados para a tabela 'departments'
CREATE SYNONYM departamentos FOR departments;      -- Acesso direto
CREATE SYNONYM dept          FOR departments;      -- Nome reduzido

------------------------------------------------------
-- CRIAÇÃO DE SINÔNIMO PÚBLICO
-- (Disponível para todos os usuários do banco)
------------------------------------------------------

-- IMPORTANTE: requer privilégios de DBA (ex: usuário SYS)
-- Sintaxe:
-- CREATE PUBLIC SYNONYM nome_sinonimo FOR schema.objeto;

-- Exemplo: criando sinônimos públicos para acesso universal
-- Conecte-se como SYS (ou outro usuário com privilégio)
CREATE PUBLIC SYNONYM departamentos FOR hr.departments;
CREATE PUBLIC SYNONYM dept          FOR hr.departments;

------------------------------------------------------
-- EXCLUINDO UM SINÔNIMO
------------------------------------------------------

-- Para sinônimo privado:
DROP SYNONYM nome_sinonimo;

-- Para sinônimo público:
DROP PUBLIC SYNONYM nome_sinonimo;

-- Exemplo:
DROP SYNONYM departamentos;
DROP PUBLIC SYNONYM dept;
