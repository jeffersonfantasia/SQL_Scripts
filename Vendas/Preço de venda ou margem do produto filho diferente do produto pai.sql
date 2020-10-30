SELECT *
  FROM (
    SELECT T.NUMREGIAO,
           (
               SELECT CODPROD
                 FROM PCPRODUT
                WHERE P.CODPRODMASTER = CODPROD
           ) COD_PAI,
           (
               SELECT CODFAB
                 FROM PCPRODUT
                WHERE P.CODPRODMASTER = CODPROD
           ) FAB_PAI,
           (
               SELECT DESCRICAO
                 FROM PCPRODUT
                WHERE P.CODPRODMASTER = CODPROD
           ) PRODUTO_PAI,
           (
               SELECT ROUND (PVENDA, 2)
                 FROM PCTABPR
                WHERE CODPROD = P.CODPRODMASTER
                  AND NUMREGIAO = T.NUMREGIAO
           ) PVENDA_PAI,
           (
               SELECT MARGEM
                 FROM PCTABPR
                WHERE CODPROD = P.CODPRODMASTER
                  AND NUMREGIAO = T.NUMREGIAO
           ) MARGEM_PAI,
           P.CODPROD COD_FILHO,
           P.CODFAB FAB_FILHO,
           P.DESCRICAO PRODUTO_FILHO,
           ROUND (T.PVENDA, 2) PVENDA_FILHO,
           T.MARGEM
      FROM PCPRODUT P,
           PCTABPR T
     WHERE T.NUMREGIAO IN (
        102, 100
    )
       AND T.CODPROD = P.CODPROD
       AND P.DTEXCLUSAO IS NULL
       AND P.CODPRODMASTER IS NOT NULL
)
 WHERE ((PVENDA_PAI <> PVENDA_FILHO
    OR (PVENDA_FILHO IS NULL
   AND PVENDA_PAI IS NOT NULL))
    OR MARGEM_PAI <> MARGEM)
 ORDER BY COD_PAI,
          COD_FILHO,
          NUMREGIAO;
/
SELECT ROWID,
       T.NUMREGIAO,
       T.CODPROD,
       T.MARGEM
  FROM PCTABPR T
 WHERE T.NUMREGIAO IN (
    3, 4
)
   AND T.CODPROD = 804180;
/