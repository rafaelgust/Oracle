-- Exerc√≠cio 2
-- Montar pesquisa com as seguintes informa√ß√µes:
--  Esp√©cie da N.F.
--  N√∫mero da N.F.
--  Data de sa√≠da da N.F.
--  Valor Total da N.F.
--  C√≥digo do cliente
--  Nome do cliente
--  C√≥digo do RCA
--  Nome do RCA
--  C√≥digo do Supervisor
--  Nome do Supervisor
-- Observa√ß√µes:
--  Tabelas utilizadas (PCNFSAID / PCCLIENT / PCUSUARI / PCSUPERV)
--  Per√≠odo solicitado: de 01/07/2005 a 31/07/2005

DESC PCNFSAID;
DESC PCCLIENT;
DESC PCUSUARI;
DESC PCSUPERV;

SELECT nf.ESPECIE "EspÈcie da N.F", nf.numnota "N˙mero da N.F", nf.dtsaida "Data de saÌda da N.F", nf.vltotal "Valor Total da N.F",
       client.codcli "CÛdigo do Cliente", client.cliente "Nome do Cliente", 
       rca.codusur "CÛdigo do RCA", rca.nome "Nome do RCA",
       sup.CODSUPERVISOR "CÛdigo do Supervisor", sup.nome "Nome do Supervisor"
FROM PCNFSAID nf 
        JOIN PCCLIENT client ON nf.codcli = client.codcli
        JOIN PCUSUARI rca ON nf.codusur = rca.codusur
        JOIN PCSUPERV sup ON nf.CODSUPERVISOR = sup.CODSUPERVISOR
WHERE nf.dtsaida BETWEEN '01/10/2010' AND '31/10/2010' --- N√O TEM REGISTROS DE 01/07/2005 a 31/07/2005
ORDER BY nf.dtsaida ASC;



