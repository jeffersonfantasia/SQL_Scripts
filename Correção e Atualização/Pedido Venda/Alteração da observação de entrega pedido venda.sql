SELECT P.OBSENTREGA1,
       P.*
  FROM PCPEDC P
 INNER JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
 WHERE P.POSICAO NOT IN (
    'F', 'C'
)
   AND C.CODREDE = 791;
/
UPDATE PCPEDC P
   SET
    P.OBSENTREGA1 = 'ETIQUETA PERSONALIZADA'
 WHERE EXISTS (
    SELECT 1
      FROM PCCLIENT C
     WHERE C.CODCLI = P.CODCLI
       AND POSICAO NOT IN (
        'F', 'C'
    )
       AND C.CODREDE = 791
       AND P.OBSENTREGA1 IS NULL
);
/