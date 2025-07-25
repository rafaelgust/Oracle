-- Exercício 4
-- Montar pesquisa com as seguintes informações:
--  Número da nota de venda
--  Data da nota de venda
--  Código do cliente
--  Nome do cliente
--  Código do RCA
--  Nome do RCA
--  Número da prestação
--  Data de vencimento
--  Valor
--  Código de cobrança
--  Data de pagamento
--  Valor pago
-- Observações:
--  Tabelas utilizadas (PCPREST / PCNFSAID / PCCLIENT / PCUSUARI)
--  Mostras informações do período de 01/08/2005 a 31/08/2005 das prestações
-- que não foram desdobradas (diferente de DESD)

SELECT  
    contas_receber.duplic "N�mero da nota de venda", contas_receber.dtemissao "Data da nota de venda",
    contas_receber.codcli "C�digo do cliente", cliente.cliente "Nome do cliente", 
    contas_receber.codusur "C�digo do RCA", rca.nome "Nome do RCA", 
    contas_receber.prest "N�mero da presta��o", contas_receber.DTVENC "Data de vencimento", 
    nota_saida.VLTOTAL "Valor", contas_receber.NOSSONUMBCO "C�digo de cobran�a", contas_receber.DTPAG "Data de pagamento",
    contas_receber.VPAGO "Valor pago",
     contas_receber.DTDESD
FROM PCPREST contas_receber 
    JOIN PCNFSAID nota_saida ON contas_receber.duplic = nota_saida.numnota
    JOIN PCCLIENT cliente ON contas_receber.codcli = cliente.codcli
    JOIN PCUSUARI rca ON contas_receber.codusur = rca.codusur
WHERE
   nota_saida.CODCOB <> 'DESD' AND
   contas_receber.DTDESD BETWEEN TO_DATE('01/10/2010', 'DD/MM/YYYY') AND TO_DATE('20/10/2010', 'DD/MM/YYYY') AND  contas_receber.DTDESD IS NOT NULL
;


DESC PCPREST

SELECT table_name
FROM   user_tables;
