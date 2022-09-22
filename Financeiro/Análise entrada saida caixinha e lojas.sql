SELECT CODBANCO, ENTRADA, SAIDA, (ENTRADA - SAIDA) VARIACAO
  --CAIXAS DAS LOJAS
  FROM (SELECT M.CODBANCO,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'D'
                   AND T.NUMCARR > 0
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
                   AND T.DTCOMPENSACAO BETWEEN &DTINICIAL AND &DTFINAL) ENTRADA,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'C'
                   AND T.NUMCARR > 0
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
                   AND T.DTCOMPENSACAO BETWEEN &DTINICIAL AND &DTFINAL) SAIDA
          FROM PCMOVCR M
         WHERE M.CODCOB = 'D'
           AND M.CODBANCO IN (&CODBANCOS)
           AND M.DTCOMPENSACAO BETWEEN &DTINICIAL AND &DTFINAL
         GROUP BY M.CODBANCO, M.CODCOB
        UNION ALL
        --CAIXINHA
        SELECT M.CODBANCO,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'D'
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
                   AND T.DTCOMPENSACAO BETWEEN &DTINICIAL AND &DTFINAL) ENTRADA,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'C'
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
                   AND T.DTCOMPENSACAO BETWEEN &DTINICIAL AND &DTFINAL) SAIDA
          FROM PCMOVCR M
         WHERE M.CODCOB = 'D'
           AND M.CODBANCO IN (&CODBANCOCAIXINHA)
           AND M.DTCOMPENSACAO BETWEEN &DTINICIAL AND &DTFINAL
         GROUP BY M.CODBANCO, M.CODCOB)