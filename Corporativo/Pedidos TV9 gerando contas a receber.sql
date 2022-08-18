SELECT C.DATA,
       C.CODFILIAL,
       C.NUMPED,
       C.CODCLI,
       T.CLIENTE,
       C.POSICAO,
       C.NUMNOTA,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA
  FROM PCPEDC C
  JOIN PCCLIENT T ON T.CODCLI = C.CODCLI
  LEFT JOIN PCPREST P ON P.NUMTRANSVENDA = C.NUMTRANSVENDA
 WHERE C.CONDVENDA = 9
   AND C.GERACP = 'N'
   AND (C.POSICAO NOT IN ('C', 'F') OR (P.DUPLIC IS NOT NULL AND P.DTPAG IS NULL));
   /