/*CUSTOS DIFERENTES ENTRE FILIAL FISCAL E FILIAL RETIRA--*/
/*filial 2 e 3*/
WITH CUSTOS_FILIAL_F2 AS
 (SELECT E.CODPROD,
         E.QTESTGER,
         E.VALORULTENT VALORULTENT_F,
         E.CUSTOULTENT CUSTOULTENT_F,
         E.CUSTOFIN CUSTOFIN_F,
         E.CUSTOREAL CUSTOREAL_F,
         E.CUSTOCONT CUSTOCONT_F,
         E.CUSTOREP CUSTOREP_F
    FROM PCEST E
   WHERE E.CODFILIAL = '2'),
/*filial 1 e 4*/
CUSTOS_FILIAL_F1 AS
 (SELECT E.CODPROD,
         E.QTESTGER,
         E.VALORULTENT VALORULTENT_F,
         E.CUSTOULTENT CUSTOULTENT_F,
         E.CUSTOFIN CUSTOFIN_F,
         E.CUSTOREAL CUSTOREAL_F,
         E.CUSTOCONT CUSTOCONT_F,
         E.CUSTOREP CUSTOREP_F
    FROM PCEST E
   WHERE E.CODFILIAL = '1')
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTESTGER,
       E.VALORULTENT VALORULTENT,
       E.CUSTOULTENT CUSTOULTENT,
       E.CUSTOFIN CUSTOFIN,
       E.CUSTOREAL CUSTOREAL,
       E.CUSTOCONT CUSTOCONT,
       E.CUSTOREP CUSTOREP,
       C.VALORULTENT_F,
       C.CUSTOULTENT_F,
       C.CUSTOFIN_F,
       C.CUSTOREAL_F,
       C.CUSTOCONT_F,
       C.CUSTOREP_F
  FROM PCEST E
  JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
  LEFT JOIN CUSTOS_FILIAL_F2 C ON E.CODPROD = C.CODPROD
 WHERE E.CODFILIAL = '3'
   AND E.QTESTGER > 0
   AND (NVL(E.VALORULTENT, 0) = 0 OR NVL(E.CUSTOULTENT, 0) = 0 OR
       NVL(E.CUSTOFIN, 0) = 0 OR NVL(E.CUSTOREAL, 0) = 0 OR
       NVL(E.CUSTOCONT, 0) = 0 OR NVL(E.CUSTOREP, 0) = 0)
UNION ALL
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTESTGER,
       E.VALORULTENT VALORULTENT,
       E.CUSTOULTENT CUSTOULTENT,
       E.CUSTOFIN CUSTOFIN,
       E.CUSTOREAL CUSTOREAL,
       E.CUSTOCONT CUSTOCONT,
       E.CUSTOREP CUSTOREP,
       C.VALORULTENT_F,
       C.CUSTOULTENT_F,
       C.CUSTOFIN_F,
       C.CUSTOREAL_F,
       C.CUSTOCONT_F,
       C.CUSTOREP_F
  FROM PCEST E
  JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
  LEFT JOIN CUSTOS_FILIAL_F1 C ON E.CODPROD = C.CODPROD
 WHERE E.CODFILIAL = '4' AND E.QTESTGER > 0 AND
 (NVL(E.VALORULTENT, 0) = 0 OR NVL(E.CUSTOULTENT, 0) = 0 OR
 NVL(E.CUSTOFIN, 0) = 0 OR NVL(E.CUSTOREAL, 0) = 0 OR
 NVL(E.CUSTOCONT, 0) = 0 OR NVL(E.CUSTOREP, 0) = 0);
/

