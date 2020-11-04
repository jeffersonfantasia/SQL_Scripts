SELECT *
  FROM ---------------TABELA "B" CRIADA PARA TER O VALOR PREVISTO ATENDIDO POR VENDEDOR--------------------3-----
       (SELECT C.CODFILIAL,
               C.DATA,
               C.CODUSUR,
               U.NOME,
               C.NUMPED,
               C.CODCLI,
               T.CLIENTE,
               C.CODCOB,
               C.VLTOTAL,
               A.VLATENDPREV
          FROM ---------------TABELA "A" CRIADA PARA TER O VALOR PREVISTO ATENDIDO POR NUMPED--------------------2-----
               (SELECT NUMPED,
                       SUM((CASE
                              WHEN QTATENDPREV >= 0 THEN
                              VALOR
                             WHEN QTDISPONIVEL < 0 THEN
                              0
                             ELSE
                              (QTDISPONIVEL * PVENDA)
                           END)) VLATENDPREV
                  FROM ---------------TABELA CRIADA PARA TER A QUANTIDADE PREVISTA ATENDIDA POR PRODUTO ---------1----
                       (SELECT I.CODFILIALRETIRA,
                               I.NUMPED,
                               I.CODPROD,
                               I.QT,
                               I.PVENDA,
                               ROUND((I.QT * I.PVENDA), 2) VALOR,
                               (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA) QTDISPONIVEL,
                               (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA - QT) QTATENDPREV
                          FROM PCPEDI I, PCEST E
                         WHERE I.CODPROD = E.CODPROD
                           AND I.CODFILIALRETIRA = E.CODFILIAL
                           AND I.CODUSUR NOT IN (14, 39, 46)
                           AND I.POSICAO IN ('B', 'P'))
                -----------------------------------------------------------------------------------------------1----
                 GROUP BY NUMPED) A,
               -------------------------------------------------------------------------------------------------2-----
               PCPEDC   C,
               PCCLIENT T,
               PCUSUARI U
         WHERE A.NUMPED = C.NUMPED
           AND C.CODCLI = T.CODCLI
           AND U.CODUSUR = C.CODUSUR
           AND C.CONDVENDA NOT IN (10)
         GROUP BY C.CODFILIAL,
                  C.DATA,
                  C.CODUSUR,
                  U.NOME,
                  C.NUMPED,
                  C.CODCLI,
                  T.CLIENTE,
                  C.CODCOB,
                  C.VLTOTAL,
                  A.VLATENDPREV) B
-------------------------------------------------------------------------------------------------3-----
 WHERE CODFILIAL IN (2)
   AND VLATENDPREV < 1000
   AND CODCOB <> 'BNF'
--AND CODUSUR IN (6)
 ORDER BY CODCLI, DATA;