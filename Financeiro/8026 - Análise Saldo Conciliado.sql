/*SUBSTITUIR BANCO, DATAINICIAL E DATAFINAL*/
SELECT M.DTCOMPENSACAO,
       M.CODBANCO,
       M.CODCOB,
       DECODE (M.TIPO, 'C', 0, SUM (M.VALOR)) SOMA_ENTRADA,
       DECODE (M.TIPO, 'C', SUM (M.VALOR), 0) SOMA_SAIDA,
       SI.SALDO SALDOINICIAL
  FROM PCMOVCR M,
       (
           SELECT NVL (ENTRADAS.ENTRADAS, 0) ENTRADAS,
                  NVL (SAIDAS.SAIDAS, 0) SAIDAS,
                  (NVL (ENTRADAS.ENTRADAS, 0) + NVL (SAIDAS.SAIDAS, 0)) SALDO
             FROM (
               SELECT SUM (M.VALOR) ENTRADAS
                 FROM PCMOVCR M
                WHERE M.TIPO <> 'C'
                  AND M.DTCOMPENSACAO < TO_DATE ('01/09/2015', 'DD/MM/YYYY')
                  AND M.CONCILIACAO = 'OK'
                  AND M.CODBANCO = 12
                  AND M.CODCOB IN (
                   'D'
               )
           ) ENTRADAS,
                  (
                      SELECT (SUM (M.VALOR) * - 1) SAIDAS
                        FROM PCMOVCR M
                       WHERE M.TIPO = 'C'
                         AND M.DTCOMPENSACAO < TO_DATE ('01/09/2015', 'DD/MM/YYYY')
                         AND M.CONCILIACAO = 'OK'
                         AND M.CODBANCO = 12
                         AND M.CODCOB IN (
                          'D'
                      )
                  ) SAIDAS
       ) SI
 WHERE M.CONCILIACAO = 'OK'
   AND TRUNC (M.DTCOMPENSACAO) >= TO_DATE ('01/09/2015', 'DD/MM/YYYY')
   AND TRUNC (M.DTCOMPENSACAO) <= TO_DATE ('30/09/2021', 'DD/MM/YYYY')
   AND M.CODBANCO = 12
   AND M.CODCOB IN (
    'D'
)
 GROUP BY M.DTCOMPENSACAO,
          M.CODBANCO,
          M.CODCOB,
          M.TIPO,
          SI.SALDO
 ORDER BY M.DTCOMPENSACAO;
/