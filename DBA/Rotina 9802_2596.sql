---VERIFICAR SE REALMENTE PRECISAMOS ALTERAR O NUMPED PARA PROXNUMPED +1
SELECT ROWID, PROXNUMPED FROM PCUSUARI U WHERE CODUSUR = 46;

--VERIFICAR ITENS QUE NAO FORAM PROCESSADOS PARA O NUMPED ATUAL
SELECT * FROM PCPEDIFV WHERE NUMPEDRCA = 4600000093;

----LEVAR OS ITENS QUE N�O FORAM PROCESSADOS PARA O PR�XIMO NUMPED
UPDATE PCPEDIFV SET NUMPEDRCA = 4600000094 WHERE NUMPEDRCA = 4600000093 AND (QT_FATURADA IS NULL OR QT_FATURADA = 0);

--VERIFICAR SE O NOVO NUMERO DE PEDIDO POSSUI OS ITENS INSERIDOS
SELECT * FROM PCPEDIFV WHERE NUMPEDRCA = 4600000094;

--GERAR NOVA LINHA COM AS INFORMA��ES, ALTERANDO O CAMPO IMPORTADO PARA 1, ASSIM PODEREMOS REPROCESSAR
--COPIAR CODUSUR, CDGCLI, DTABERTURAPEDPALM, DTFECHAMENTOPEDPALM, DTENTREGA, CODFILIAL, CODFILIALNF, CODFILIALRETIRA, 
--FRETE, CODCOB, CODPLPAG, CONVVENDA, OBS1, FRETEDESPACHO, ORIGEMPED, CODCLI
--NOVAS INFORMA��ES: IMPORTADO, NUMPEDRCA, NUMPED
SELECT ROWID, V.* FROM PCPEDCFV V WHERE NUMPEDRCA IN (4600000093, 4600000094);


SELECT * FROM PCTRANSFDEP;

SELECT * FROM PCPEDIFV WHERE CODUSUR = 39 AND QT_FATURADA IS NULL;

--ALTERAR O CAMPO PARA O PR�XIMO N�MERO DE PEDIDO--��
SELECT PROXNUMPED FROM PCUSUARI WHERE CODUSUR = 39 FOR UPDATE;

UPDATE PCPEDIFV ��
   SET NUMPEDRCA = 39000007
 WHERE NUMPEDRCA = 39000004
  AND QT_FATURADA IS NULL;

--GERAR NOVA LINHA COM AS INFORMA��ES
SELECT * FROM PCPEDCFV WHERE NUMPEDRCA = 39000007 FOR UPDATE;

UPDATE PCPEDCFV ��
   SET DTABERTURAPEDPALM = TRUNC(SYSDATE)
WHERE NUMPEDRCA = 39000007;

UPDATE PCPEDIFV ��
   SET DTABERTURAPEDPALM = TRUNC(SYSDATE)
 WHERE NUMPEDRCA = 39000007;

SELECT * FROM PCLOGFV WHERE NUMPEDRCA = 39000007;

  SELECT PCPEDIFV.*
    FROM PCPEDIFV,
         PCPEDCFV
   WHERE PCPEDIFV.NUMPEDRCA = PCPEDCFV.NUMPEDRCA
     AND PCPEDIFV.CGCCLI = PCPEDCFV.CGCCLI
     AND PCPEDIFV.CODUSUR = PCPEDCFV.CODUSUR
     AND PCPEDIFV.DTABERTURAPEDPALM = PCPEDCFV.DTABERTURAPEDPALM
     AND PCPEDCFV.NUMPEDRCA = 39000007
ORDER BY PCPEDIFV.NUMSEQ;

SELECT *
  FROM PCTRANSFDEP
 WHERE PCTRANSFDEP.DTTRANSF = TRUNC(SYSDATE) - 1
   FOR UPDATE;

--- ROTINA 9802----
SELECT 0 SELECIONADO,
       PCNFSAID.NUMCAR,
       PCTRANSF.CODFILIALORIGEM,
       PCTRANSF.CODFILIALDESTINO,
       COUNT(DISTINCT PCNFSAID.NUMNOTA) QTDENF
  FROM PCTRANSFDEP PCTRANSF, PCNFSAID
 WHERE PCTRANSF.CODFILIALORIGEM = 2
   AND PCTRANSF.CODFILIALDESTINO = 6
   AND PCNFSAID.NUMTRANSVENDA = PCTRANSF.NUMTRANSVENDA(+)
   AND PCTRANSF.DTTRANSF BETWEEN TRUNC(SYSDATE) - 1 AND TRUNC(SYSDATE) - 1
   AND (((PCNFSAID.SITUACAONFE = 100 AND PCNFSAID.CHAVENFE IS NOT NULL)) OR
       (PCNFSAID.SERIE IN ('CF', 'CP', 'OS')))
   AND PCTRANSF.NUMTRANSTRANSFSAIDA IS NULL
   AND PCTRANSF.NUMTRANSTRANSFENT IS NULL
 GROUP BY PCTRANSF.CODFILIALORIGEM,
          PCTRANSF.CODFILIALDESTINO,
          PCNFSAID.NUMCAR
 ORDER BY PCTRANSF.CODFILIALORIGEM, PCTRANSF.CODFILIALDESTINO;