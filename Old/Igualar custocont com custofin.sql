SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.CUSTOFIN,
       E.CUSTOCONT
  FROM PCEST E
  LEFT JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
 WHERE E.CODFILIAL IN (
  5, 6
)
   AND E.CUSTOFIN <> E.CUSTOCONT
   AND P.CODPRODMASTER IS NOT NULL
   AND P.TIPOMERC NOT IN (
  'CB'
)
 ORDER BY E.CODPROD;
/
SELECT COUNT (E.CODPROD)
  FROM PCEST E
  LEFT JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
 WHERE E.CODFILIAL IN (
  5, 6
)
   AND E.CUSTOFIN <> E.CUSTOCONT
   AND P.CODPRODMASTER IS NOT NULL
   AND P.TIPOMERC NOT IN (
  'CB'
)
 ORDER BY E.CODPROD;
/

/*UPDATE PCEST
   SET CUSTOCONT = CUSTOFIN
 WHERE CODFILIAL = 6
   AND CUSTOFIN <> CUSTOCONT;/*/
SELECT *
  FROM PCMOV M
 WHERE M.CODFILIAL IN (
  5, 6
)
   AND M.CODPROD IN (
  796236
)
   AND DTMOV >= TRUNC (SYSDATE) - 10;
/