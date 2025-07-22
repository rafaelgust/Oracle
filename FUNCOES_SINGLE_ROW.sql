----- Tabela **dual** para calculos


--- CARACTER�STICAS

---- PODEM MANIPULAR INTES DE DADOS
---- RECEBER ARGUMETNOS E RETORNAR UM VALOR
---- ATUAM SOBRE CADA LINHA RETORNADA
---- RETORNAM UM RESULTADO POR LINHA
---- PODEM MODIFICAR O TIPO DE DADO
---- PODEM SER ANINHADAS
---- RECEBEM ARGUMENTOS QUE PODEM SER COLUNAS OU EXPRESS�ES

---- SINTAXE: nome_fun��o[(arg1, arg2,...)]
--------- LOWER() -> minimiza o texto
--------- UPPER() -> DEIXA O TEXTO MAI�SCULO
--------- INITCAP() -> Primeiro Caracterer Mai�sculo

SELECT * FROM pcprodut WHERE DESCRICAO LIKE '%luva%';
    --- N�o vai encontrar, pois n�o h� caracteres min�sculos na coluna DESCRICAO
    
SELECT * FROM pcprodut WHERE DESCRICAO LIKE UPPER('%luva%');
    --- Converteu para LUVA e encontrou os registros
    
SELECT * FROM pcprodut WHERE LOWER(DESCRICAO) LIKE '%luva%';
    --- COLUNA PASSOU POR UM LOWER, COM ISSO FOI LOCALIZADO O VALOR luva
    
---- FUN��ES PARA MANIPULACAO DE CARACTERES
----- CONCAT('VALOR1', 'VALOR2') -> VALOR1VALOR2 | concatenear
----- SUBSTR('Introdu��o ORACLE 19C', 1, 11) -> Introdu��o | cortou a string do 1 para 11
----- LENGTH('Introdu��o ORACLE 19C') -> 21 | tamanho
----- INSTR('Introdu��o ORACLE 19C','ORACLE') -> 12 | A palavra buscado come�a no index 12 

SELECT 
    CONCAT('VALOR1', 'VALOR2'),
    SUBSTR('Introducao ORACLE 19C', 1, 11),
    LENGTH('Introducao ORACLE 19C'),
    INSTR('Introducao ORACLE 19C','ORACLE')
FROM dual;

----- LPAD('Introdu��o ORACLE 19C',30,'*') -> ATRIBUIU CARACTERES ANTERIOR AO VALOR
----- RPAD('Introdu��o ORACLE 19C',30,'*') -> ATRIBUIU CARACTERES POSTERIOR AO VALOR
----- REPLACE('Introdu��o ORACLE 12C','12C','19C') -> SUBSTITUI CARACTERES
----- TRIM(';' FROM 'nome@gmail.com;') -> REMOVE o valor ';' da STRING 'nome@gmail.com;'
----- RTRIM('nome@gmail.com;', ';') -> REMOVE VALOR DA DIREITA
----- LTRIM('  nome@gmail.com', ' ') -> REMOVE VALOR DA ESQUERDA

SELECT CLIENTE, REPLACE(CLIENTE, 'DROGA BABY LTDA', 'DROGARIA BABY') AS LOCAL
    FROM PCCLIENT
    WHERE CLIENTE = 'DROGA BABY LTDA';
    
---- FUN��ES TIPO NUMBER
----- ROUND - ARREDONDAR
----- TRUNC - TRUCA O VALOR PARA A CASA DECIMAL ESPECIFICA
----- MOD - RETORNAR O RESTO DA DIVISAO
----- ABS - RETORNA O VALOR ABSOLUTO DO N�MERO
----- SQRT - RETORNAR A RAIZ DO N�MERO

SELECT ROUND(45.923,0), ROUND(45.923,2), ROUND(45.926,2) FROM dual;
SELECT TRUNC(45.923,0), TRUNC(45.923,2) FROM dual; -- corta
SELECT MOD(1300,600) AS RESTO FROM dual; -- resto da divis�o
SELECT ABS(-9), SQRT(9) FROM dual;

---- FUN��ES TIPO DATE
----- O formato default de exibi��o de datas � definido pelo 
----- DBA pelo parametro NLS_DATE_FORMAT
--- sysdate DATA DE HOJE

SELECT sysdate FROM dual;

---- C�lculo com datas
----- data + n�mero => data - Adiciona um n�mero de dias para uma data
----- data - n�mero => data - Subtrai um n�mero de dias a partir de uma data
----- data - data => N�mero de dias - Subtrai uma data a partir de outra
----- data + n�mero/24 => data - Adiciona um n�mero de horas para uma data

SELECT sysdate, sysdate + 30, sysdate + 60, sysdate - 30 FROM dual;

SELECT NOME, ROUND((sysdate - ADMISSAO)/7,2) AS "SEMANAS DE TRABALHO" 
    FROM pcempr;
    --- SEMANAS DE TRABALHO A PARTIR DA ADMISSAO COM A DATA ATUAL

---- OUTRAS FUN��ES TIPO DATE
----- MONTHS_BETWEEN -> N�MERO DE MESES ENTRE DATAS
----- ADD_MOUNTHS -> ADICIONA MESES A UMA DATA
----- NEXT_DAY -> PR�XIMO DIA DA DATA ESPECIFICADA | 'que dia � a pr�xima sexta'
----- LAST_DAY -> �LTIMO DIA DO M�S
----- ROUND(sysdate, 'MONTH/YEAR') -> ARREDONDAR A DATA - Se o dia � maior ou menor a metade do m�s
----- TRUNC(sysdate, 'MONTH') -> primeiro dia do m�s
----- TRUNC(sysdate, 'MONTH/YEAR') -> primeiro dia do ano
----- TRUNC(sysdate) -> TRUNCAR A DATA


SELECT NOME, ROUND(MONTHS_BETWEEN(sysdate, ADMISSAO),2) AS "MESES DE TRABALHO" 
    FROM pcempr;
    
SELECT sysdate, ADD_MONTHS(sysdate, 3), NEXT_DAY(sysdate, 'SEXTA FEIRA'), LAST_DAY(sysdate)
    FROM dual;

SELECT sysdate, TO_CHAR(TRUNC(sysdate), 'DD/MM/YYYY HH24:MI:SS') from dual;

