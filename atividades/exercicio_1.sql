-- Exercício 1
-- Montar pesquisa com as seguintes informações:
--  Código do cliente
--  Nome do cliente
--  Código do primeiro RCA
--  Nome do primeiro RCA
-- Observações:
--  Tabelas utilizadas (PCCLIENT / PCUSUARI)

SELECT * FROM PCCLIENT;
SELECT * FROM PCUSUARI;

DESC PCCLIENT; -- CODUSUR1

SELECT 
    c.CODCLI, 
    c.CLIENTE, 
    r.CODUSUR, 
    r.NOME
FROM 
    PCCLIENT c
        JOIN PCUSUARI r
ON (c.CODUSUR1 = r.CODUSUR)
ORDER BY 
 r.CODUSUR, r.NOME;


