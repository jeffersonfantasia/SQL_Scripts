CREATE OR REPLACE VIEW VIEW_JC_ADIANT_CLIENTE AS
    WITH PCCRECLI_BASE AS (
        SELECT C.CODFILIAL,
               C.DTLANC,
               C.CODIGO AS CODCRED,
     /*USADO NA CONSTRUCAO DA VIEW_JC_PCPREST_BAIXA_CRED        */
               C.NUMTRANS,
               C.NUMTRANSBAIXA,
               C.CODMOVIMENTO,
               C.VALOR AS VLPAGO,
               (
                   CASE
                       WHEN C.VALOR < 0 THEN C.VALOR * - 1
                       ELSE C.VALOR
                   END
               ) AS VALOR,
     /*TRANSFORMAR OS VALORES NEGATIVOS PARA ARQUIVO CONTABILIDADE*/
               T.CLIENTE
          FROM PCCRECLI C
          LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
         WHERE C.NUMERARIO = 'S'
     /* PARA PUXAR APENAS ADIANTAMENTOS QUE MOVIMENTARAM BANCOS*/
    ), ADIANTAMENTO_REALIZADO AS (
        SELECT C.CODFILIAL,
               M.DTCOMPENSACAO,
               C.DTLANC,
               C.CODCRED,
     /*USADO NA CONSTRUCAO DA VIEW_JC_PCPREST_BAIXA_CRED    */
               M.CODBANCO,
               B.CODBACEN,
               B.CODCONTABIL AS CODCONTABILBANCO,
               C.NUMTRANS,
               C.NUMTRANSBAIXA,
               C.VLPAGO,
               C.VALOR,
               C.CLIENTE
          FROM PCCRECLI_BASE C
         INNER JOIN PCMOVCR M ON C.NUMTRANS = M.NUMTRANS
           AND C.CODMOVIMENTO = M.CODBANCO
          LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
         WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR   */
           AND M.CODBANCO NOT IN (
            17, 20, 35, 50, 52, 53, 54
        )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
           AND C.NUMTRANSBAIXA IS NULL
     /*PARA N�O PUXAR PAGAMENTO DEVOLVIDO DOS ADIANTAMENTOS*/
           AND C.VLPAGO > 0
     /*PARA NAO TRAZER DESDOBRAMENTOS DO ADIANTAMENTO INICIAL*/
    ), ADIANTAMENTO_DEVOLVIDO AS (
        SELECT C.CODFILIAL,
               M.DTCOMPENSACAO,
               C.DTLANC,
               C.CODCRED,
     /*USADO NA CONSTRUCAO DA VIEW_JC_PCPREST_BAIXA_CRED    */
               M.CODBANCO,
               B.CODBACEN,
               B.CODCONTABIL AS CODCONTABILBANCO,
               C.NUMTRANS,
               C.NUMTRANSBAIXA,
               C.VLPAGO,
               C.VALOR,
               C.CLIENTE
          FROM PCCRECLI_BASE C
         INNER JOIN PCMOVCR M ON C.NUMTRANSBAIXA = M.NUMTRANS
           AND C.CODMOVIMENTO = M.CODBANCO
          LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
         WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR   */
           AND M.CODBANCO NOT IN (
            17, 20, 35, 50, 52, 53, 54
        )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
           AND C.NUMTRANS IS NULL
     /*PARA N�O PUXAR PAGAMENTOS RECEBIDO DOS ADIANTAMENTOS*/
           AND C.VLPAGO > 0
     /*PARA RETIRAR ESTORNOS ESTORNADOS*/
    )
    SELECT B.CODFILIAL,
           (
               CASE
                   WHEN B.DTCOMPENSACAO IS NULL THEN B.DTLANC
                   ELSE B.DTCOMPENSACAO
               END
           ) AS DATA,
     /*PARA NAO FICAR SEM DATA EM SITUA��ES AONDE NAO FOI CONCILIADO*/
           B.CODCRED,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.NUMTRANS,
           B.VLPAGO,
           B.VALOR,
           (B.NUMTRANS || ' - ' || 'ADIANT. CLIENTE - ' || B.CLIENTE) AS HISTORICO
      FROM ADIANTAMENTO_REALIZADO B
     WHERE NVL (B.CODBACEN, '0') NOT IN (
        'MARKETPLACE'
    )
    UNION ALL
        /*MARKETPLACES*/
    SELECT B.CODFILIAL,
           B.DTLANC AS DATA,
           B.CODCRED,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.NUMTRANS,
           B.VLPAGO,
           B.VALOR,
           (B.NUMTRANS || ' - ' || 'ADIANT. CLIENTE - ' || B.CLIENTE) AS HISTORICO
      FROM ADIANTAMENTO_REALIZADO B
     WHERE NVL (B.CODBACEN, '0') IN (
        'MARKETPLACE'
    )
    UNION ALL
        /*RELA��O DOS LAN�AMENTOS DE DEVOLU��O DO ADIANTAMENTO AO CLIENTE*/
    SELECT B.CODFILIAL,
           (
               CASE
                   WHEN B.DTCOMPENSACAO IS NULL THEN B.DTLANC
                   ELSE B.DTCOMPENSACAO
               END
           ) AS DATA,
     /*PARA NAO FICAR SEM DATA EM SITUA��ES AONDE NAO FOI CONCILIADO*/
           0 AS CODCRED,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.NUMTRANSBAIXA AS NUMTRANS,
           B.VLPAGO,
           B.VALOR,
           (B.NUMTRANSBAIXA || ' - ' || 'DEV ADIANT. CLIENTE - ' || B.CLIENTE) AS HISTORICO
      FROM ADIANTAMENTO_DEVOLVIDO B
     WHERE NVL (B.CODBACEN, '0') NOT IN (
        'MARKETPLACE'
    )
    UNION ALL
        /*MARKETPLACES*/
    SELECT B.CODFILIAL,
           B.DTLANC AS DATA,
           0 AS CODCRED,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.NUMTRANSBAIXA AS NUMTRANS,
           B.VLPAGO,
           B.VALOR,
           (B.NUMTRANSBAIXA || ' - ' || 'DEV ADIANT. CLIENTE - ' || B.CLIENTE) AS HISTORICO
      FROM ADIANTAMENTO_DEVOLVIDO B
     WHERE NVL (B.CODBACEN, '0') IN (
        'MARKETPLACE'
    );
/