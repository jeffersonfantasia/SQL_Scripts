WITH ANALITICO AS (
    SELECT M.DTMOV,
           M.CODFILIAL,
           A.MARCA,
           M.CODPROD,
           P.DESCRICAO,
           (
               CASE
                   WHEN M.CODOPER = 'EI' THEN M.QTCONT
                   ELSE (M.QTCONT * - 1)
               END
           ) QT,
           M.CUSTOCONT,
           M.STATUS,
           M.CODOPER
      FROM PCMOV M
      LEFT JOIN PCPRODUT P ON M.CODPROD = P.CODPROD
      LEFT JOIN PCMARCA A ON P.CODMARCA = A.CODMARCA
     WHERE M.CODOPER IN (
        'EI', 'SI'
    )
       AND M.DTMOV > TRUNC (SYSDATE) - 20
       AND M.DTCANCEL IS NULL
       AND M.STATUS = 'A'
       AND M.CODFILIAL IN (
        1, 2, 7
    )
     ORDER BY M.CODPROD,
              M.CODFILIAL,
              M.CODOPER
), SINTETICO AS (
    SELECT A.MARCA,
           A.CODPROD,
           A.DESCRICAO,
           SUM (A.QT) AS QT,
           ROUND (AVG (A.CUSTOCONT), 2) AS CUSTOCONT,
           A.STATUS
      FROM ANALITICO A
     GROUP BY A.MARCA,
              A.CODPROD,
              A.DESCRICAO,
              A.STATUS
     ORDER BY A.CODPROD
)
SELECT *
  FROM (
    SELECT A.DTMOV,
           A.CODFILIAL,
           A.MARCA,
           A.CODPROD,
           A.DESCRICAO,
           A.QT,
           A.CUSTOCONT,
           A.STATUS,
           A.CODOPER
      FROM ANALITICO A
    UNION ALL
    SELECT TO_DATE ('01/01/2020', 'DD/MM/YYYY') AS DTMOV,
           'SOMA' AS CODFILIAL,
           S.MARCA,
           S.CODPROD,
           S.DESCRICAO,
           S.QT,
           S.CUSTOCONT,
           S.STATUS,
           (
               CASE
                   WHEN S.QT < 0 THEN 'PERDA'
                   WHEN S.QT > 0 THEN 'GANHO'
                   ELSE 'IGUAL'
               END
           ) AS CODOPER
      FROM SINTETICO S
)
 ORDER BY CODPROD,
          DESCRICAO,
          DTMOV DESC
/