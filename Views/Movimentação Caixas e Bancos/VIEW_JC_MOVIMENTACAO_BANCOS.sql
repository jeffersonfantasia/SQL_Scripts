CREATE OR REPLACE VIEW VIEW_JC_MOVIMENTACAO_BANCOS AS
    WITH PCMOVCR_BASE AS (
        SELECT (
            CASE
                WHEN M.DTCOMPENSACAO IS NULL THEN M.DATA
                ELSE M.DTCOMPENSACAO
            END
        ) AS DATA,
     /*PARA QUE TENHAMOS A DATA DE MOVIMENTACOES NAO CONCILIADAS AT� SEREM CONCILIADAS*/
               M.NUMTRANS,
               (
                   CASE
                       WHEN B.CODFILIAL IN (
                           1, 2, 7, 99
                       ) THEN '1'
                       ELSE B.CODFILIAL
                   END
               ) AS CODEMPRESA,
               B.CODFILIAL,
               M.CODBANCO,
               B.NOME,
               B.CODCONTABIL,
               M.CODCOB,
               M.VALOR,
               M.TIPO,
               M.CONCILIACAO,
               (
                   CASE
                       WHEN M.HISTORICO2 = '                          0'
                           OR M.HISTORICO2 LIKE '%TRANSF. DE%' THEN NULL
                       ELSE M.HISTORICO2
                   END
               ) AS HISTORICO
     /*PARA RETIRAR HISTORICO ZERADO OU COM O PADRAO TRANSF*/
          FROM PCMOVCR M
          LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
         WHERE M.DTESTORNO IS NULL
           AND M.ESTORNO <> 'S'
     /*NAO TRAZER MOVIMENTACOES ESTORNADAS*/
           AND M.CODCOB = 'D'
     /*SOMENTE TRANSACOES COM DINHERO*/
           AND M.CODROTINALANC IN (
            632, 643
        )
     /*LANCAMENTOS SOMENTE COM MOVIMENTACAO ENTRE CAIXAS*/
           AND M.CODBANCO NOT IN (
            17, 20, 35, 50, 52, 53, 54
        )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA*/
           AND M.NUMTRANS NOT IN (
            116436
        )
     /*PARA RETIRAR LANCAMENTO DE AJUSTE ENTRE INVESTIMENTOS DO ITAU EM JUN/19*/
    ), PCMOVCR_CREDITO AS (
        SELECT B.NUMTRANS,
               B.CODEMPRESA AS CODEMPRESA_CRED,
               B.CODFILIAL AS CODFILIALCRED,
               B.CODBANCO AS CODBANCOCRED,
               B.NOME AS BANCOCRED,
               B.CODCONTABIL AS CODCONTABILCRED,
               B.CODCOB,
               B.VALOR,
               B.HISTORICO
          FROM PCMOVCR_BASE B
         WHERE B.TIPO = 'C'
     /*TRAZER LAN�AMENTOS DE CREDITO*/
    ), PCMOVCR_DEBITO AS (
        SELECT B.DATA,
               B.CODEMPRESA AS CODEMPRESA_DEB,
               B.NUMTRANS,
               B.CONCILIACAO,
               B.CODFILIAL AS CODFILIALDEB,
               B.CODBANCO AS CODBANCODEB,
               B.NOME AS BANCODEB,
               B.CODCONTABIL AS CODCONTABILDEB
          FROM PCMOVCR_BASE B
         WHERE B.TIPO = 'D'
     /*TRAZER LAN�AMENTOS DE DEBITO*/
    ), PCMOVCR_RESULTADO AS (
        SELECT D.DATA,
               C.NUMTRANS,
               C.CODFILIALCRED,
               C.CODBANCOCRED,
               C.BANCOCRED,
               C.CODCONTABILCRED,
               D.CODFILIALDEB,
               D.CODBANCODEB,
               D.BANCODEB,
               D.CODCONTABILDEB,
               C.CODCOB,
               C.VALOR,
               D.CONCILIACAO,
               C.HISTORICO,
               D.CODEMPRESA_DEB,
               C.CODEMPRESA_CRED
          FROM PCMOVCR_CREDITO C
         INNER JOIN PCMOVCR_DEBITO D ON C.NUMTRANS = D.NUMTRANS
    )
/*MOVIMENTA��O ENTRE BANCOS DE MESMA EMPRESA--*/
    SELECT R.DATA,
           R.NUMTRANS,
           R.CODFILIALCRED,
           R.CODBANCOCRED,
           R.CODCONTABILCRED,
           R.CODFILIALDEB,
           R.CODBANCODEB,
           R.CODCONTABILDEB,
           R.CODCOB,
           R.VALOR,
           R.CONCILIACAO,
           'G' AS TIPO,
           (
               CASE
                   WHEN R.HISTORICO IS NULL THEN ('N� ' || R.NUMTRANS || ' - ' || R.BANCOCRED || ' - P/ ' || R.BANCODEB)
                   ELSE ('N� ' || R.NUMTRANS || ' - ' || R.BANCOCRED || ' - P/ ' || R.BANCODEB || ' - ' || R.HISTORICO)
               END
           ) HISTORICO
      FROM PCMOVCR_RESULTADO R
     WHERE R.CODEMPRESA_CRED = R.CODEMPRESA_DEB
     /*RETIRAR LANCAMENTOS DE EMPRESAS DIFERENTES*/
    UNION ALL
/*RECEBIMENTO EMPRESTIMO - BANCOS DE EMPRESAS DIFERENTES--*/
    SELECT R.DATA,
           R.NUMTRANS,
           R.CODFILIALDEB AS CODFILIALCRED,
           R.CODBANCOCRED,
           R.CODCONTABILCRED,
           R.CODFILIALDEB,
           R.CODBANCODEB,
           R.CODCONTABILDEB,
           R.CODCOB,
           R.VALOR,
           R.CONCILIACAO,
           'EC' AS TIPO,
           (R.NUMTRANS || ' - RECEBIMENTO EMPRESTIMOS A TERCEIROS') AS HISTORICO
      FROM PCMOVCR_RESULTADO R
     WHERE R.CODEMPRESA_CRED <> R.CODEMPRESA_DEB
     /*SOMENTE LANCAMENTOS DE EMPRESAS DIFERENTES*/
    UNION ALL
/*PAGAMENTO EMPRESTIMO - BANCOS DE EMPRESAS DIFERENTES--*/
    SELECT R.DATA,
           R.NUMTRANS,
           R.CODFILIALCRED,
           R.CODBANCOCRED,
           R.CODCONTABILCRED,
           R.CODFILIALCRED AS CODFILIALDEB,
           R.CODBANCODEB,
           R.CODCONTABILDEB,
           R.CODCOB,
           R.VALOR,
           R.CONCILIACAO,
           'EB' AS TIPO,
           (R.NUMTRANS || ' - PAGTO EMPRESTIMOS A TERCEIROS') AS HISTORICO
      FROM PCMOVCR_RESULTADO R
     WHERE R.CODEMPRESA_CRED <> R.CODEMPRESA_DEB
     /*SOMENTE LANCAMENTOS DE EMPRESAS DIFERENTES*/;
/