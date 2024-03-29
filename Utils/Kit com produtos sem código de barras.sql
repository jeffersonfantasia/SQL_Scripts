--KIT SEM CODIGO DE BARRA
WITH PRODUTO_ACABADO AS
 (SELECT CODPROD, DESCRICAO FROM PCPRODUT)
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
 WHERE (F.CODAUXILIARMP IS NULL OR F.CODAUXILIARMP <> P.CODAUXILIAR)
 ORDER BY F.CODPRODACAB, F.CODPRODMP;

--UPDATE--
MERGE INTO PCFORMPROD F
USING (
  WITH PRODUTO_ACABADO AS
   (SELECT CODPROD, DESCRICAO FROM PCPRODUT)
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
   WHERE (F.CODAUXILIARMP IS NULL OR F.CODAUXILIARMP <> P.CODAUXILIAR)) X ON (F.CODPRODACAB = X.CODPRODACAB AND F.CODPRODMP = X.CODPRODMP) WHEN MATCHED THEN
    UPDATE SET F.CODAUXILIARMP = X.CODAUXILIAR;
----------
