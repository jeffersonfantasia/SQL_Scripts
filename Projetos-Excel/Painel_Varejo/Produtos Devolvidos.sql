SELECT M.DTMOV,
       M.CODPROD,
       SUM (M.QTCONT) AS QTDEVOLVIDO
  FROM PCMOV M
  LEFT JOIN VIEW_JC_VENDEDOR V ON M.CODUSUR = V.CODUSUR
 WHERE M.CODFISCAL IN (
    1202, 1411, 2202, 2411
)
   AND V.CODGERENTE IN (
    3, 4
)
   AND M.DTCANCEL IS NULL
   AND M.DTMOV >= TO_DATE ('01/01/2018', 'DD/MM/YYYY')
 GROUP BY M.DTMOV,
          M.CODPROD;
/