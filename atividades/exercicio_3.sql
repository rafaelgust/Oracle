-- Exercício 3
-- Montar pesquisa com as seguintes informações:
--  Data de movimentação do produto
--  Número da N.F.
--  Código do cliente
--  Nome do cliente
--  Código do produto
--  Descrição do produto
--  Código de operação da movimentação
--  Quantidade movimentada
--  Preço unitário do produto
--  Valor total da movimentação (quantidade movimentada * preço unitário do
-- produto)
-- Observações:
--  Tabelas utilizadas (PCMOV / PCCLIENT / PCPRODUT)
--  Período solicitado: de 01/08/2005 a 31/08/2005
--  Código de operação = ‘S’ 

DESC PCMOV

SELECT  
    mov.dtmov AS "Data de movimenta��o do produto",
    mov.numnota AS "N�mero da N.F", 
    mov.codcli AS "C�digo do cliente",
    client.cliente AS "Nome do cliente", 
    mov.codprod AS "C�digo do produto",
    product.descricao AS "Descri��o do produto", 
    mov.CODOPER AS "C�digo de opera��o da movimenta��o", 
    mov.qt AS "Quantidade movimentada", 
    mov.PUNIT AS "Pre�o unit�rio do produto",
    NVL(mov.PUNIT, 0) * NVL(mov.qt, 0) AS "Valor total da movimenta��o"
FROM PCMOV mov 
    JOIN PCCLIENT client ON mov.codcli = client.codcli
    JOIN PCPRODUT product ON mov.codprod = product.codprod
WHERE mov.CODOPER = 'S' AND
      mov.dtmov BETWEEN TO_DATE('01/10/2010', 'DD/MM/YYYY') AND TO_DATE('20/10/2010', 'DD/MM/YYYY')
ORDER BY mov.dtmov;

