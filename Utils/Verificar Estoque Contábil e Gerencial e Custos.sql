/*Verificar Estoque Cont�bil e Gerencial e Custos*/
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       P.CODAUXILIAR,
       E.DTULTENT,
       E.QTEST,
       E.QTESTGER,
       /*E.QTFRENTELOJA,*/
       /*( E.QTESTGER - E.QTFRENTELOJA )AS QTDEPOSITO,*/
       E.QTRESERV,
       E.QTBLOQUEADA,
       E.QTINDENIZ,
       E.VALORULTENT,
       E.CUSTOULTENT,
       E.CUSTOFIN,
       E.CUSTOCONT,
       E.CUSTOREP
  FROM PCEST E,
       PCPRODUT P
 WHERE E.CODPROD = P.CODPROD
   AND E.CODPROD IN (801268)
   /*AND E.CODFILIAL IN (
  3
)*/
   /*AND P.CODPRODMASTER = 803082*/
 ORDER BY E.CODFILIAL;
/
SELECT *
  FROM PCLOGESTOQUE
 WHERE CODFILIAL = 1
   AND CODPROD = 799452
   AND DATA > TRUNC (SYSDATE) - 1
 ORDER BY DATA;
/
SELECT *
  FROM PCHISTEST
 WHERE CODFILIAL = 1
   AND CODPROD = 799452
   AND DATA > TRUNC (SYSDATE) - 2;