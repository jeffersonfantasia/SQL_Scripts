SELECT B.CODCONTABIL,
       M.CODBANCO CODCAIXA,
       M.ENTRADA,
       M.SAIDA,
       (M.ENTRADA - M.SAIDA) VARIACAO
--CAIXAS DAS LOJAS
  FROM (SELECT M.CODBANCO,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'D'
                   AND T.NUMCARR > 0
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
									 AND T.ESTORNO = 'N'
                   AND T.DTCOMPENSACAO BETWEEN
                       TO_DATE(' 01/07/2023 ', 'DD/MM/YYYY') AND
                       TO_DATE(' 31/07/2023 ', 'DD/MM/YYYY')) ENTRADA,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'C'
                   AND (T.NUMCARR = 0 OR T.CODROTINALANC = 619)
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
									 AND T.ESTORNO = 'N'
                   AND T.DTCOMPENSACAO BETWEEN
                       TO_DATE(' 01/07/2023 ', 'DD/MM/YYYY') AND
                       TO_DATE(' 31/07/2023 ', 'DD/MM/YYYY')) SAIDA
          FROM PCMOVCR M
         WHERE M.CODCOB = 'D'
           AND M.CODBANCO IN (65,66,23,13)
         GROUP BY M.CODBANCO, M.CODCOB
        UNION ALL
        --CAIXINHA
        SELECT M.CODBANCO,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'D'
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
                   AND T.DTCOMPENSACAO BETWEEN
                       TO_DATE(' 01/07/2023 ', 'DD/MM/YYYY') AND
                       TO_DATE(' 31/07/2023 ', 'DD/MM/YYYY')) ENTRADA,
               (SELECT SUM(T.VALOR)
                  FROM PCMOVCR T
                 WHERE T.TIPO = 'C'
                   AND T.CODCOB = M.CODCOB
                   AND T.CODBANCO = M.CODBANCO
                   AND T.DTCOMPENSACAO BETWEEN
                       TO_DATE(' 01/07/2023 ', 'DD/MM/YYYY') AND
                       TO_DATE(' 31/07/2023 ', 'DD/MM/YYYY')) SAIDA
          FROM PCMOVCR M
         WHERE M.CODCOB = 'D'
           AND M.CODBANCO IN ( 16)
         GROUP BY M.CODBANCO, M.CODCOB) M
  JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO;
  
