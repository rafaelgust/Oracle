------------------------------------------------------
-- O QUE É UMA SEQUENCE
------------------------------------------------------

-- Uma SEQUENCE é um objeto do banco de dados utilizado para gerar 
-- uma sequência numérica automática.
-- Muito usada para gerar valores únicos para colunas como chaves primárias.
-- É armazenada no dicionário de dados e pode ser reutilizada em várias tabelas.

------------------------------------------------------
-- CRIANDO UMA SEQUENCE
------------------------------------------------------

-- Sintaxe básica:
-- CREATE SEQUENCE nome_sequence
--     START WITH valor_inicial
--     INCREMENT BY valor_incremento
--     [MAXVALUE valor_max | NOMAXVALUE]
--     [MINVALUE valor_min | NOMINVALUE]
--     [CYCLE | NOCYCLE]
--     [CACHE n | NOCACHE];

CREATE SEQUENCE seq_employees_id
    START WITH 1000 -- Inicia a sequência em 1000
    INCREMENT BY 1 -- Incrementa de 1 em 1
    NOMAXVALUE -- Não há valor máximo
    NOMINVALUE -- Não há valor mínimo
    CACHE 20 -- Armazena 20 valores em cache para desempenho
    NOCACHE -- Não utiliza cache
    CYCLE -- Reinicia a sequência quando atinge o máximo
    NOCYCLE -- Não reinicia quando atinge o máximo
    ;
    

------------------------------------------------------
-- UTILIZANDO UMA SEQUENCE
------------------------------------------------------

-- Para obter o próximo valor da sequência, usa-se:
-- nome_sequence.NEXTVAL

-- Para visualizar o valor atual (após pelo menos 1 NEXTVAL), usa-se:
-- nome_sequence.CURRVAL

-- Exemplo:
SELECT seq_employees_id.NEXTVAL FROM dual;

-- Inserindo um valor automático com a sequência:
INSERT INTO employees (employee_id, first_name, last_name, department_id, salary)
VALUES (seq_employees_id.NEXTVAL, 'Carlos', 'Souza', 50, 3000);

------------------------------------------------------
-- ALTERANDO UMA SEQUENCE
------------------------------------------------------

-- ALTER SEQUENCE nome_sequence
--     [INCREMENT BY novo_incremento]
--     [MAXVALUE novo_max | NOMAXVALUE]
--     [MINVALUE novo_min | NOMINVALUE]
--     [CYCLE | NOCYCLE]
--     [CACHE n | NOCACHE];

ALTER SEQUENCE seq_employees_id
    INCREMENT BY 5
    MAXVALUE 9999
    NOCYCLE;

------------------------------------------------------
-- REMOVENDO UMA SEQUENCE
------------------------------------------------------

-- DROP SEQUENCE nome_sequence;

DROP SEQUENCE seq_employees_id;

------------------------------------------------------
-- OBSERVAÇÕES IMPORTANTES
------------------------------------------------------

-- 1. CURRVAL só pode ser usado após a primeira chamada de NEXTVAL.
-- 2. A SEQUENCE é independente da tabela: pode ser usada em várias tabelas.
-- 3. É possível configurar a SEQUENCE para reiniciar (CYCLE) ou parar (NOCYCLE) quando atingir o MAXVALUE.
-- 4. O uso de CACHE melhora o desempenho, mas pode perder valores em falhas do sistema.

-- Buracos na numeração:
-- Se a SEQUENCE for incrementada e houver falhas ou rollback, pode haver buracos na sequência.
-- Por exemplo, se você chamar NEXTVAL várias vezes e depois fizer rollback, os valores já gerados não serão reutilizados.
-- Isso é normal e esperado, pois a SEQUENCE é projetada para garantir unicidade, não continuidade.
