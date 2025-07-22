----- Tabela **dual** para calculos


--- CARACTERÍSTICAS

---- PODEM MANIPULAR INTES DE DADOS
---- RECEBER ARGUMETNOS E RETORNAR UM VALOR
---- ATUAM SOBRE CADA LINHA RETORNADA
---- RETORNAM UM RESULTADO POR LINHA
---- PODEM MODIFICAR O TIPO DE DADO
---- PODEM SER ANINHADAS
---- RECEBEM ARGUMENTOS QUE PODEM SER COLUNAS OU EXPRESSÕES

---- SINTAXE: nome_função[(arg1, arg2,...)]
--------- LOWER() -> minimiza o texto
--------- UPPER() -> DEIXA O TEXTO MAIÚSCULO
--------- INITCAP() -> Primeiro Caracterer Maiúsculo

SELECT * FROM pcprodut WHERE DESCRICAO LIKE '%luva%';
    --- Não vai encontrar, pois não há caracteres minúsculos na coluna DESCRICAO
    
SELECT * FROM pcprodut WHERE DESCRICAO LIKE UPPER('%luva%');
    --- Converteu para LUVA e encontrou os registros
    
SELECT * FROM pcprodut WHERE LOWER(DESCRICAO) LIKE '%luva%';
    --- COLUNA PASSOU POR UM LOWER, COM ISSO FOI LOCALIZADO O VALOR luva
    
---- FUNÇÕES PARA MANIPULACAO DE CARACTERES
----- CONCAT('VALOR1', 'VALOR2') -> VALOR1VALOR2 | concatenear
----- SUBSTR('Introdução ORACLE 19C', 1, 11) -> Introdução | cortou a string do 1 para 11
----- LENGTH('Introdução ORACLE 19C') -> 21 | tamanho
----- INSTR('Introdução ORACLE 19C','ORACLE') -> 12 | A palavra buscado começa no index 12 

SELECT 
    CONCAT('VALOR1', 'VALOR2'),
    SUBSTR('Introducao ORACLE 19C', 1, 11),
    LENGTH('Introducao ORACLE 19C'),
    INSTR('Introducao ORACLE 19C','ORACLE')
FROM dual;

----- LPAD('Introdução ORACLE 19C',30,'*') -> ATRIBUIU CARACTERES ANTERIOR AO VALOR
----- RPAD('Introdução ORACLE 19C',30,'*') -> ATRIBUIU CARACTERES POSTERIOR AO VALOR
----- REPLACE('Introdução ORACLE 12C','12C','19C') -> SUBSTITUI CARACTERES
----- TRIM(';' FROM 'nome@gmail.com;') -> REMOVE o valor ';' da STRING 'nome@gmail.com;'
----- RTRIM('nome@gmail.com;', ';') -> REMOVE VALOR DA DIREITA
----- LTRIM('  nome@gmail.com', ' ') -> REMOVE VALOR DA ESQUERDA

SELECT CLIENTE, REPLACE(CLIENTE, 'DROGA BABY LTDA', 'DROGARIA BABY') AS LOCAL
    FROM PCCLIENT
    WHERE CLIENTE = 'DROGA BABY LTDA';
    
---- FUNÇÕES TIPO NUMBER
----- ROUND - ARREDONDAR
----- TRUNC - TRUCA O VALOR PARA A CASA DECIMAL ESPECIFICA
----- MOD - RETORNAR O RESTO DA DIVISAO
----- ABS - RETORNA O VALOR ABSOLUTO DO NÚMERO
----- SQRT - RETORNAR A RAIZ DO NÚMERO

SELECT ROUND(45.923,0), ROUND(45.923,2), ROUND(45.926,2) FROM dual;
SELECT TRUNC(45.923,0), TRUNC(45.923,2) FROM dual; -- corta
SELECT MOD(1300,600) AS RESTO FROM dual; -- resto da divisão
SELECT ABS(-9), SQRT(9) FROM dual;

---- FUNÇÕES TIPO DATE
----- O formato default de exibição de datas é definido pelo 
----- DBA pelo parametro NLS_DATE_FORMAT
--- sysdate DATA DE HOJE

SELECT sysdate FROM dual;

---- Cálculo com datas
----- data + número => data - Adiciona um número de dias para uma data
----- data - número => data - Subtrai um número de dias a partir de uma data
----- data - data => Número de dias - Subtrai uma data a partir de outra
----- data + número/24 => data - Adiciona um número de horas para uma data

SELECT sysdate, sysdate + 30, sysdate + 60, sysdate - 30 FROM dual;

SELECT NOME, ROUND((sysdate - ADMISSAO)/7,2) AS "SEMANAS DE TRABALHO" 
    FROM pcempr;
    --- SEMANAS DE TRABALHO A PARTIR DA ADMISSAO COM A DATA ATUAL

---- OUTRAS FUNÇÕES TIPO DATE
----- MONTHS_BETWEEN -> NÚMERO DE MESES ENTRE DATAS
----- ADD_MOUNTHS -> ADICIONA MESES A UMA DATA
----- NEXT_DAY -> PRÓXIMO DIA DA DATA ESPECIFICADA | 'que dia é a próxima sexta'
----- LAST_DAY -> ÚLTIMO DIA DO MÊS
----- ROUND(sysdate, 'MONTH/YEAR') -> ARREDONDAR A DATA - Se o dia é maior ou menor a metade do mês
----- TRUNC(sysdate, 'MONTH') -> primeiro dia do mês
----- TRUNC(sysdate, 'MONTH/YEAR') -> primeiro dia do ano
----- TRUNC(sysdate) -> TRUNCAR A DATA


SELECT NOME, ROUND(MONTHS_BETWEEN(sysdate, ADMISSAO),2) AS "MESES DE TRABALHO" 
    FROM pcempr;
    
SELECT sysdate, ADD_MONTHS(sysdate, 3), NEXT_DAY(sysdate, 'SEXTA FEIRA'), LAST_DAY(sysdate)
    FROM dual;

SELECT sysdate, TO_CHAR(TRUNC(sysdate), 'DD/MM/YYYY HH24:MI:SS') from dual;

