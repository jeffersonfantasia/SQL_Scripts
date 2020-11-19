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
           M.QTCONT * (M.PUNITCONT + NVL (M.VLFRETE, 0) + NVL (M.VLOUTROS, 0)) AS VALOR
      FROM PCMOV M
     INNER JOIN PCNFENT E ON M.NUMTRANSENT = E.NUMTRANSENT
      LEFT JOIN VIEW_JC_VENDEDOR V ON E.CODUSURDEVOL = V.CODUSUR
     WHERE M.CODFISCAL IN (
        1202, 1411, 2202, 2411
    )
       AND M.DTMOV >= TO_DATE ('01/01/2019', 'DD/MM/YYYY')
       AND M.DTCANCEL IS NULL
)
 GROUP BY DTMOV,
          CODGERENTE,
          GERENTE;