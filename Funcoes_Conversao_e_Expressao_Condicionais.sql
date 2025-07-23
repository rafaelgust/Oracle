--- CONVERS�O IMPL�CITA DE TIPO DE DADOS

---- VARCHAR2 OU CHHAR -> NUMBER
---- VACHAR2 OU CHAR -> DATE
---- NUMBER -> VARCHAR2 OU CHHAR
---- DATE -> VARCHAR2 OU CHHAR

---- TO_NUMBER()
---- TO_DATE()
---- TO_CHAR(date, 'formato')

SELECT TO_NUMBER('12000,50') FROM dual;
SELECT TO_DATE('06/02/2020', 'DD/MM/YYYY') FROM dual;

---- ELEMENTOS DE FORMATA��O DA DATA
------ YYYY OU RRRR Ano com quatro d�gitos
------ MM M�s com dois d�gitos
------ DD Dia do m�s com dois d�gitos
------ MONTH Nome do m�s com 9 caracteres
------ DAY Dia da semana com 9 caracteres

-- DY Dia da semana abreviado com 3 caracteres
-- D Dia da semana de 1 a 7
-- YEAR Ano
-- CC S�culo
-- AC Exibe se a data � Antes de Cristo ou Depois de Critos
-- HH ou HH12 Hora de 1 a 12
-- HH24 Hora de 0 a 23
-- MI M�nuto
-- SS Segundo

-- Espa�o, v�rgula ou ponto
-- "Texto"

SELECT NOME, TO_CHAR(ADMISSAO, 'DD/MM/YYYY HH24:MI:SS CC') AS "Admiss�o"
    FROM pcempr;
    
SELECT sysdate, TO_CHAR(sysdate, 'DD/MM/YYYY HH24:MI:SS CC') AS "Data"
    FROM dual;
    
SELECT NOME, TO_CHAR(ADMISSAO, 'DD, "de" Month "de" YYYY') AS "Admiss�o"
    FROM pcempr;

SELECT NOME, TO_CHAR(ADMISSAO, 'FMDD, "de" Month "de" YYYY') AS "Admiss�o"
    FROM pcempr;
    
---- ELEMENTOS DE FORMATA��O PARA N�MEROS
------ 9 N�mero com supress�o de zeros a esquerda
------ 0 N�mero inclu�ndo zeros a partir a esquerda a partir da posi��o onde foi colocado o elemento do formato (0)
------ $ Exibe o S�mbolo Moeda dollar
------ L Exibe o S�mbolo de moeda definido pelo par�metro NLS_CURRENCY
------ . decimal
------ , milhar
------ D S�mbolo de decimal definido de acordo com o par�metro do banco de dados
------ G S�mbolo de milhar definido de acordo com o par�metro do banco de dados


SELECT p.DESCRICAO, TO_CHAR(v.PVENDA, 'L99G999G999D99') as preco
    FROM pcprodut p
        INNER JOIN PCTABPR v ON p.CODPROD = v.CODPROD;
    --- formatado para R$ xx,xxx.xx
    
SELECT NOME, ADMISSAO
    FROM pcempr
    WHERE ADMISSAO = TO_DATE('28/04/2025', 'DD/MM/YYYY');
    
    
---- FUN��ES GEN�RICAS
-- NVL (EXPR1, EXPR2) --- SE O PRIMEIRO VALOR FOR NULO, VAI UTILIZAR O SEGUINDO
-- NVL2 (EXPR1, EXPR2, EXPR3) --- SE O PRIMEIRO VALOR FOR NULO, ELE VERIFICA O SEGUINTE E SE FOR NULO ELE VAI PARA O TERCEIRO VALOR
-- NULLIF (EXPR1, EXPR2) --- SE FOR IGUAL A EXPR1 E EXPR2 - IRA RETORNAR NULL, CASO FOR DIFERENTE O NULLIF RETORNA EXPR1
-- COALESCE (EXPR1, EXPR2, ...., EXPRN) --- VAI PROCURAR DA ESQUERDA PRA DIREITA E RETORNAR O PRIMEIRO VALOR QUE N�O FOR NULO


---- SELECT last_name, salary, NVL(comission_pct, 0), salary*12 SALARIO_ATUAL,
            ---- (salary*12) + (salary*12*NVL(comission_pct, 0)) REMUNERA��O_ANUAL
                --- FROM employee;
--- NVL p/ evitar resultado nulo, uma vez que null x valor � igual a nulo

SELECT NULLIF(1000,1000) FROM dual; -- null
SELECT NULLIF(1000,2000) FROM dual; -- 1000

SELECT COALESCE(NULL, NULL, 'VALOR'), COALESCE(NULL, NULL, 'VALOR1', 'VALOR2'), COALESCE('VALOR1', 'VALOR2', 'VALOR3') FROM dual;
--- retornar VALOR - VALOR1 - VALOR1

---- EXPRESS�ES CONDICIONAIS
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
-------- DECODE(col|express�o, arg1, resulta1
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



