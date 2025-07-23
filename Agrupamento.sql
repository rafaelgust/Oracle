--- AGREGANDO DADOS
----- GROUP BY | Formar os grupos
----- HAVING | Seleciona os grupos a serem recuperados

---- AVG -> MÉDIA DO GRUPO [númericos]
---- COUNT -> NÚMERO DE LINHAS DO GRUPO
---- MAX -> MAIOR VALOR DO GRUPO
---- MIN -> MENOR VALOR DO GRUPO
---- SUM -> SOMATORIO DO GRUPO [númericos]
---- STDDEV -> DESVICO PADRÃO DO GRUPO
---- VARIANCE -> VARIANCIA DO GRUPO

----- SINTAXY
--------- SELECT função_grupo(coluna), ... FROM tabela [WHERE condição] [ORDER BY coluna]

SELECT COUNT(*) FROM pcempr; --- quantidade de funcionários
SELECT COUNT(EMAIL) FROM pcempr; --- quantidade de funcionários com email
---- COUNT(DISTINCT exp) -> SÓ VAI CONTAR LINHAS UNICAS
SELECT COUNT(PVENDA) FROM PCTABPR; --- 203738
SELECT COUNT(DISTINCT PVENDA) FROM PCTABPR; --- 89869

--- EVITAR NULOS NO AVG
SELECT AVG(NVL(PVENDA, 0)) FROM PCTABPR;

SELECT AVG(PVENDA) "Média", SUM(PVENDA) "Somatório", MIN(PVENDA) "Mínimo", MAX(PVENDA) "Máximo"
    FROM PCTABPR;

SELECT AVG(PVENDA) "Média", SUM(PVENDA) "Somatório", MIN(PVENDA) "Mínimo", MAX(PVENDA) "Máximo"
    FROM PCTABPR;
    
SELECT MIN(ADMISSAO) "Mais Antigo", MAX(ADMISSAO) "Mais Recente"
    FROM pcempr;
    
---- GROUP BY - GRUPOS ADICIONAIS
------- SELECT coluna, função_grupo(coluna)
----------- FROM tabela
----------- [WHERE condição]
----------- [GROUP BY expressão_group_by]
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
------ código vai quebrar pois WHERE não referencia função de grupo -> WHERE MAX(salary) > 10000
------ precisa do HAVING

----- HAVING
--- SELECT coluna, função_grupo
--- FROM tabela
--- [WHERE condição_linha]
--- [GROUP BY expressão_grupo]
--- [HAVING condição_grupo]
--- [ORDER BY coluna]

-- SELECT department_id, MAX(salary) FROM employees
-- GROUP BY department_id;
-- HAVING MAX(salary)>10000;
----- código vai retornar uma lista agrupada pelo department_id apenas com os salarios superiores a 10000

--------- SEQUÊNCIA LÓGICA
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












