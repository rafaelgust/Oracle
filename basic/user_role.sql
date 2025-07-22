
-- Criando usuario admin com dba
create user admin indetified by 'admin_password';
grant dba to admin with admin option;

-- Criando usuario teste com permissões limitadas

create user teste identified by 'teste_password';
grant connect to teste;
grant create session to teste;
grant alter session to teste;

grant select any table to teste;

grant create any table to teste;
grant create any procedure to teste;
grant execute any procedure to teste;
grant create any view to teste;
grant create any trigger to teste;

-- Remover permissões do usuario teste
revoke create any table from teste;
revoke create any procedure from teste;
revoke execute any procedure from teste;
revoke create any view from teste;
revoke create any trigger from teste;
revoke select any table from teste;
revoke alter session from teste;
revoke create session from teste;
revoke connect from teste;

-- Roles [Grupos de Permissões]
-- Nível 1 acesso select
create role nivel_1;
grant connect to nivel_1;
grant create session to nivel_1;
grant alter session to nivel_1;
grant select any table to nivel_1;
grant execute any procedure to nivel_1;

create user usuario_nivel_1 identified by 'nivel_1_password';
grant nivel_1 to usuario_nivel_1;
alter user usuario_nivel_1 default role nivel_1;

-- Nível 2 acesso select, insert, update e delete
create role nivel_2;
grant nivel_1 to nivel_2;

grant insert any table to nivel_2;
grant update any table to nivel_2;
grant delete any table to nivel_2;
grant select any sequence to nivel_2;

create user usuario_nivel_2 identified by 'nivel_2_password';
grant nivel_2 to usuario_nivel_2;
alter user usuario_nivel_2 default role nivel_2;

-- Nível 3 acesso total
create role nivel_3;
grant nivel_2 to nivel_3;

grant create any table to nivel_3;
grant create any procedure to nivel_3;
grant create any view to nivel_3;
grant create any trigger to nivel_3;
grant create any sequence to nivel_3;

grant drop any table to nivel_3;
grant drop any procedure to nivel_3;
grant drop any view to nivel_3;
grant drop any trigger to nivel_3;
grant drop any sequence to nivel_3;

create user usuario_nivel_3 identified by 'nivel_3_password';
grant nivel_3 to usuario_nivel_3;

-- Remover role do usuario
revoke nivel_3 from usuario_nivel_3;