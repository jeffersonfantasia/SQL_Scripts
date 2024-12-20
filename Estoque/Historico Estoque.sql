WITH HIST_ESTOQUE AS
 (SELECT H.CODFILIAL,
         H.DATA,
         H.CODPROD,
         H.CUSTOCONT,
         NVL(H.QTEST, 0) QTEST,
         ROUND(ROUND(H.QTEST, 3) * ROUND(H.CUSTOCONT, 3), 2) VLESTOQUE,
         H.TIPOMERC,
         H.TIPOMERCDEPTO
    FROM PCHISTEST H
   WHERE 0 = 0
     AND NVL(H.TIPOMERCDEPTO, 'X') <> 'IM'
     AND NVL(H.TIPOMERCDEPTO, 'X') <> 'CI'
     AND NVL(H.TIPOMERC, 'X') NOT IN ('MC', 'ME', 'PB')
     AND H.DATA = TO_DATE('30/09/2024', 'DD/MM/YYYY')
     AND ROUND(H.QTEST, 3) > 0
     AND ROUND(H.CUSTOCONT, 3) > 0)

/*SELECT CODFILIAL,
       CODPROD,
       QTEST,
       CUSTOCONT,
       VLESTOQUE
  FROM HIST_ESTOQUE*/

SELECT CODFILIAL,
       SUM(VLESTOQUE) VLESTOQUE
  FROM HIST_ESTOQUE
 GROUP BY CODFILIAL
 ORDER BY TO_NUMBER(CODFILIAL)
