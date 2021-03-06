SELECT DTMOV,
       CODIGO,
       CODUSUR,
       SUM (VALOR) AS VALOR
  FROM (
    SELECT M.DTMOV,
           E.CODFORNEC AS CODIGO,
           E.CODUSURDEVOL AS CODUSUR,
           M.QTCONT * (M.PUNITCONT + NVL (M.VLFRETE, 0) + NVL (M.VLOUTROS, 0)) AS VALOR
      FROM PCMOV M
     INNER JOIN PCNFENT E ON M.NUMTRANSENT = E.NUMTRANSENT
      LEFT JOIN VIEW_JC_VENDEDOR V ON E.CODUSURDEVOL = V.CODUSUR
     WHERE M.CODFISCAL IN (
        1202, 1411, 2202, 2411
    )
       AND V.CODGERENTE IN (
        1, 8, 9, 10
    )
       AND M.DTMOV >= TO_DATE ('01/01/2017', 'DD/MM/YYYY')
       AND M.DTCANCEL IS NULL
)
 GROUP BY DTMOV,
          CODIGO,
          CODUSUR