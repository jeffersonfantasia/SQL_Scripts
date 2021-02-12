SELECT C.CODCLI,
       C.CLIENTE,
       C.CLIENTE_REDE,
       (
           CASE
               WHEN C.CODREDE IS NULL THEN ('C' || C.CODCLI)
               ELSE ('R' || C.CODREDE)
           END
       ) AS CODCLI_REDE
  FROM VIEW_JC_CLIENTE C
  LEFT JOIN VIEW_JC_VENDEDOR V ON C.CODUSUR1 = V.CODUSUR
 WHERE V.CODGERENTE IN (
    1, 8, 9, 10
);
/