--- CONVERSÃO IMPLÍCITA DE TIPO DE DADOS

---- VARCHAR2 OU CHHAR -> NUMBER
---- VACHAR2 OU CHAR -> DATE
---- NUMBER -> VARCHAR2 OU CHHAR
---- DATE -> VARCHAR2 OU CHHAR

---- TO_NUMBER()
---- TO_DATE()
---- TO_CHAR(date, 'formato')

SELECT TO_NUMBER('12000,50') FROM dual;
SELECT TO_DATE('06/02/2020', 'DD/MM/YYYY') FROM dual;

---- ELEMENTOS DE FORMATAÇÃO DA DATA
------ YYYY OU RRRR Ano com quatro dígitos
------ MM Mês com dois dígitos
------ DD Dia do mês com dois dígitos
------ MONTH Nome do mês com 9 caracteres
------ DAY Dia da semana com 9 caracteres

-- DY Dia da semana abreviado com 3 caracteres
-- D Dia da semana de 1 a 7
-- YEAR Ano
-- CC Século
-- AC Exibe se a data é Antes de Cristo ou Depois de Critos
-- HH ou HH12 Hora de 1 a 12
-- HH24 Hora de 0 a 23
-- MI Mínuto
-- SS Segundo

-- Espaço, vírgula ou ponto
-- "Texto"

SELECT NOME, TO_CHAR(ADMISSAO, 'DD/MM/YYYY HH24:MI:SS CC') AS "Admissão"
    FROM pcempr;
    
SELECT sysdate, TO_CHAR(sysdate, 'DD/MM/YYYY HH24:MI:SS CC') AS "Data"
    FROM dual;
    
SELECT NOME, TO_CHAR(ADMISSAO, 'DD, "de" Month "de" YYYY') AS "Admissão"
    FROM pcempr;

SELECT NOME, TO_CHAR(ADMISSAO, 'FMDD, "de" Month "de" YYYY') AS "Admissão"
    FROM pcempr;
    
---- ELEMENTOS DE FORMATAÇÃO PARA NÚMEROS
------ 9 Número com supressão de zeros a esquerda
------ 0 Número incluíndo zeros a partir a esquerda a partir da posição onde foi colocado o elemento do formato (0)
------ $ Exibe o Símbolo Moeda dollar
------ L Exibe o Símbolo de moeda definido pelo parâmetro NLS_CURRENCY
------ . decimal
------ , milhar
------ D Símbolo de decimal definido de acordo com o parâmetro do banco de dados
------ G Símbolo de milhar definido de acordo com o parâmetro do banco de dados


SELECT p.DESCRICAO, TO_CHAR(v.PVENDA, 'L99G999G999D99') as preco
    FROM pcprodut p
        INNER JOIN PCTABPR v ON p.CODPROD = v.CODPROD;
    --- formatado para R$ xx,xxx.xx
    
SELECT NOME, ADMISSAO
    FROM pcempr
    WHERE ADMISSAO = TO_DATE('28/04/2025', 'DD/MM/YYYY');
    
    
---- FUNÇÕES GENÉRICAS
-- NVL (EXPR1, EXPR2) --- SE O PRIMEIRO VALOR FOR NULO, VAI UTILIZAR O SEGUINDO
-- NVL2 (EXPR1, EXPR2, EXPR3) --- SE O PRIMEIRO VALOR FOR NULO, ELE VERIFICA O SEGUINTE E SE FOR NULO ELE VAI PARA O TERCEIRO VALOR
-- NULLIF (EXPR1, EXPR2) --- SE FOR IGUAL A EXPR1 E EXPR2 - IRA RETORNAR NULL, CASO FOR DIFERENTE O NULLIF RETORNA EXPR1
-- COALESCE (EXPR1, EXPR2, ...., EXPRN) --- VAI PROCURAR DA ESQUERDA PRA DIREITA E RETORNAR O PRIMEIRO VALOR QUE NÃO FOR NULO


---- SELECT last_name, salary, NVL(comission_pct, 0), salary*12 SALARIO_ATUAL,
            ---- (salary*12) + (salary*12*NVL(comission_pct, 0)) REMUNERAÇÃO_ANUAL
                --- FROM employee;
--- NVL p/ evitar resultado nulo, uma vez que null x valor é igual a nulo

SELECT NULLIF(1000,1000) FROM dual; -- null
SELECT NULLIF(1000,2000) FROM dual; -- 1000

SELECT COALESCE(NULL, NULL, 'VALOR'), COALESCE(NULL, NULL, 'VALOR1', 'VALOR2'), COALESCE('VALOR1', 'VALOR2', 'VALOR3') FROM dual;
--- retornar VALOR - VALOR1 - VALOR1

---- EXPRESSÕES CONDICIONAIS
--- IF-THEN-ELSE
--- CASE
--- DECODE

------ CASE
-------- CASE expr WHEN expr1 THEN
---------  return_expr1
----------  [WHEN expr2 THEN
----------  return_expr2
----------  WHEN exprN THEN
----------  return_exprN
----------  ELSE
----------  else_expr]
-------- END alias;

SELECT 
    CLIENTE, BAIRROCOB,
        CASE ESTCOB
            WHEN 'MG'
                THEN 'MINAS'
            WHEN 'RJ'
                THEN 'RIO'
            WHEN 'BA'
                THEN 'BAHIA'
            ELSE 'OUTRO'
        END "NOVA COLUNA COM CASE"
FROM PCCLIENT;

------ DECODE
-------- DECODE(col|expressão, arg1, resulta1
--------- [,arg2, result2, ....,]
--------- [, default]
-------- )

SELECT 
    CLIENTE, BAIRROCOB,
        DECODE(ESTCOB,
            'MG', 'MINAS',
            'RJ', 'RIO',
            'BA', 'BAHIA',
            'OUTRO'
        ) "NOVA COLUNA COM DECODE"
FROM PCCLIENT;



