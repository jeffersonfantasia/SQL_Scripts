WITH CREDITO_EM_ABERTO AS
 (SELECT C.CODCLI, C.VALOR VLCREDITO
    FROM PCCRECLI C
   WHERE NVL(C.VALOR, 0) <> 0
     AND C.DTDESCONTO IS NULL
     AND C.DTESTORNO IS NULL),
QT_PREV_ATENDIDA AS
 (SELECT I.CODFILIALRETIRA,
         I.NUMPED,
         I.CODPROD,
         I.QT,
         I.PVENDA,
         I.CODUSUR,
         ROUND((I.QT * I.PVENDA), 2) VALOR,
         (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA) QTDISPONIVEL,
         (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA - QT) QTATENDPREV
    FROM PCPEDI I, PCEST E
   WHERE I.CODPROD = E.CODPROD
     AND I.CODFILIALRETIRA = E.CODFILIAL
     AND I.CODUSUR NOT IN (14, 39, 46)
     AND I.POSICAO IN ('B', 'P')),
VALOR_PREV_ATENDIDO AS
 (SELECT NUMPED,
         SUM((CASE
               WHEN QTATENDPREV >= 0 THEN
                VALOR
               WHEN QTDISPONIVEL < 0 THEN
                0
               ELSE
                (QTDISPONIVEL * PVENDA)
             END)) VLATENDPREV
    FROM QT_PREV_ATENDIDA
   GROUP BY NUMPED)

SELECT CODFILIAL,
       MENOR_DATA,
       CODCLIPRINC,
       CODCLI,
       CLIENTE,
       OBS,
       SOMA_VLTOTAL,
       SOMA_VLATENDPREV,
       VLCREDITO
  FROM (SELECT C.CODFILIAL,
               MIN(C.DATA) OVER (PARTITION BY C.CODFILIAL, C.CODCLI) MENOR_DATA,
               T.CODCLIPRINC,
               C.CODCLI,
               T.CLIENTE,
               C.OBS,
               SUM(C.VLTOTAL) OVER (PARTITION BY C.CODFILIAL, C.CODCLI) SOMA_VLTOTAL,
               SUM(A.VLATENDPREV) OVER (PARTITION BY C.CODFILIAL, C.CODCLI) SOMA_VLATENDPREV,
               SUM(CA.VLCREDITO) OVER (PARTITION BY C.CODFILIAL, C.CODCLI) VLCREDITO             
          FROM PCPEDC C
          JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
          JOIN VALOR_PREV_ATENDIDO A ON A.NUMPED = C.NUMPED
          LEFT JOIN CREDITO_EM_ABERTO CA ON CA.CODCLI = C.CODCLI
         WHERE C.CONDVENDA NOT IN (10))
 WHERE CODFILIAL IN ('2')
   AND SOMA_VLATENDPREV >= 500
 ORDER BY MENOR_DATA, CODCLIPRINC;