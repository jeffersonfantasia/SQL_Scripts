SELECT C.CODFILIAL,
       C.DATA,
       C.CODUSUR,
       U.NOME,
       C.NUMPED,
       C.POSICAO,
       C.CODCLI,
       T.CLIENTE,
       C.CODPLPAG,
       G.DESCRICAO,
       C.CODCOB,
       A.CODPROD,
       A.PRODUTO,
       A.OBS,
       A.QT,
       A.PVENDA,
       A.VALOR,
       A.VLATENDPREV,
       (CASE WHEN VLATENDPREV = 0 THEN 'SEM ESTOQUE' ELSE 'COM ESTOQUE' END) STATUS
  FROM ---------------TABELA "A" CRIADA PARA TER O VALOR PREVISTO ATENDIDO POR PRODUTO--------------------2-----
       (SELECT W.NUMPED,
               W.CODPROD,
               W.PRODUTO,
               W.OBS,
               W.QT,
               W.PVENDA,
               W.VALOR,
			   SUM((CASE
                     WHEN W.QTATENDPREV >= 0 THEN
                      W.VALOR
                     WHEN W.QTDISPONIVEL < 0 THEN
                      0
                     ELSE
                      (QTDISPONIVEL * PVENDA)
                   END)) VLATENDPREV
      
          FROM ---------------TABELA "W" CRIADA PARA TER A QUANTIDADE PREVISTA ATENDIDA POR PRODUTO ---------1----
               (SELECT I.CODFILIALRETIRA,
                       I.NUMPED,
                       I.CODPROD,
                       P.DESCRICAO PRODUTO,
                       P.OBS,
                       I.QT,
                       I.PVENDA,
                       ROUND((I.QT * I.PVENDA), 2) VALOR,
                       (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA) QTDISPONIVEL,
                       (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA - QT) QTATENDPREV
                  FROM PCPEDI I, PCEST E, PCPRODUT P
                 WHERE I.CODPROD = E.CODPROD
                   AND I.CODPROD = P.CODPROD
                   AND I.CODFILIALRETIRA = E.CODFILIAL
                   AND I.CODUSUR NOT IN (14,39,46)
                   AND I.POSICAO IN ('B', 'P')) W
        -----------------------------------------------------------------------------------------------1----
         GROUP BY W.NUMPED, W.CODPROD, W.PRODUTO, W.OBS, W.QT, W.PVENDA, W.VALOR) A,
       -------------------------------------------------------------------------------------------------2-----
       PCPEDC   C,
       PCCLIENT T,
       PCUSUARI U,
       PCPLPAG G
 WHERE A.NUMPED = C.NUMPED
   AND C.CODCLI = T.CODCLI
   AND U.CODUSUR = C.CODUSUR
   AND C.CODPLPAG = G.CODPLPAG
   AND C.CONDVENDA NOT IN (10)
   AND C.CODUSUR IN (1,4)
 ORDER BY A.NUMPED, STATUS;