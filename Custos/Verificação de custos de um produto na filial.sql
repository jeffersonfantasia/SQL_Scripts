SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.VALORULTENT,
       E.CUSTOULTENT,
       E.CUSTOREAL,
       E.CUSTOFIN,
       E.CUSTOREP
  FROM PCEST E,
       PCPRODUT P
 WHERE E.CODPROD = P.CODPROD
   AND E.CODFILIAL = 1
   AND P.CODPRODMASTER = 803094;