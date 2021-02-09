SELECT DTMOV,
       CODFILIAL,
       CODCLI,
       CLIENTE,
       UF,
       NUMNOTA,
       CODUSUR,
       CODFORNECFRETE,
       FORNECEDOR,
       'ED' AS TIPO,
       SUM (VALOR) AS VALOR
  FROM (
    SELECT M.DTMOV,
           E.CODFILIAL,
           E.CODFORNEC AS CODCLI,
           C.CLIENTE AS CLIENTE,
           E.UF,
           E.NUMNOTA,
           E.CODUSURDEVOL AS CODUSUR,
           E.CODFORNECFRETE,
           F.FORNECEDOR,
           (
               CASE
                   WHEN M.CODFISCAL IN (
                       1913, 2913, 1949, 2949
                   ) THEN 0
                   ELSE ROUND (M.QTCONT * (M.PUNITCONT + NVL (M.VLFRETE, 0) + NVL (M.VLOUTROS, 0)), 2)
               END
           ) AS VALOR
      FROM PCMOV M
     INNER JOIN PCNFENT E ON M.NUMTRANSENT = E.NUMTRANSENT
      LEFT JOIN VIEW_JC_VENDEDOR V ON E.CODUSURDEVOL = V.CODUSUR
      LEFT JOIN PCCLIENT C ON E.CODFORNEC = C.CODCLI
      LEFT JOIN PCFORNEC F ON E.CODFORNECFRETE = F.CODFORNEC
     WHERE M.CODFISCAL IN (
        1202, 1411, 2202, 2411, 1913, 2913, 1949, 2949
    )
       AND V.CODGERENTE IN (
        1, 2, 5, 8, 9, 10
    )
       AND M.DTMOV >= TO_DATE ('01/01/2015', 'DD/MM/YYYY')
       AND M.DTCANCEL IS NULL
)
 GROUP BY DTMOV,
          CODFILIAL,
          CODCLI,
          CLIENTE,
          UF,
          NUMNOTA,
          CODUSUR,
          CODFORNECFRETE,
          FORNECEDOR