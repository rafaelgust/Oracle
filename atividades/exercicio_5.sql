--  Exercício 5
-- Montar pesquisa com as seguintes informações:
--  Código do cliente
--  Nome do cliente
--  CGC ou CPF do cliente (do jeito que estiver na tabela)
--  CGC ou CPF do cliente (sem máscara)
--  CGC ou CPF do cliente com máscara correta.
-- Observações:
--  Tabelas utilizadas (PCCLIENT)
--  Se for CGC (14 dígitos), colocar máscara ‘99.999.999/9999-99’
--  Se for CPF (11 dígitos), colocar máscara ‘999.999.999-99’
--  Se não for CGC nem CPF informar ‘TIPO INCORRETO’
--  Ordenado por código de cliente

SELECT  codcli "Cod Cliente", 
        cliente "Nome", 
        CGCENT "CGC Atual",
        REPLACE(REPLACE(REPLACE(REPLACE(CGCENT, '.', ''), '/', ''), '-', ''), ' ', '') "CGC Sem Mascara",
        CASE
            WHEN LENGTH(CGCENT) = 14 THEN
              SUBSTR(CGCENT, 1, 2) || '.' || 
              SUBSTR(CGCENT, 3, 3) || '.' || 
              SUBSTR(CGCENT, 4, 3) || '/' || 
              SUBSTR(CGCENT, 10, 4) || '-' ||
              SUBSTR(CGCENT, 11, 2)
             WHEN LENGTH(CGCENT) = 18 THEN
              CGCENT
            ELSE
              ''
          END AS "CGC Com Mascara"
FROM PCCLIENT
ORDER BY codcli;
--- CONSIDERANDO QUE J� EXISTE OS VALORES COM MASCARA E SEM MASCARA - 2 CASE UM PARA 14 CHAR E OUTRO PARA 18
