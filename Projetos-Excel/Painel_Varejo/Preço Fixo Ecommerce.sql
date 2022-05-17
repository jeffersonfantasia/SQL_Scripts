WITH MAIS_NOVO_PRECO_PROM AS (
    SELECT MAX (CODPRECOPROM) AS CODPRECOPROM,
           P.CODPROD
      FROM PCPRECOPROM P
     WHERE P.NUMREGIAO = 102
     GROUP BY P.CODPROD
)
SELECT P.CODPRECOPROM,
       P.CODPROD,
       P.PRECOFIXO
  FROM PCPRECOPROM P
 INNER JOIN MAIS_NOVO_PRECO_PROM M ON P.CODPRECOPROM = M.CODPRECOPROM
 INNER JOIN PCEST E ON P.CODPROD = E.CODPROD
 WHERE P.NUMREGIAO = 102
   AND TRUNC (SYSDATE) <= P.DTFIMVIGENCIA
   AND E.QTESTGER > 0
   AND E.CODFILIAL = 7;
/