-- Exerc√≠cio 3
-- Montar pesquisa com as seguintes informa√ß√µes:
--  Data de movimenta√ß√£o do produto
--  N√∫mero da N.F.
--  C√≥digo do cliente
--  Nome do cliente
--  C√≥digo do produto
--  Descri√ß√£o do produto
--  C√≥digo de opera√ß√£o da movimenta√ß√£o
--  Quantidade movimentada
--  Pre√ßo unit√°rio do produto
--  Valor total da movimenta√ß√£o (quantidade movimentada * pre√ßo unit√°rio do
-- produto)
-- Observa√ß√µes:
--  Tabelas utilizadas (PCMOV / PCCLIENT / PCPRODUT)
--  Per√≠odo solicitado: de 01/08/2005 a 31/08/2005
--  C√≥digo de opera√ß√£o = ‚ÄòS‚Äô 

DESC PCMOV

SELECT  
    mov.dtmov AS "Data de movimentaÁ„o do produto",
    mov.numnota AS "N˙mero da N.F", 
    mov.codcli AS "CÛdigo do cliente",
    client.cliente AS "Nome do cliente", 
    mov.codprod AS "CÛdigo do produto",
    product.descricao AS "DescriÁ„o do produto", 
    mov.CODOPER AS "CÛdigo de operaÁ„o da movimentaÁ„o", 
    mov.qt AS "Quantidade movimentada", 
    mov.PUNIT AS "PreÁo unit·rio do produto",
    NVL(mov.PUNIT, 0) * NVL(mov.qt, 0) AS "Valor total da movimentaÁ„o"
FROM PCMOV mov 
    JOIN PCCLIENT client ON mov.codcli = client.codcli
    JOIN PCPRODUT product ON mov.codprod = product.codprod
WHERE mov.CODOPER = 'S' AND
      mov.dtmov BETWEEN TO_DATE('01/10/2010', 'DD/MM/YYYY') AND TO_DATE('20/10/2010', 'DD/MM/YYYY')
ORDER BY mov.dtmov;

