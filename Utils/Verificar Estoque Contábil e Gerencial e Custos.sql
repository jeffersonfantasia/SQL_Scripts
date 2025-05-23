/*Verificar Estoque Cont�bil e Gerencial e Custos*/
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       P.CODAUXILIAR,
       E.DTULTENT,
       E.QTEST,
       E.QTESTGER,
       --E.QTFRENTELOJA,
       --( E.QTESTGER - E.QTFRENTELOJA )AS QTDEPOSITO,
       E.QTRESERV,
       E.QTBLOQUEADA,
       E.QTINDENIZ,
       E.VALORULTENT,
       E.CUSTOULTENT,
       E.CUSTOFIN,
       E.CUSTOREAL,
       E.CUSTOCONT,
       E.CUSTOREP, e.ROWID
  FROM PCEST E, PCPRODUT P
 WHERE E.CODPROD = P.CODPROD
   AND E.CODPROD IN (824628)
   AND E.CODFILIAL IN (7,10)
--AND P.CODPRODMASTER = 803082
 ORDER BY E.CODPROD, TO_NUMBER(E.CODFILIAL);
/

  SELECT *
    FROM PCLOGESTOQUE
   WHERE CODFILIAL = '9'
     AND CODPROD = 163083
     AND DATA >= TRUNC(SYSDATE) - 2
   ORDER BY DATA;
/

  SELECT *
    FROM PCHISTEST
   WHERE CODFILIAL = '9'
     AND CODPROD = 163083
     AND DATA >= TRUNC(SYSDATE) - 3;

/*ESTOQUE LOJA*/
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       P.CODAUXILIAR,
       E.DTULTALTERSRVPRC,
       E.QTESTGER,
       E.QTFRENTELOJA,
       (E.QTESTGER - E.QTFRENTELOJA) QTDEPOSITO,
       T.PVENDA
  FROM PCEST E
 INNER JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
  LEFT JOIN PCTABPR T ON E.CODPROD = T.CODPROD
 WHERE T.NUMREGIAO = 100
   AND E.CODFILIAL IN ('1', '7', '8')
   AND P.CODPRODMASTER IN (813306)
 ORDER BY E.CODFILIAL, E.CODPROD;
/
