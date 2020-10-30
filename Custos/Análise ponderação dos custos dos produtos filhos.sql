/*--------------FILIAL 1--------------------------*/
SELECT *
  FROM (
    SELECT M.CODFILIAL,
           M.MEDIA_PONDERADA,
           M.DTULTENT_MAX,
           (
               SELECT ROUND (AVG (NVL (T.VALORULTENT, 0)), 6)
                 FROM PCEST T,
                      PCPRODUT R
                WHERE T.CODPROD = R.CODPROD
                  AND R.CODPRODMASTER <> T.CODPROD
                  AND R.CODPRODMASTER = M.CODPRODMASTER
                  AND T.CODFILIAL = M.CODFILIAL
                  AND T.QTESTGER > 0
                  AND T.DTULTENT = M.DTULTENT_MAX
           ) VLULTENT_MAX,
           M.CUSTOULTENT_POND,
           M.CUSTOCONT_POND,
           M.CUSTOREAL_POND,
           M.CUSTOFIN_POND,
           M.CUSTOREP_POND,
           M.CODPRODMASTER,
           M.COD_FILHO,
           M.PRODUTO_FILHO,
           M.DTULTENT,
           M.QTESTGER,
           M.VALORULTENT,
           M.CUSTOULTENT,
           M.CUSTOCONT,
           M.CUSTOREAL,
           M.CUSTOFIN,
           M.CUSTOREP
      FROM (
        SELECT E.CODFILIAL,
               'MEDIA PONDERADA FILHOS' MEDIA_PONDERADA,
               (
                   SELECT DISTINCT (MAX (T.DTULTENT))
                     FROM PCEST T,
                          PCPRODUT R
                    WHERE T.CODPROD = R.CODPROD
                      AND R.CODPRODMASTER <> T.CODPROD
                      AND R.CODPRODMASTER = P.CODPRODMASTER
                      AND T.QTESTGER > 0
                      AND T.CODFILIAL = E.CODFILIAL
               ) DTULTENT_MAX,
               (
                   SELECT ROUND ((SUM (NVL (T.QTESTGER, 0) * NVL (T.CUSTOULTENT, 0)) / SUM (NVL (T.QTESTGER, 0))), 6)
                     FROM PCEST T,
                          PCPRODUT R
                    WHERE T.CODPROD = R.CODPROD
                      AND R.CODPRODMASTER <> T.CODPROD
                      AND R.CODPRODMASTER = P.CODPRODMASTER
                      AND T.QTESTGER > 0
                      AND T.CODFILIAL = E.CODFILIAL
               ) CUSTOULTENT_POND,
               (
                   SELECT ROUND ((SUM (NVL (T.QTESTGER, 0) * NVL (T.CUSTOCONT, 0)) / SUM (NVL (T.QTESTGER, 0))), 6)
                     FROM PCEST T,
                          PCPRODUT R
                    WHERE T.CODPROD = R.CODPROD
                      AND R.CODPRODMASTER <> T.CODPROD
                      AND R.CODPRODMASTER = P.CODPRODMASTER
                      AND T.QTESTGER > 0
                      AND T.CODFILIAL = E.CODFILIAL
               ) CUSTOCONT_POND,
               (
                   SELECT ROUND ((SUM (NVL (T.QTESTGER, 0) * NVL (T.CUSTOREAL, 0)) / SUM (NVL (T.QTESTGER, 0))), 6)
                     FROM PCEST T,
                          PCPRODUT R
                    WHERE T.CODPROD = R.CODPROD
                      AND R.CODPRODMASTER <> T.CODPROD
                      AND R.CODPRODMASTER = P.CODPRODMASTER
                      AND T.QTESTGER > 0
                      AND T.CODFILIAL = E.CODFILIAL
               ) CUSTOREAL_POND,
               (
                   SELECT ROUND ((SUM (NVL (T.QTESTGER, 0) * NVL (T.CUSTOFIN, 0)) / SUM (NVL (T.QTESTGER, 0))), 6)
                     FROM PCEST T,
                          PCPRODUT R
                    WHERE T.CODPROD = R.CODPROD
                      AND R.CODPRODMASTER <> T.CODPROD
                      AND R.CODPRODMASTER = P.CODPRODMASTER
                      AND T.QTESTGER > 0
                      AND T.CODFILIAL = E.CODFILIAL
               ) CUSTOFIN_POND,
               (
                   SELECT ROUND ((SUM (NVL (T.QTESTGER, 0) * NVL (T.CUSTOREP, 0)) / SUM (NVL (T.QTESTGER, 0))), 6)
                     FROM PCEST T,
                          PCPRODUT R
                    WHERE T.CODPROD = R.CODPROD
                      AND R.CODPRODMASTER <> T.CODPROD
                      AND R.CODPRODMASTER = P.CODPRODMASTER
                      AND T.QTESTGER > 0
                      AND T.CODFILIAL = E.CODFILIAL
               ) CUSTOREP_POND,
               P.CODPRODMASTER,
               E.CODPROD COD_FILHO,
               P.DESCRICAO PRODUTO_FILHO,
               E.DTULTENT,
               E.QTESTGER,
               E.VALORULTENT,
               E.CUSTOULTENT,
               E.CUSTOCONT,
               E.CUSTOREAL,
               E.CUSTOFIN,
               E.CUSTOREP
          FROM PCPRODUT P,
               PCEST E
         WHERE E.CODPROD = P.CODPROD
           AND P.CODPRODMASTER IS NOT NULL
           AND P.CODPRODMASTER <> P.CODPROD
           AND E.QTESTGER > 0
           AND E.CODFILIAL = 1
         ORDER BY P.CODPRODMASTER,
                  E.CODPROD,
                  E.CODFILIAL
    ) M
)
 WHERE (VLULTENT_MAX <> VALORULTENT
    OR CUSTOULTENT_POND <> CUSTOULTENT
    OR CUSTOCONT_POND <> CUSTOCONT
    OR CUSTOREAL_POND <> CUSTOREAL
    OR CUSTOFIN_POND <> CUSTOFIN
    OR CUSTOREP_POND <> CUSTOREP);
/