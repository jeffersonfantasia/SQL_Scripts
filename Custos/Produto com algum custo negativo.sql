SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.DTULTENT,
       E.VALORULTENT,
       E.CUSTOULTENT,
       E.CUSTOFIN,
       E.CUSTOREAL,
       E.CUSTOREP,
       E.CUSTOCONT,
       E.CUSTOULTENTFIN,
       E.CUSTOULTENTCONT,
       E.CUSTOULTENTLIQ,
       E.CUSTOREALLIQ,
       E.CUSTONFSEMST,
       E.CUSTOFINSEMST,
       E.CUSTOREALSEMST,
       E.CUSTOULTENTFINSEMST
  FROM PCEST E
  LEFT JOIN PCPRODUT P ON E.CODPROD = P.CODPROD
 WHERE E.VALORULTENT < 0
    OR E.CUSTOULTENT < 0
    OR E.CUSTOFIN < 0
    OR E.CUSTOREAL < 0
    OR E.CUSTOREP < 0
    OR E.CUSTOCONT < 0
    OR E.CUSTOULTENTFIN < 0
    OR E.CUSTOULTENTCONT < 0
    OR E.CUSTOULTENTLIQ < 0
    OR E.CUSTOREALLIQ < 0
    OR E.CUSTONFSEMST < 0
    OR E.CUSTOFINSEMST < 0
    OR E.CUSTOREALSEMST < 0
    OR E.CUSTOULTENTFINSEMST < 0;
/