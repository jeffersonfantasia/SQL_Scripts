SELECT DTMOV,
       CODGERENTE,
       GERENTE,
       SUM (VALOR) AS VALOR
  FROM (
    SELECT M.DTMOV,
           (
               CASE
                   WHEN V.CODSUPERVISOR IN (
                       12
                   ) THEN 12
                   ELSE V.CODGERENTE
               END
           ) AS CODGERENTE,
           (
               CASE
                   WHEN V.CODSUPERVISOR IN (
                       12
                   ) THEN 'B2B'
                   ELSE V.GERENTE
               END
           ) AS GERENTE,
           ROUND (M.QTCONT * (M.PUNITCONT + NVL (M.VLFRETE, 0) + NVL (M.VLOUTROS, 0)), 2) AS VALOR
      FROM PCMOV M
     INNER JOIN PCNFSAID S ON M.NUMTRANSVENDA = S.NUMTRANSVENDA
      LEFT JOIN VIEW_JC_VENDEDOR V ON S.CODUSUR = V.CODUSUR
     WHERE M.CODFISCAL IN (
        5102, 5109, 5403, 5405, 6102, 6108, 6403
    )
       AND M.DTMOV >= TO_DATE ('01/01/2019', 'DD/MM/YYYY')
)
 GROUP BY DTMOV,
          CODGERENTE,
          GERENTE;