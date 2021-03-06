SELECT COUNT (*) AS QTDPEDIDOS
  FROM PCPEDC C
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  LEFT JOIN PCUSUARI U ON T.CODUSUR1 = U.CODUSUR
  LEFT JOIN PCSUPERV V ON U.CODSUPERVISOR = V.CODSUPERVISOR
 WHERE C.POSICAO NOT IN (
    'C', 'F'
)
   AND V.CODGERENTE IN (
    1, 8, 9, 10
)
   AND T.USADEBCREDRCA = 'N'
   AND C.CONDVENDA IN (
    1, 7
);
/