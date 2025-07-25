-- Exercício 7
-- Montar pesquisa com as seguintes informações:
--  Código da praça do pedido de venda
--  Nome da praça
--  Número do pedido de venda
--  Código do cliente
--  Nome do cliente
--  Código de cobrança do pedido
--  Descrição da cobrança
--  Código do plano de pagamento
--  Descrição do plano de pagamento
--  Prazo médio do plano de pagamento.
-- Observações:
--  Tabelas utilizadas (PCPEDC / PCPRACA / PCCLIENT / PCCOB / PCPLPAG )
--  O cliente não precisa necessariamente estar cadastrado
--  Apenas do supervisor 1
--  Apenas dados da filial 1
--  Período de 01/01/2006 a 30/04/2006
--  Apenas vendas da cobrança 237

SELECT
    ped.codpraca "Código da praça do pedido de venda", 
    pcp.praca "Nome da praça", 
    ped.numped "Número do pedido de venda", 
    ped.codcli "Código do cliente", 
    cliente.cliente "Nome do cliente", 
    ped.codcob "Código de cobrança do pedido", 
    cobranca.cobranca "Descrição da cobrança", 
    ped.codplpag "Código do plano de pagamento", 
    parcelaPag.descricao "Descrição do plano de pagamento",
    
    (
        NVL(parcelaPag.PRAZO1, 0) +
        NVL(parcelaPag.PRAZO2, 0) +
        NVL(parcelaPag.PRAZO3, 0) +
        NVL(parcelaPag.PRAZO4, 0) +
        NVL(parcelaPag.PRAZO5, 0) +
        NVL(parcelaPag.PRAZO6, 0) +
        NVL(parcelaPag.PRAZO7, 0) +
        NVL(parcelaPag.PRAZO8, 0) +
        NVL(parcelaPag.PRAZO9, 0) +
        NVL(parcelaPag.PRAZO10, 0) +
        NVL(parcelaPag.PRAZO11, 0) +
        NVL(parcelaPag.PRAZO12, 0)
    ) /
    NULLIF(
        (CASE WHEN parcelaPag.PRAZO1 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO2 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO3 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO4 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO5 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO6 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO7 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO8 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO9 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO10 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO11 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN parcelaPag.PRAZO12 IS NOT NULL THEN 1 ELSE 0 END),
        0
    ) AS "Prazo médio do plano de pagamento"

FROM PCPEDC ped
LEFT JOIN PCCLIENT cliente ON ped.codcli = cliente.codcli
JOIN PCPRACA pcp ON ped.codpraca = pcp.codpraca
JOIN PCCOB cobranca ON ped.codcob = cobranca.codcob
JOIN PCPLPAG parcelaPag ON ped.codplpag = parcelaPag.codplpag 
WHERE
    ped.dtcancel IS NULL                     
    AND ped.CODSUPERVISOR = 1                    
    AND ped.codfilial = 1                   
--    AND ped.codcob = '237'
--   AND ped.data BETWEEN TO_DATE('01/01/2006', 'DD/MM/YYYY') AND TO_DATE('30/04/2006', 'DD/MM/YYYY');