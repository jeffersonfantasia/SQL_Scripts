SELECT *
  FROM (
    SELECT E.CODFILIAL,
           E.CODPROD,
           P.DESCRICAO,
           E.CUSTOFIN,
           E.CUSTOCONT,
           E.CUSTOREAL,
           E.CUSTOREP,
           (
               SELECT CUSTOFIN
                 FROM PCEST
                WHERE CODPROD = E.CODPROD
                  AND CODFILIAL = 3
           ) CUSTOFIN_3,
           (
               SELECT CUSTOCONT
                 FROM PCEST
                WHERE CODPROD = E.CODPROD
                  AND CODFILIAL = 3
           ) CUSTOCONT_3,
           (
               SELECT VALORULTENT
                 FROM PCEST
                WHERE CODPROD = E.CODPROD
                  AND CODFILIAL = 3
           ) VALORULTENT_3
      FROM PCEST E,
           PCPRODUT P
     WHERE E.CODPROD = P.CODPROD
       AND P.CODMARCA <> 1
       AND E.CODFILIAL = 2
       AND (E.CUSTOFIN IS NULL
        OR E.CUSTOFIN = 0
        OR E.CUSTOCONT IS NULL
        OR E.CUSTOCONT = 0
        OR E.CUSTOREAL IS NULL
        OR E.CUSTOREAL = 0)
       AND EXISTS (
        SELECT F.CODPROD
          FROM PCPRODFILIAL F
         WHERE F.CODFILIAL = 6
           AND F.ENVIARFORCAVENDAS = 'S'
           AND F.CODPROD = E.CODPROD
    )
)
 WHERE (CUSTOFIN_3 <> 0
   AND CUSTOCONT_3 <> 0)
 ORDER BY CODFILIAL;
/