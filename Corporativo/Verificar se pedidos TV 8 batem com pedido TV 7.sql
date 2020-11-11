WITH PEDIDOTV7 AS (
    SELECT NUMPED,
           CODPROD,
           NVL (SUM (QT), 0) AS QT_TV7
      FROM PCPEDI
     GROUP BY NUMPED,
              CODPROD
), PEDIDOTV8 AS (
    SELECT C.NUMPEDENTFUT,
           I.CODPROD,
           I.CODFILIALRETIRA AS FILIALRETIRA_TV8,
           NVL (SUM (I.QT), 0) AS QT_TV8
      FROM PCPEDI I
     INNER JOIN PCPEDC C ON I.NUMPED = C.NUMPED
     GROUP BY C.NUMPEDENTFUT,
              I.CODPROD,
              I.CODFILIALRETIRA
)
SELECT T.CODPROD,
       P.DESCRICAO,
       T.QT_TV7,
       V.QT_TV8,
       (T.QT_TV7 - V.QT_TV8) AS DIF,
       V.FILIALRETIRA_TV8
  FROM PEDIDOTV7 T
 INNER JOIN PEDIDOTV8 V ON T.NUMPED = V.NUMPEDENTFUT
   AND T.CODPROD = V.CODPROD
  LEFT JOIN PCPRODUT P ON T.CODPROD = P.CODPROD
 WHERE T.NUMPED = 14006230;