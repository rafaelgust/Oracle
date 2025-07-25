-- Exercício 6
-- Montar pesquisa com as seguintes informações:
--  Numero da Nota
--  Código do cliente
--  Nome do cliente
--  Cidade do cliente
--  Código do primeiro RCA
--  Nome do primeiro RCA
--  Campo descritivo do tipo de RCA (Externo, Interno, Representante)
--  Valor da nota
--  Percentual de comissão da nota
--  Valor da comissão do RCA
-- Observações:
--  Tabelas utilizadas (PCNFSAID / PCCLIENT / PCUSUARI)
--  Filtrar pelo período de 01/01/2005 a 30/06/2005 

SELECT  
    nota_saida.numnota "N�mero da nota",
    nota_saida.codcli "C�digo do cliente", cliente.cliente "Nome do cliente", cliente.municcob "Cidade do cliente", 
    cliente.codusur1 "C�digo do primeiro RCA", rca.nome "Nome do primeiro RCA", 
    CASE
        WHEN rca.tipovend = 'E' 
            THEN 'Externo'
        WHEN rca.tipovend = 'I' 
            THEN 'Interno'
        WHEN rca.tipovend = 'R' 
            THEN 'Representante'
        ELSE
            'Tipo n�o compativel'
    END AS "Campo descritivo do tipo de RCA",
    nota_saida.vltotal "Valor da nota",
    CASE
        WHEN nota_saida.comissao = 0 THEN 0
        ELSE ROUND(( nota_saida.comissao / nota_saida.vltotal * 100), 2)
    END AS "Percentual de comiss�o da nota",
    nota_saida.comissao "Valor da comiss�o do RCA"
FROM PCNFSAID nota_saida 
    JOIN PCCLIENT cliente ON nota_saida.codcli = cliente.codcli
    JOIN PCUSUARI rca ON cliente.codusur1 = rca.codusur
WHERE 
    nota_saida.DTSAIDA BETWEEN TO_DATE('01/10/2010', 'DD/MM/YYYY') AND TO_DATE('20/10/2010', 'DD/MM/YYYY')
;

DESC PCNFSAID
