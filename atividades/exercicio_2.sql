-- Exercício 2
-- Montar pesquisa com as seguintes informações:
--  Espécie da N.F.
--  Número da N.F.
--  Data de saída da N.F.
--  Valor Total da N.F.
--  Código do cliente
--  Nome do cliente
--  Código do RCA
--  Nome do RCA
--  Código do Supervisor
--  Nome do Supervisor
-- Observações:
--  Tabelas utilizadas (PCNFSAID / PCCLIENT / PCUSUARI / PCSUPERV)
--  Período solicitado: de 01/07/2005 a 31/07/2005

DESC PCNFSAID;
DESC PCCLIENT;
DESC PCUSUARI;
DESC PCSUPERV;

SELECT nf.ESPECIE "Esp�cie da N.F", nf.numnota "N�mero da N.F", nf.dtsaida "Data de sa�da da N.F", nf.vltotal "Valor Total da N.F",
       client.codcli "C�digo do Cliente", client.cliente "Nome do Cliente", 
       rca.codusur "C�digo do RCA", rca.nome "Nome do RCA",
       sup.CODSUPERVISOR "C�digo do Supervisor", sup.nome "Nome do Supervisor"
FROM PCNFSAID nf 
        JOIN PCCLIENT client ON nf.codcli = client.codcli
        JOIN PCUSUARI rca ON nf.codusur = rca.codusur
        JOIN PCSUPERV sup ON nf.CODSUPERVISOR = sup.CODSUPERVISOR
WHERE nf.dtsaida BETWEEN '01/10/2010' AND '31/10/2010' --- N�O TEM REGISTROS DE 01/07/2005 a 31/07/2005
ORDER BY nf.dtsaida ASC;



