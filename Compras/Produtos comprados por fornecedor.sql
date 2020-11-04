SELECT DISTINCT M.CODPROD,
                P.DESCRICAO,
                SUM (QT) QT_COMPRADO
  FROM PCMOV M,
       PCPRODUT P
 WHERE M.CODPROD = P.CODPROD
   AND M.CODOPER = 'E'
   AND M.DTMOV BETWEEN TO_DATE ('01/01/2018', 'DD/MM/YYYY') AND TO_DATE ('31/12/2018', 'DD/MM/YYYY')
   AND M.CODFILIAL IN (
    1, 2
)
   AND P.CODFORNEC = 6962
 GROUP BY M.CODPROD,
          P.DESCRICAO;
/
SELECT COUNT (DISTINCT M.CODPROD) CONTAGEM
  FROM PCMOV M,
       PCPRODUT P
 WHERE M.CODPROD = P.CODPROD
   AND M.CODOPER = 'E'
   AND M.DTMOV BETWEEN TO_DATE ('01/01/2018', 'DD/MM/YYYY') AND TO_DATE ('31/12/2018', 'DD/MM/YYYY')
   AND M.CODFILIAL IN (
    1, 2
)
   AND P.CODFORNEC = 6962;
/