--ATUALIZACAO DOS DADOS
MERGE
  INTO PCEST E
  USING (
/*CUSTOS DIFERENTES ENTRE FILIAL FISCAL E FILIAL RETIRA--*/
/*filial 2 e 3*/
  WITH CUSTOS_FILIAL_F2 AS
   (SELECT E.CODPROD,
           E.QTESTGER,
           E.VALORULTENT VALORULTENT_F,
           E.CUSTOULTENT CUSTOULTENT_F,
           E.CUSTOFIN CUSTOFIN_F,
           E.CUSTOREAL CUSTOREAL_F,
           E.CUSTOCONT CUSTOCONT_F,
           E.CUSTOREP CUSTOREP_F
      FROM PCEST E
     WHERE E.CODFILIAL = '2'),
  /*filial 1 e 4*/
  CUSTOS_FILIAL_F1 AS
   (SELECT E.CODPROD,
           E.QTESTGER,
           E.VALORULTENT VALORULTENT_F,
           E.CUSTOULTENT CUSTOULTENT_F,
           E.CUSTOFIN CUSTOFIN_F,
           E.CUSTOREAL CUSTOREAL_F,
           E.CUSTOCONT CUSTOCONT_F,
           E.CUSTOREP CUSTOREP_F
      FROM PCEST E
     WHERE E.CODFILIAL = '1')
  SELECT E.CODFILIAL,
         E.CODPROD,
         P.DESCRICAO,
         E.QTESTGER,
         E.VALORULTENT VALORULTENT,
         E.CUSTOULTENT CUSTOULTENT,
         E.CUSTOFIN CUSTOFIN,
         E.CUSTOREAL CUSTOREAL,
         E.CUSTOCONT CUSTOCONT,
         E.CUSTOREP CUSTOREP,
         C.VALORULTENT_F,
         C.CUSTOULTENT_F,
         C.CUSTOFIN_F,
         C.CUSTOREAL_F,
         C.CUSTOCONT_F,
         C.CUSTOREP_F
    FROM PCEST E
    JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
    LEFT JOIN CUSTOS_FILIAL_F2 C ON E.CODPROD = C.CODPROD
   WHERE E.CODFILIAL = '3'
     AND E.QTESTGER > 0
     AND (NVL(E.VALORULTENT, 0) = 0 OR NVL(E.CUSTOULTENT, 0) = 0 OR
         NVL(E.CUSTOFIN, 0) = 0 OR NVL(E.CUSTOREAL, 0) = 0 OR
         NVL(E.CUSTOCONT, 0) = 0 OR NVL(E.CUSTOREP, 0) = 0)
  UNION ALL
  SELECT E.CODFILIAL,
         E.CODPROD,
         P.DESCRICAO,
         E.QTESTGER,
         E.VALORULTENT VALORULTENT,
         E.CUSTOULTENT CUSTOULTENT,
         E.CUSTOFIN CUSTOFIN,
         E.CUSTOREAL CUSTOREAL,
         E.CUSTOCONT CUSTOCONT,
         E.CUSTOREP CUSTOREP,
         C.VALORULTENT_F,
         C.CUSTOULTENT_F,
         C.CUSTOFIN_F,
         C.CUSTOREAL_F,
         C.CUSTOCONT_F,
         C.CUSTOREP_F
    FROM PCEST E
    JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
    LEFT JOIN CUSTOS_FILIAL_F1 C ON E.CODPROD = C.CODPROD
   WHERE E.CODFILIAL = '4' AND E.QTESTGER > 0 AND
   (NVL(E.VALORULTENT, 0) = 0 OR NVL(E.CUSTOULTENT, 0) = 0 OR
   NVL(E.CUSTOFIN, 0) = 0 OR NVL(E.CUSTOREAL, 0) = 0 OR
   NVL(E.CUSTOCONT, 0) = 0 OR NVL(E.CUSTOREP, 0) = 0)) X ON (E.CODPROD = X.CODPROD AND E.CODFILIAL = X.CODFILIAL) WHEN MATCHED THEN UPDATE SET E.VALORULTENT = X.VALORULTENT_F, E.CUSTOULTENT = X.CUSTOULTENT_F, E.CUSTOFIN = X.CUSTOFIN_F, E.CUSTOREAL = X.CUSTOREAL_F, E.CUSTOCONT = X.CUSTOCONT_F, E.CUSTOREP = X.CUSTOREP_F;
