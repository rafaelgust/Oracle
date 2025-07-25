--- AGREGANDO DADOS
----- GROUP BY | Formar os grupos
----- HAVING | Seleciona os grupos a serem recuperados

---- AVG -> M�DIA DO GRUPO [n�mericos]
---- COUNT -> N�MERO DE LINHAS DO GRUPO
---- MAX -> MAIOR VALOR DO GRUPO
---- MIN -> MENOR VALOR DO GRUPO
---- SUM -> SOMATORIO DO GRUPO [n�mericos]
---- STDDEV -> DESVICO PADR�O DO GRUPO
---- VARIANCE -> VARIANCIA DO GRUPO

----- SINTAXY
--------- SELECT fun��o_grupo(coluna), ... FROM tabela [WHERE condi��o] [ORDER BY coluna]

SELECT COUNT(*) FROM pcempr; --- quantidade de funcion�rios
SELECT COUNT(EMAIL) FROM pcempr; --- quantidade de funcion�rios com email
---- COUNT(DISTINCT exp) -> S� VAI CONTAR LINHAS UNICAS
SELECT COUNT(PVENDA) FROM PCTABPR; --- 203738
SELECT COUNT(DISTINCT PVENDA) FROM PCTABPR; --- 89869

--- EVITAR NULOS NO AVG
SELECT AVG(NVL(PVENDA, 0)) FROM PCTABPR;

SELECT AVG(PVENDA) "M�dia", SUM(PVENDA) "Somat�rio", MIN(PVENDA) "M�nimo", MAX(PVENDA) "M�ximo"
    FROM PCTABPR;

SELECT AVG(PVENDA) "M�dia", SUM(PVENDA) "Somat�rio", MIN(PVENDA) "M�nimo", MAX(PVENDA) "M�ximo"
    FROM PCTABPR;
    
SELECT MIN(ADMISSAO) "Mais Antigo", MAX(ADMISSAO) "Mais Recente"
    FROM pcempr;
    
---- GROUP BY - GRUPOS ADICIONAIS
------- SELECT coluna, fun��o_grupo(coluna)
----------- FROM tabela
----------- [WHERE condi��o]
----------- [GROUP BY express�o_group_by]
----------- [ORDER BY coluna];

SELECT CODEPTO, COUNT(*) AS total_produtos --- contando quantos produtos tem de cada CODEPTO
    FROM pcprodut
GROUP BY CODEPTO
ORDER BY CODEPTO;

SELECT MUNICCOB, BAIRROCOB, COUNT(MUNICCOB) AS TOTAL_MUNICIPIO
    FROM PCCLIENT
GROUP BY MUNICCOB, BAIRROCOB
ORDER BY MUNICCOB, BAIRROCOB;

----- COM WHERE
-- SELECT department_id, MAX(salary) FROM employees
-- WHERE MAX(salary) > 10000
-- GROUP BY department_id;
------ c�digo vai quebrar pois WHERE n�o referencia fun��o de grupo -> WHERE MAX(salary) > 10000
------ precisa do HAVING

----- HAVING
--- SELECT coluna, fun��o_grupo
--- FROM tabela
--- [WHERE condi��o_linha]
--- [GROUP BY express�o_grupo]
--- [HAVING condi��o_grupo]
--- [ORDER BY coluna]

-- SELECT department_id, MAX(salary) FROM employees
-- GROUP BY department_id;
-- HAVING MAX(salary)>10000;
----- c�digo vai retornar uma lista agrupada pelo department_id apenas com os salarios superiores a 10000

--------- SEQU�NCIA L�GICA
----- WHERE -> SELECIONA LINHAS
----- GROUP BY -> FORMA OS GRUPOS
----- HAVING -> SELECIONA OS GRUPOS A SEREM RECUPERADOS
----- ORDER BY -> ORDERNAR POR

SELECT job_id, SUM(salary) TOTAL
FROM employees
WHERE job_id <> 'SA_REP'
GROUP BY job_id
HAVING SUM(salary) > 10000
ORDER BY SUM(salary);
--- vai exibir o grupo pelo tipo do job, mostrando apenas a soma dos salarios do JOB que sejam superiores a 10000 e ordernado pela soma dos salarios












