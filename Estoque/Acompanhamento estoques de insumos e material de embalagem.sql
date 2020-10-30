WITH INSUMOS AS (
    SELECT E.CODFILIAL,
           E.CODPROD,
           P.DESCRICAO,
           (E.QTESTGER - E.QTBLOQUEADA - E.QTRESERV) AS QTDISPONIVEL,
           P.OBS2,
           P.DTEXCLUSAO
      FROM PCEST E,
           PCPRODUT P
     WHERE E.CODPROD = P.CODPROD
       AND P.CODEPTO = 97
       AND E.CODFILIAL = 2
     ORDER BY P.DESCRICAO
)
SELECT CODFILIAL,
       CODPROD,
       DESCRICAO,
       QTDISPONIVEL,
       OBS2,
       DTEXCLUSAO
  FROM (
    SELECT CODFILIAL,
           CODPROD,
           DESCRICAO,
           QTDISPONIVEL,
           OBS2,
           DTEXCLUSAO,
           (
               CASE
                   WHEN QTDISPONIVEL < 0 THEN 'S'
                   ELSE (
                       CASE
                           WHEN ((OBS2 IS NOT NULL
                               OR DTEXCLUSAO IS NOT NULL)
                              AND QTDISPONIVEL = 0) THEN 'N'
                           ELSE 'S'
                       END
                   )
               END
           ) AS VERIFICADOR
      FROM INSUMOS
)
 WHERE VERIFICADOR = 'S'
/