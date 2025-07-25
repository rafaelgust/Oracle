--  Exercício 8
-- Montar pesquisa com as seguintes informações:
--  Texto fixo informando que a nota fiscal é de venda (saída)
--  Número da nota fiscal
--  Data de emissão da nota fiscal
--  Código do cliente
--  Nome do cliente
--  Valor da nota fiscal
-- Unindo com
--  Texto fixo informando que a nota fiscal é de entrada
--  Número da nota fiscal
--  Data de emissão da nota fiscal
--  Código do fornecedor
--  Nome do fornecedor
--  Valor da nota fiscal
-- Observações:
--  Tabelas utilizadas
-- o Pesquisa 1: (PCNFSAID / PCCLIENT)
-- o Pesquisa 2: (PCNFENT / PCFORNEC)
--  Período de 01/01/2006 a 30/04/2006 


SELECT 
    'Saída' 				"Tipo de Nota Fiscal",
	saida.NUMNOTA 		"Número da nota fiscal",
	saida.DTEMISSAOCTEREF  "Data de emissão da nota fiscal",
	saida.codcli 			"Código",
	cliente.cliente			"Nome",
	saida.VLTOTAL			"Valor da nota fiscal"
FROM
	PCNFSAID saida
	JOIN PCCLIENT cliente ON saida.codcli = cliente.codcli
WHERE
   saida.DTEMISSAOCTEREF BETWEEN TO_DATE('01/01/2011', 'DD/MM/YYYY') AND TO_DATE('01/04/2011', 'DD/MM/YYYY') 

UNION


SELECT 
    'Entrada' 				"Tipo de Nota Fiscal",
	entrada.NUMNOTA 		"Número da nota fiscal",
	entrada.DTEMISSAO 		"Data de emissão da nota fiscal",
	entrada.CODFORNEC		"Código",
	forncedor.FORNECEDOR 	"Nome",
	entrada.VLTOTAL 			"Valor da nota fiscal"
FROM
	PCNFENT entrada
	JOIN PCFORNEC forncedor ON entrada.CODFORNEC = forncedor.CODFORNEC
 WHERE
   entrada.DTEMISSAO BETWEEN TO_DATE('01/01/2011', 'DD/MM/YYYY') AND TO_DATE('01/04/2011', 'DD/MM/YYYY') 
   