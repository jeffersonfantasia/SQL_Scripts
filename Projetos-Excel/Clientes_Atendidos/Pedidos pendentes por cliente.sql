SELECT C.DATA,
       C.CODCLI,
       C.CODUSUR,
       C.VLATEND
  FROM PCPEDC C
  LEFT JOIN VIEW_JC_VENDEDOR V ON C.CODUSUR = V.CODUSUR
 WHERE C.CONDVENDA IN (
    1, 7
)
   AND C.POSICAO NOT IN (
    'F', 'C'
)
   AND V.CODGERENTE IN (
    1, 8, 9, 10
);
/