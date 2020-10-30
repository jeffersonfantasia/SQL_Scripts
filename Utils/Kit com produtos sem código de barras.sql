/*KIT COM PRODUTOS SEM CODIGO DE BARRAS--*/
WITH PRODUTO_ACABADO AS (
  SELECT CODPROD,
         DESCRICAO
    FROM PCPRODUT
)
SELECT F.CODPRODACAB,
       A.DESCRICAO AS PRODUTO_KIT,
       F.CODPRODMP,
       P.DESCRICAO AS PRODUTO_MP,
       F.QTPRODMP,
       F.CODAUXILIARMP,
       P.CODAUXILIAR
  FROM PCFORMPROD F
  LEFT JOIN PCPRODUT P ON F.CODPRODMP = P.CODPROD
  LEFT JOIN PRODUTO_ACABADO A ON F.CODPRODACAB = A.CODPROD
 WHERE F.CODAUXILIARMP IS NULL
 ORDER BY F.CODPRODACAB,
          F.CODPRODMP;