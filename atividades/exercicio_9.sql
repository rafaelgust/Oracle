-- Exercício 9
-- Montar pesquisa com as seguintes informações:
--  Código do cliente
--  Nome do cliente
--  Valor acumulado de vendas
--  Valor acumulado de devoluções
-- Observações:
--  Script deve utilizar sub-select no from
--  Dados de vendas e devoluções não são obrigatórios
--  Tabelas utilizadas
-- ● Pesquisa principal: PCCLIENT
-- ● Pesquisa de vendas: PCNFSAID
-- ● Pesquisa de devoluções: PCNFENT
--  Período de vendas e devoluções: 01/01/2006 a 30/04/2006

SELECT * FROM PCNFENT

----- saber o valor que foi vendido para o cliente e o valor das devoluções do mesmo



SELECT 
	cli.codcli 				"Código do cliente",
	cli.cliente 			"Nome do cliente",
	NVL(v.venda, 0) 		"Total acumulado de vendas",
	NVL(v.devolucao,0) 		"Total acumulado de devoluções"
FROM PCCLIENT cli
	LEFT JOIN (
	    SELECT v.codcli, SUM(v.VLTOTAL) venda, SUM(d.VLTOTAL) devolucao
			FROM PCNFSAID v
				 LEFT JOIN PCNFENT d ON v.CODDEVOL = d.CODDEVOL
			WHERE 
			d.DTSAIDA BETWEEN TO_DATE('01/01/2010', 'DD/MM/YYYY') AND TO_DATE('01/02/2010', 'DD/MM/YYYY') AND
			d.DTEMISSAO BETWEEN TO_DATE('01/01/2010', 'DD/MM/YYYY') AND TO_DATE('01/02/2010', 'DD/MM/YYYY')
GROUP BY v.CODCLI
) v ON cli.codcli = v.codcli;