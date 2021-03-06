/*CUSTOS DIFERENTES ENTRE FILIAL FISCAL E FILIAL RETIRA--*/
/*filial 2 e 3*/
WITH CUSTOS_FILIAL_F2 AS (
  SELECT E.CODPROD,
         E.QTESTGER,
         ROUND (E.VALORULTENT, 2) VALORULTENT_F,
         ROUND (E.CUSTOULTENT, 2) CUSTOULTENT_F,
         ROUND (E.CUSTOFIN, 2) CUSTOFIN_F,
         ROUND (E.CUSTOREAL, 2) CUSTOREAL_F,
         ROUND (E.CUSTOCONT, 2) CUSTOCONT_F,
         ROUND (E.CUSTOREP, 2) CUSTOREP_F
    FROM PCEST E
   WHERE E.CODFILIAL = 2
),
/*filial 1 e 4*/
 CUSTOS_FILIAL_F1 AS (
  SELECT E.CODPROD,
         E.QTESTGER,
         ROUND (E.VALORULTENT, 2) VALORULTENT_F,
         ROUND (E.CUSTOULTENT, 2) CUSTOULTENT_F,
         ROUND (E.CUSTOFIN, 2) CUSTOFIN_F,
         ROUND (E.CUSTOREAL, 2) CUSTOREAL_F,
         ROUND (E.CUSTOCONT, 2) CUSTOCONT_F,
         ROUND (E.CUSTOREP, 2) CUSTOREP_F
    FROM PCEST E
   WHERE E.CODFILIAL = 1
)
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTESTGER,
       ROUND (E.VALORULTENT, 2) VALORULTENT,
       ROUND (E.CUSTOULTENT, 2) CUSTOULTENT,
       ROUND (E.CUSTOFIN, 2) CUSTOFIN,
       ROUND (E.CUSTOREAL, 2) CUSTOREAL,
       ROUND (E.CUSTOCONT, 2) CUSTOCONT,
       ROUND (E.CUSTOREP, 2) CUSTOREP,
       C.VALORULTENT_F,
       C.CUSTOULTENT_F,
       C.CUSTOFIN_F,
       C.CUSTOREAL_F,
       C.CUSTOCONT_F,
       C.CUSTOREP_F
  FROM PCEST E
  LEFT JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
  LEFT JOIN CUSTOS_FILIAL_F2 C ON E.CODPROD = C.CODPROD
 WHERE E.CODFILIAL = 3
   AND E.QTESTGER > 0
   AND (ROUND (E.VALORULTENT, 2) <> C.VALORULTENT_F
    OR ROUND (E.CUSTOULTENT, 2) <> C.CUSTOULTENT_F
    OR ROUND (E.CUSTOFIN, 2) <> C.CUSTOFIN_F
    OR ROUND (E.CUSTOREAL, 2) <> C.CUSTOREAL_F
    OR ROUND (E.CUSTOCONT, 2) <> C.CUSTOCONT_F
    OR ROUND (E.CUSTOREP, 2) <> C.CUSTOREP_F)
UNION ALL
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTESTGER,
       ROUND (E.VALORULTENT, 2) VALORULTENT,
       ROUND (E.CUSTOULTENT, 2) CUSTOULTENT,
       ROUND (E.CUSTOFIN, 2) CUSTOFIN,
       ROUND (E.CUSTOREAL, 2) CUSTOREAL,
       ROUND (E.CUSTOCONT, 2) CUSTOCONT,
       ROUND (E.CUSTOREP, 2) CUSTOREP,
       C.VALORULTENT_F,
       C.CUSTOULTENT_F,
       C.CUSTOFIN_F,
       C.CUSTOREAL_F,
       C.CUSTOCONT_F,
       C.CUSTOREP_F
  FROM PCEST E
  LEFT JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
  LEFT JOIN CUSTOS_FILIAL_F1 C ON E.CODPROD = C.CODPROD
 WHERE E.CODFILIAL = 4
   AND E.QTESTGER > 0
   AND (ROUND (E.VALORULTENT, 2) <> C.VALORULTENT_F
    OR ROUND (E.CUSTOULTENT, 2) <> C.CUSTOULTENT_F
    OR ROUND (E.CUSTOFIN, 2) <> C.CUSTOFIN_F
    OR ROUND (E.CUSTOREAL, 2) <> C.CUSTOREAL_F
    OR ROUND (E.CUSTOCONT, 2) <> C.CUSTOCONT_F
    OR ROUND (E.CUSTOREP, 2) <> C.CUSTOREP_F);
/