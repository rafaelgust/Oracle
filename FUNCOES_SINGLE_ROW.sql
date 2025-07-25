-- ========================
-- FUNÇÕES SQL E A TABELA DUAL
-- ========================

-- A tabela DUAL é usada em consultas que não precisam acessar uma tabela real,
-- útil para cálculos, testes e uso de funções embutidas.

-- ========================================
-- FUNÇÕES DE MANIPULAÇÃO DE STRINGS (CARACTERES)
-- ========================================

-- Características gerais:
-- - Podem manipular itens de dados.
-- - Recebem argumentos e retornam um valor.
-- - Atuam sobre cada linha retornada.
-- - Retornam um resultado por linha.
-- - Podem modificar o tipo de dado.
-- - Podem ser aninhadas.
-- - Recebem argumentos que podem ser colunas ou expressões.

-- Sintaxe geral: nome_função(argumento1, argumento2, ...)

-- Exemplos:
-- LOWER()     => transforma o texto em minúsculas
-- UPPER()     => transforma o texto em maiúsculas
-- INITCAP()   => primeira letra de cada palavra em maiúscula

-- Exemplo prático com a coluna DESCRICAO da tabela PCPRODUT:
SELECT * FROM pcprodut WHERE DESCRICAO LIKE '%luva%';
-- Não encontra, pois não há caracteres minúsculos na coluna DESCRICAO

SELECT * FROM pcprodut WHERE DESCRICAO LIKE UPPER('%luva%');
-- Converteu para 'LUVA' e encontrou os registros

SELECT * FROM pcprodut WHERE LOWER(DESCRICAO) LIKE '%luva%';
-- Converte o conteúdo da coluna para minúsculo antes de comparar

-- Mais funções úteis para strings:
SELECT 
    CONCAT('VALOR1', 'VALOR2') AS CONCATENADO,           -- Junta os dois valores
    SUBSTR('Introducao ORACLE 19C', 1, 11) AS SUBSTRING, -- Retorna substring do 1º ao 11º caractere
    LENGTH('Introducao ORACLE 19C') AS TAMANHO,          -- Conta o número de caracteres
    INSTR('Introducao ORACLE 19C','ORACLE') AS POSICAO   -- Retorna a posição de 'ORACLE'
FROM dual;

SELECT 
    LPAD('Introducao ORACLE 19C', 30, '*') AS LPAD_EXEMPLO,  -- Preenche com * à esquerda até 30 caracteres
    RPAD('Introducao ORACLE 19C', 30, '*') AS RPAD_EXEMPLO,  -- Preenche com * à direita
    REPLACE('Introducao ORACLE 12C', '12C', '19C') AS SUBSTITUIDO, -- Substitui '12C' por '19C'
    TRIM(';' FROM 'nome@gmail.com;') AS TRIM_TOTAL,          -- Remove ; da esquerda e direita
    LTRIM('  nome@gmail.com', ' ') AS TRIM_ESQUERDA,         -- Remove espaços à esquerda
    RTRIM('nome@gmail.com;', ';') AS TRIM_DIREITA            -- Remove ; da direita
FROM dual;

-- Exemplo de substituição em uma tabela:
SELECT CLIENTE, REPLACE(CLIENTE, 'DROGA BABY LTDA', 'DROGARIA BABY') AS NOVO_NOME
FROM PCCLIENT
WHERE CLIENTE = 'DROGA BABY LTDA';

-- ========================================
-- FUNÇÕES NUMÉRICAS
-- ========================================

-- ROUND(número, casas)    => Arredonda
-- TRUNC(número, casas)    => Trunca (corta) o número sem arredondar
-- MOD(dividendo, divisor) => Resto da divisão
-- ABS(valor)              => Valor absoluto
-- SQRT(valor)             => Raiz quadrada

SELECT 
    ROUND(45.923, 0) AS ARREDONDADO_0,
    ROUND(45.923, 2) AS ARREDONDADO_2A,
    ROUND(45.926, 2) AS ARREDONDADO_2B
FROM dual;

SELECT 
    TRUNC(45.923, 0) AS TRUNCADO_0,
    TRUNC(45.923, 2) AS TRUNCADO_2
FROM dual;

SELECT 
    MOD(1300, 600) AS RESTO_DIVISAO
FROM dual;

SELECT 
    ABS(-9) AS VALOR_ABSOLUTO,
    SQRT(9) AS RAIZ_QUADRADA
FROM dual;

-- ========================================
-- FUNÇÕES DE DATA
-- ========================================

-- A data padrão no Oracle é definida pelo parâmetro NLS_DATE_FORMAT
-- sysdate retorna a data e hora atual do servidor Oracle

SELECT sysdate AS DATA_ATUAL FROM dual;

-- Cálculos com datas:
-- data + número      => adiciona dias
-- data - número      => subtrai dias
-- data - data        => retorna diferença em dias
-- data + n/24        => adiciona n horas

SELECT 
    sysdate AS HOJE,
    sysdate + 30 AS MAIS_30_DIAS,
    sysdate + 60 AS MAIS_60_DIAS,
    sysdate - 30 AS MENOS_30_DIAS
FROM dual;

-- Semanas de trabalho desde a admissão:
SELECT 
    NOME,
    ROUND((sysdate - ADMISSAO)/7, 2) AS SEMANAS_TRABALHO
FROM pcempr;

-- Outras funções de data:
-- MONTHS_BETWEEN(data1, data2) => retorna número de meses entre duas datas
-- ADD_MONTHS(data, n)          => adiciona n meses
-- NEXT_DAY(data, 'DIA_SEMANA') => próxima ocorrência do dia da semana
-- LAST_DAY(data)               => último dia do mês da data
-- ROUND(sysdate, 'MONTH')      => arredonda para o mês mais próximo
-- TRUNC(sysdate, 'MONTH')      => primeiro dia do mês
-- TRUNC(sysdate, 'YEAR')       => primeiro dia do ano
-- TRUNC(sysdate)               => remove parte da hora

SELECT 
    NOME,
    ROUND(MONTHS_BETWEEN(sysdate, ADMISSAO), 2) AS MESES_TRABALHO
FROM pcempr;

SELECT 
    sysdate AS HOJE,
    ADD_MONTHS(sysdate, 3) AS MAIS_3_MESES,
    NEXT_DAY(sysdate, 'SEXTA FEIRA') AS PROXIMA_SEXTA,
    LAST_DAY(sysdate) AS FIM_DO_MES
FROM dual;

-- Formatar data com TO_CHAR para incluir hora completa
SELECT 
    sysdate AS DATA_COMPLETA,
    TO_CHAR(TRUNC(sysdate), 'DD/MM/YYYY HH24:MI:SS') AS DATA_FORMATADA
FROM dual;
