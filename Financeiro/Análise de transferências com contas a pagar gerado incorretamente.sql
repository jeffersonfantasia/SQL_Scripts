SELECT C.DATA,
       C.CODFILIAL,
       C.CODCLI,
       T.CLIENTE,
       C.CONDVENDA,
       C.POSICAO,
       C.GERACP
  FROM PCPEDC C, PCCLIENT T
 WHERE C.CODCLI = T.CODCLI
   AND C.CONDVENDA = 10
   AND C.GERACP = 'N'
   AND C.DATA > TRUNC(SYSDATE) - 30;