SELECT C.DATA,
       C.NUMPED,
       C.NUMPEDENTFUT,
       C.CONDVENDA,
       C.CONTAORDEM,
       C.CODCLI,
       T.CLIENTE,
       C.CODCOB,
       C.CODEMITENTE
  FROM PCPEDC C
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
 WHERE C.POSICAO NOT IN ('F', 'C')
   AND C.CONDVENDA IN (7, 8)
   AND (C.CONTAORDEM IS NULL OR (CASE
         WHEN (C.CONDVENDA = 8 AND C.CODCOB = 'SENT' AND
              C.NUMPEDENTFUT IS NOT NULL) THEN
          1
         WHEN (C.CONDVENDA = 7 AND C.CODCOB <> 'SENT') THEN
          1
         ELSE
          0
       END) = 0);
 /