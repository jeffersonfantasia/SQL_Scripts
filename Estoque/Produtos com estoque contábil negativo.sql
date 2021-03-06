SELECT TRUNC (SYSDATE) AS DATA,
       PCEST.CODFILIAL FILIAL,
       PCDEPTO.CODEPTO || '-' || PCDEPTO.DESCRICAO DEPARTAMENTO,
       PCPRODUT.CODPROD || '-' || PCPRODUT.DESCRICAO PRODUTO,
       ROUND (PCEST.CUSTOCONT, 0) CUSTOCONT,
       ROUND (PCEST.CUSTOFIN, 0) CUSTOFIN,
       ROUND (PCEST.CUSTOULTENT, 0) CUSTOULTENT,
       ROUND (PCEST.VALORULTENT, 0) VALORULTENT,
       PCEST.QTEST QTIDEAL,
       PCEST.QTESTGER QTGERENCIAL,
       ROUND (SUM (PCEST.QTESTGER * CUSTOFIN), 2) TOTAL_GER,
       ROUND (SUM (PCEST.QTEST * CUSTOCONT), 2) TOTAL_CONT
  FROM PCEST,
       PCPRODUT,
       PCDEPTO
 WHERE PCPRODUT.CODPROD = PCEST.CODPROD
      /*AND PCEST.CUSTOCONT>0*/
   AND NVL (PCPRODUT.TIPOMERC, 'L') <> 'CB'
   AND PCEST.QTEST < 0
   AND '[HISTORICO]' = 'N'
   AND PCPRODUT.CODEPTO = PCDEPTO.CODEPTO
   AND ((PCPRODUT.OBS2 NOT IN (
    'FL'
))
    OR (PCPRODUT.OBS2 IS NULL))
   AND ((PCPRODUT.OBS NOT IN (
    'PV'
))
    OR (PCPRODUT.OBS IS NULL))
   AND ((PCPRODUT.REVENDA = 'S')
    OR (PCPRODUT.REVENDA IS NULL))
   AND PCDEPTO.TIPOMERC = 'RT'
AND (( PCEST.CODFILIAL IN ([ FILIAL ])) OR ('99' IN ([ FILIAL ])))
   AND ((PCEST.CODFILIAL NOT IN ([ EXFILIAL ])) OR ('99' IN ([ EXFILIAL ])))
 GROUP BY TRUNC(SYSDATE),
          PCEST.CODFILIAL,
          PCDEPTO.CODEPTO || '-' || PCDEPTO.DESCRICAO,
          PCPRODUT.CODPROD || '-' || PCPRODUT.DESCRICAO,
          PCEST.CUSTOCONT,
          PCEST.CUSTOFIN,
          PCEST.CUSTOULTENT,
          PCEST.VALORULTENT,
          PCEST.QTEST,
          PCEST.QTESTGER
UNION ALL
SELECT TRUNC(PCHISTEST.DATA) DATA,
       PCHISTEST.CODFILIAL FILIAL,
       PCDEPTO.CODEPTO || '-' || PCDEPTO.DESCRICAO DEPARTAMENTO,
       PCPRODUT.CODPROD || '-' || PCPRODUT.DESCRICAO PRODUTO,
       ROUND(PCHISTEST.CUSTOCONT, 0) CUSTOCONT,
       ROUND(PCHISTEST.CUSTOFIN, 0) CUSTOFIN,
       ROUND(PCHISTEST.CUSTOULTENT, 0) CUSTOULTENT,
       ROUND(PCHISTEST.VALORULTENT, 0) VALORULTENT,
       PCHISTEST.QTEST QTIDEAL,
       PCHISTEST.QTESTGER QTGERENCIAL,
       ROUND(SUM(PCEST.QTESTGER * PCHISTEST.CUSTOFIN), 2) TOTAL_GER,
       ROUND(SUM(PCEST.QTEST * PCHISTEST.CUSTOCONT), 2) TOTAL_CONT
  FROM PCEST, PCPRODUT, PCDEPTO, PCHISTEST
 WHERE PCPRODUT.CODPROD = PCEST.CODPROD
      --AND PCHISTEST.CUSTOCONT>0
   AND NVL(PCPRODUT.TIPOMERC, 'L') <> 'CB'
   AND trunc(PCHISTEST.QTEST, 0) < 0
   AND PCPRODUT.DTEXCLUSAO IS NULL
   AND PCPRODUT.CODEPTO = PCDEPTO.CODEPTO
   AND ((PCPRODUT.OBS2 NOT IN ('FL')) OR (PCPRODUT.OBS2 IS NULL))
   AND ((PCPRODUT.OBS NOT IN ('PV')) OR (PCPRODUT.OBS IS NULL))
   AND ((PCPRODUT.REVENDA = 'S') OR (PCPRODUT.REVENDA IS NULL))
   AND PCDEPTO.TIPOMERC = 'RT'
   AND PCPRODUT.CODPROD = PCHISTEST.CODPROD
   AND PCEST.CODFILIAL = PCHISTEST.CODFILIAL
   AND '[HISTORICO]' = 'S'
   AND PCHISTEST.DATA = TO_DATE('[DATAESTOQUE]', 'DD/MM/YYYY')
   AND ((PCHISTEST.CODFILIAL IN ([ FILIAL ])) OR ('99' IN ([ FILIAL ])))
   AND ((PCHISTEST.CODFILIAL NOT IN ([ EXFILIAL ])) OR
       ('99' IN ([EXFILIAL])))
 GROUP BY TRUNC (PCHISTEST.DATA),
          PCHISTEST.CODFILIAL,
          PCDEPTO.CODEPTO || '-' || PCDEPTO.DESCRICAO,
          PCPRODUT.CODPROD || '-' || PCPRODUT.DESCRICAO,
          PCHISTEST.CUSTOCONT,
          PCHISTEST.CUSTOFIN,
          PCHISTEST.CUSTOULTENT,
          PCHISTEST.VALORULTENT,
          PCHISTEST.QTEST,
          PCHISTEST.QTESTGER
/