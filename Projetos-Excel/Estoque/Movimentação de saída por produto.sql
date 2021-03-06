SELECT M.DTMOV,
       M.CODPROD,
       SUM (M.QTCONT) AS QT_TOTAL
  FROM PCMOV M
  LEFT JOIN VIEW_JC_VENDEDOR V ON M.CODUSUR = V.CODUSUR
 WHERE M.CODFISCAL IN (
    5102, 5109, 5119, 5120, 5403, 5405, 6102, 6108, 6403, 6119, 6120
)
   AND V.CODGERENTE IN (
    1, 8, 9, 10
)
   AND M.DTCANCEL IS NULL
 GROUP BY M.DTMOV,
          M.CODPROD;
/