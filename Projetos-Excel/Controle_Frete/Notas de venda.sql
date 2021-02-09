SELECT DTMOV,
       CODFILIAL,
       CODCLI,
       CLIENTE,
       UF,
       NUMNOTA,
       CODUSUR,
       CODFORNECFRETE,
       FORNECEDOR,
       'S' AS TIPO,
       SUM (VALOR) AS VALOR
  FROM (
    SELECT M.DTMOV,
           S.CODFILIAL,
           S.CODCLI,
           C.CLIENTE,
           S.UF,
           S.NUMNOTA,
           S.CODUSUR,
           S.CODFORNECFRETE,
           F.FORNECEDOR,
           (
               CASE
                   WHEN M.CODFISCAL IN (
                       5117, 5923, 6117, 6923
                   ) THEN 0
                   ELSE ROUND (M.QTCONT * (M.PUNITCONT + NVL (M.VLFRETE, 0) + NVL (M.VLOUTROS, 0)), 2)
               END
           ) AS VALOR
      FROM PCMOV M
     INNER JOIN PCNFSAID S ON M.NUMTRANSVENDA = S.NUMTRANSVENDA
      LEFT JOIN VIEW_JC_VENDEDOR V ON S.CODUSUR = V.CODUSUR
      LEFT JOIN PCFORNEC F ON S.CODFORNECFRETE = F.CODFORNEC
      LEFT JOIN PCCLIENT C ON S.CODCLI = C.CODCLI
     WHERE M.CODFISCAL IN (
        5102, 5109, 5117, 5119, 5922, 5923, 5120, 5403, 5405, 6102, 6108, 6403, 6117, 6119, 6120, 6922, 6923
    )
       AND V.CODGERENTE IN (
        1, 2, 5, 8, 9, 10
    )
       AND M.DTMOV >= TO_DATE ('01/01/2017', 'DD/MM/YYYY')
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