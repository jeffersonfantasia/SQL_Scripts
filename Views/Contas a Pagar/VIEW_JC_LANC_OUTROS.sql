CREATE OR REPLACE VIEW VIEW_JC_LANC_OUTROS AS
    WITH TODOS_LANC_FINANCEIROJUR AS
/*SELECAO DE TODOS OS LANCAMENTOS DE DESCONTOS E JUROS*/ (
        SELECT L.RECNUM
          FROM PCLANC L
         INNER JOIN VIEW_JC_LANC_DESC_JUR T ON L.RECNUMBAIXA = T.RECNUM
    )
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           B.VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           '' AS CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           (
               CASE
                   WHEN B.TIPOPARCEIRO = 'F' THEN 'F'
                   ELSE 'O'
               END
           ) AS TIPO,
           (
               CASE
                   WHEN B.NUMNOTA IS NULL
                       OR B.NUMNOTA = '0' THEN
                       CASE
                           WHEN B.CODCONTA IN (
                               610101, 620110, 620111, 650101
                           ) THEN
     /*RENDIMENTOS, IR, IOF, TARIFAS*/ B.HISTORICO || ' - ' || B.NOME
                           ELSE B.RECNUM || ' - ' || B.HISTORICO
                       END
                   WHEN B.DUPLIC IS NULL
                       OR B.DUPLIC = '0' THEN 'NF ' || B.NUMNOTA || ' - ' || B.HISTORICO
                   ELSE 'NF ' || B.NUMNOTA || ' - ' || B.DUPLIC || ' - ' || B.HISTORICO
               END
           ) HISTORICO
      FROM VIEW_JC_LANC_BASE B
      LEFT JOIN VIEW_JC_LANC_ADIANTAMENTOFOR AF ON B.RECNUM = AF.RECNUM
      LEFT JOIN VIEW_JC_LANC_ADIANTFOR_BAIXA AB ON B.RECNUM = AB.RECNUM
      LEFT JOIN TODOS_LANC_FINANCEIROJUR T ON B.RECNUM = T.RECNUM
      LEFT JOIN VIEW_JC_IMPOSTO_NFSE I ON B.RECNUM = I.RECNUM
      LEFT JOIN VIEW_JC_CARTAO_MKT CM ON B.RECNUM = CM.RECNUM
      LEFT JOIN VIEW_JC_LANC_EMP_CONTA_BANCO LE ON B.RECNUM = LE.RECNUM
      LEFT JOIN VIEW_JC_LANC_ALUGUEL_CARTAO A ON B.RECNUM = A.RECNUM
      LEFT JOIN VIEW_JC_LANC_MUTUOS M ON B.RECNUM = M.RECNUM
      LEFT JOIN VIEW_JC_LANC_VERBA_AVULSA V ON B.RECNUM = V.RECNUM
     WHERE NOT (B.CODCONTA = 37
       AND B.CODROTINABAIXA = 631)
       AND B.NUMTRANS NOT IN (
        200630
    )
     /*CORRECAO ERRO*/
       AND NOT ((B.CODBANCO = 14
       AND B.CODCONTA = 300102)
        OR (B.CODBANCO = 15
       AND B.CODCONTA = 300101)
        OR (B.CODBANCO = 63
       AND B.CODCONTA = 300301)
        OR (B.CODCONTA = 620112
       AND B.VPAGO < 0))
       /*RETIRAR PS LANÇAMENTOS DE CONTRAPARTIDA DOS MUTUOS, POIS ESSES JA MOVIMENTARAM O BANCO*/
      /*FILTROS NAS VIEW RELACIONADAS--*/
       AND AF.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE ADIANTAMENTO AO FORNECEDOR*/
       AND AB.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE BAIXA DO ADIANTAMENTO AO FORNECEDOR*/
       AND T.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE DESCONTO FINANCEIRO E JUROS PARA NÃO DUPLICAR*/
       AND I.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE IMPOSTOS DE NOTAS DE SERVICOS E FUNCIONARIOS*/
       AND CM.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE CARTÃO DE CREDITO E NOTAS DE COMISSAO*/
       AND LE.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE EMPRESAS COM BANCOS DE OUTRA EMPRESA*/
       AND A.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE ALUGUEL DE MAQUINA DE CARTAO*/
       AND M.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DOS CAIXAS DOS MUTUOS*/
       AND V.RECNUM IS NULL
     /*RETIRAR LAÇAMENTOS DE VERBAS AVULSAS RECEBIDAS COMO DINHEIRO*/;
/