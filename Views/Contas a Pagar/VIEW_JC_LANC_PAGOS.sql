CREATE OR REPLACE VIEW VIEW_JC_LANC_PAGOS AS
    WITH TODOS_LANC_COM_DESCONTO_JUROS AS (
        SELECT L.RECNUM
          FROM PCLANC L
         WHERE (L.DESCONTOFIN > 0
            OR L.TXPERM > 0)
     /*SOMENTE LANCAMENTOS QUE POSSUEM DESCONTO OU JUROS*/
           AND L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
           AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
    ), TODOS_LANC_FINANCEIROJUR AS
     /*SELECAO DE TODOS OS LANCAMENTOS DE DESCONTOS E JUROS*/ (
        SELECT L.RECNUM
          FROM PCLANC L
         INNER JOIN TODOS_LANC_COM_DESCONTO_JUROS T ON L.RECNUMBAIXA = T.RECNUM
    ), DESC_JUR_FINANC_INDEVIDO AS
     /*SELECAO DOS LANCAMENTOS DE IMPOSTOS QUE TIVERAM DESCONTO OU JUROS*/ (
        SELECT L.RECNUM
          FROM PCLANC L
         WHERE (L.DESCONTOFIN > 0
            OR L.TXPERM > 0)
     /*SOMENTE LANCAMENTOS QUE POSSUEM DESCONTO OU JUROS*/
           AND L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
           AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
           AND L.HISTORICO2 IN (
            TRIM ('ISS'), TRIM ('CSRF'), TRIM ('IRRF'), TRIM ('INSS')
        )
    ), DESC_FINANC_CONTAS_GERENCIAIS AS
          /*SELECAO DOS LANCAMENTOS DE DESCONTOS QUE DEVER�O SER DESCONSIDERADOS*/ (
        SELECT L.RECNUM
          FROM PCLANC L
         WHERE (L.DESCONTOFIN > 0)            
     /*SOMENTE LANCAMENTOS QUE POSSUEM DESCONTO OU JUROS*/
           AND L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
           AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
           AND L.CODCONTA IN (
            100003, 410105, 530102, 530106, 545102, 545104
        )
    /* CONSIDERAR CONTAS GERENCIAIS LISTADAS PARA RETIRAR ESSES DESCONTOS POSTERIOR*/
    ), DESCONTOFINANCEIROJUR AS
     /*SELECAO DOS LANCAMENTOS DE DESCONTOS E JUROS VALIDOS*/ (
        SELECT L.RECNUMBAIXA,
               L.RECNUM,
               L.HISTORICO
          FROM PCLANC L
          LEFT JOIN DESC_JUR_FINANC_INDEVIDO I ON L.RECNUMBAIXA = I.RECNUM
          LEFT JOIN DESC_FINANC_CONTAS_GERENCIAIS G ON L.RECNUMBAIXA = G.RECNUM
         WHERE (L.RECNUMBAIXA IS NOT NULL
           AND L.RECNUMBAIXA <> 0)
     /*LANCAMENTOS UTILIZADOS COMO DESCONTO OU JUROS EM OUTROS LAN�AMENTOS*/
           AND L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
           AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
           AND (L.NUMTRANSADIANTFOR IS NULL
            OR NUMTRANSADIANTFOR = 0)
     /*RETIRAR LAN�AMENTOS ORIUNDOS DO PROCESSO DE ADIANTAMENTO AO FORNECEDOR*/
           AND I.RECNUM IS NULL
           AND G.RECNUM IS NULL
    ), BANCOS_EMPRESA AS (
        SELECT CODBANCO,
               (
                   CASE
                       WHEN CODFILIAL IN (
                           1, 2, 7, 99
                       ) THEN '1'
                       ELSE CODFILIAL
                   END
               ) AS CODEMPRESA
          FROM PCBANCO
    ), LANCAMENTOS_EMPRESA AS (
        SELECT RECNUM,
               (
                   CASE
                       WHEN CODFILIAL IN (
                           1, 2, 7
                       ) THEN '1'
                       ELSE CODFILIAL
                   END
               ) AS CODEMPRESA
          FROM PCLANC
         WHERE TIPOPARCEIRO = 'F'
    ), BASEPCLANC AS (
        SELECT L.CODFILIAL,
               L.RECNUM,
               L.RECNUMPRINC,
               L.VPAGO,
     /*USADO COMO CONDICIONAL DENTRO DO BI*/
               (
                   CASE
                       WHEN L.VPAGO < 0 THEN NVL (L.VPAGO, 0) * - 1
                       ELSE (
                           CASE
                               WHEN (L.VPAGOBORDERO IS NOT NULL
                                   OR L.VPAGOBORDERO > 0) THEN
                                   CASE
                                       WHEN L.VPAGO > L.VPAGOBORDERO THEN
     /*TRAZER O VALOR DO BORDERO PARA QUE BATA O VALOR COM O EXTRATO BANCARIO*/ (L.VPAGOBORDERO - NVL (L.TXPERM, 0))
     /*AO TIRARMOS O JUROS NAO TRAZERMOS DUPLICIDADE NO VALOR PAGO*/
                                       ELSE L.VPAGO
                                   END
                               ELSE L.VPAGO
                           END
                       )
                   END
               ) AS VALOR,
     /*TRANSFORMAR OS VALORES NEGATIVOS PARA ARQUIVO CONTABILIDADE*/
               L.DTCOMPETENCIA,
               L.DTPAGTO,
               M.DTCOMPENSACAO,
               B.CODFILIAL AS CODFILIALBANCO,
               B.NOME,
               M.CODBANCO,
               B.CODCONTABIL AS CODCONTABILBANCO,
               L.CODCONTA,
               C.GRUPOCONTA,
               L.CODFORNEC,
               L.TIPOPARCEIRO,
               L.NUMTRANS
          FROM PCLANC L
         INNER JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
          LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
          LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
         WHERE NVL (L.INDICE, 0) NOT IN (
            'B'
        )
     /*LAN�AMENTOS ORIUNDOS DA MOVIMETA��O DE ESTOQUE E CUSTO*/
           AND L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
           AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
           AND NVL (L.CODROTINABAIXA, 0) NOT IN (
            1207, 1502, 1503, 9806
        )
     /*NAO CONSIDERAR LANCAMENTOS ORIGINADOS DA BAIXA DE DUPLICATA PARA N�O DUPLICAR*/
           AND NVL (M.CODBANCO, 0) NOT IN (
            17, 20, 35, 50, 52, 53, 54, 40, 41
        )
     /*BANCOS DE BONIFICACAO, ACERTO MOTORISTA, EXTRAVIO DE MERCADORIA, COMISSAO MKT E CARTAO DE CREDITO*/
           AND M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
           AND NVL (M.CODROTINALANC, 0) NOT IN (
            1209
        )
     /*NAO CONSIDERAR MOVIMENTACOES QUE FORAM ESTORNADAS*/
           AND NVL (L.CODCONTA, 0) NOT IN (
            105, 100022, 100024, 100027
        )
     /*NAO CONSIDERAR LANCAMENTOS DE DEVOLU��O, DE ACERTO DE SALDO NO INICIO, LANCAMENTOS NF MAE, E DE CONTRAPARTIDA PARA COMPRA DE FUNCIONARIOS*/
           AND NVL (C.GRUPOCONTA, 0) NOT IN (
            680
        )
     /*NAO CONSIDERAR LANCAMENTOS ORIUNDOS DE VERBAS*/
           AND NOT (L.CODCONTA IN (
            620108
        )
           AND B.CODFILIAL IN (
            99
        ))
     /*RETIRAR LANCAMENTOS DE TAXAS E DESCONTOS DE MARKETPLACES*/
    ), PCLANC_EMPRESAS_DIFERENTES AS (
        SELECT B.CODFILIAL,
               B.RECNUM,
               B.VPAGO,
               (
                   CASE
                       WHEN B.VPAGO < 0 THEN (B.VPAGO * - 1)
                       ELSE B.VPAGO
                   END
               ) AS VALOR,
               B.DTCOMPETENCIA,
               B.DTPAGTO,
               B.DTCOMPETENCIA AS DTCOMPENSACAO,
               B.CODFILIALBANCO,
               B.CODBANCO,
               B.CODCONTABILBANCO,
               B.CODCONTA,
               B.GRUPOCONTA,
               B.CODFORNEC,
               '' AS CODCONTABCLIENTE,
               B.TIPOPARCEIRO,
               B.NUMTRANS
          FROM PCLANC L
         INNER JOIN BASEPCLANC B ON L.RECNUM = B.RECNUM
         INNER JOIN BANCOS_EMPRESA S ON B.CODBANCO = S.CODBANCO
         INNER JOIN LANCAMENTOS_EMPRESA T ON B.RECNUM = T.RECNUM
         WHERE S.CODEMPRESA <> T.CODEMPRESA
     /*SOMENTE LANCAMENTO ENTRE EMPRESAS DIFERENTES*/
    ), ALUGUEL_CARTAO AS (
        SELECT B.CODFILIAL,
               B.RECNUM,
               B.VPAGO,
               B.VALOR,
               B.DTCOMPETENCIA,
               B.DTPAGTO,
               B.DTCOMPETENCIA AS DTCOMPENSACAO,
               B.CODFILIALBANCO,
               B.CODBANCO,
               B.CODCONTABILBANCO,
               B.CODCONTA,
               B.GRUPOCONTA,
               B.CODFORNEC,
               F.FORNECEDOR,
               C.CLIENTE,
               (
                   CASE B.TIPOPARCEIRO
                       WHEN 'F'   THEN F.CODCONTAB
                       WHEN 'C'   THEN C.CODCONTAB
                       ELSE NULL
                   END
               ) AS CODCONTABCLIENTE,
               B.TIPOPARCEIRO,
               B.NUMTRANS
          FROM PCLANC L
         INNER JOIN BASEPCLANC B ON L.RECNUM = B.RECNUM
          LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
          LEFT JOIN PCCLIENT C ON L.CODFORNEC = C.CODCLI
         WHERE L.CODCONTA = 620105
     /*SOMENTE LANCAMENTOS DE TAXAS DE CARTAO*/
    ), MUTUOS AS (
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
               B.NUMTRANS
          FROM PCLANC L
         INNER JOIN BASEPCLANC B ON L.RECNUM = B.RECNUM
         WHERE B.CODBANCO IN (
            14, 15
        )
     /*SOMENTE BANCOS DOS MUTUOS*/
    ), VERBAS_AVULSAS AS (
        SELECT L.CODFILIAL,
               L.RECNUM,
               L.VPAGO,
               (
                   CASE
                       WHEN L.VPAGO < 0 THEN (L.VPAGO * - 1)
                       ELSE L.VPAGO
                   END
               ) AS VALOR,
               L.DTCOMPETENCIA,
               L.DTPAGTO,
               M.DTCOMPENSACAO,
               M.CODFILIAL AS CODFILIALBANCO,
               M.CODBANCO,
               B.CODCONTABIL AS CODCONTABILBANCO,
               L.CODCONTA,
               C.GRUPOCONTA,
               L.CODFORNEC,
               '' AS CODCONTABCLIENTE,
               L.TIPOPARCEIRO,
               L.NUMTRANS
          FROM PCLANC L
         INNER JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
          LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
          LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
          LEFT JOIN VIEW_JC_DEVFORNEC_PAGTO D ON L.RECNUM = D.RECNUM
         WHERE L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
           AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
           AND M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
           AND M.CODROTINALANC NOT IN (
            1209
        )
     /*NAO CONSIDERAR MOVIMENTACOES QUE FORAM ESTORNADAS*/
           AND L.DTPAGTO IS NOT NULL
     /*APENAS LANCAMENTOS PAGOS*/
           AND M.CODBANCO NOT IN (
            17, 20, 35, 50, 52, 53, 54, 40, 41
        )
     /*BANCOS DE BONIFICACAO, ACERTO MOTORISTA, EXTRAVIO DE MERCADORIA, COMISSAO MKT E CARTAO DE CREDITO*/
           AND L.CODROTINABAIXA = '1803'
     /*SOMENTE VERBAS RECEBIDAS EM DINHEIRO*/
           AND D.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE VERBAS COM ORIGEM EM DEVOLUCAO A FORNECEDOR RECEBIDAS COMO DINHEIRO*/
    )
/*--DESCONTOS FINACEIROS OBTIDOS--*/
    SELECT *
      FROM (
        SELECT B.CODFILIAL,
               B.RECNUM,
               B.VPAGO,
               L.DESCONTOFIN AS VALOR,
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
               'D' AS TIPO,
               (
                   CASE
                       WHEN L.DUPLIC IS NULL
                           OR L.DUPLIC = '0' THEN 'DESC FIN N� ' || L.NUMNOTA || ' - ' || L.HISTORICO
                       ELSE 'DESC FIN N� ' || L.NUMNOTA || '-' || L.DUPLIC || ' - ' || L.HISTORICO
                   END
               ) HISTORICO
          FROM PCLANC L
         INNER JOIN BASEPCLANC B ON L.RECNUM = B.RECNUM
         INNER JOIN DESCONTOFINANCEIROJUR D ON L.RECNUM = D.RECNUMBAIXA
         WHERE L.DESCONTOFIN > 0
     /*SOMENTE REGISTROS COM DESCONTO FINANCEIRO*/
           AND D.HISTORICO LIKE 'DESCONTO%'
     /*PARA TERMOS SOMENTE O LANCAMENTO DE DESCONTO E NAO DE JUROS, IMPEDINDO DUPLICIDADE*/
    )
     GROUP BY CODFILIAL,
              RECNUM,
              VPAGO,
              VALOR,
              DTCOMPETENCIA,
              DTPAGTO,
              DTCOMPENSACAO,
              CODFILIALBANCO,
              CODBANCO,
              CODCONTABILBANCO,
              CODCONTA,
              GRUPOCONTA,
              CODFORNEC,
              CODCONTABCLIENTE,
              TIPOPARCEIRO,
              NUMTRANS,
              TIPO,
              HISTORICO
    UNION ALL
/*--DESCONTOS FINACEIROS INTEGRAIS OBTIDOS--*/
    SELECT L.CODFILIAL,
           L.RECNUM,
           L.VPAGO,
           L.DESCONTOFIN AS VALOR,
           L.DTCOMPETENCIA,
           L.DTPAGTO,
           TO_DATE ('') AS DTCOMPENSACAO,
           '' AS CODFILIALBANCO,
           TO_NUMBER ('') AS CODBANCO,
           TO_NUMBER ('') AS CODCONTABILBANCO,
           L.CODCONTA,
           C.GRUPOCONTA,
           L.CODFORNEC,
           '' AS CODCONTABCLIENTE,
           L.TIPOPARCEIRO,
           L.NUMTRANS,
           'D' AS TIPO,
           (
               CASE
                   WHEN L.DUPLIC IS NULL
                       OR L.DUPLIC = '0' THEN 'DESC FIN N� ' || L.NUMNOTA || ' - ' || L.HISTORICO
                   ELSE 'DESC FIN N� ' || L.NUMNOTA || '-' || L.DUPLIC || ' - ' || L.HISTORICO
               END
           ) HISTORICO
      FROM PCLANC L
      LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
     WHERE L.DESCONTOFIN > 0
 /*SOMENTE LANCAMENTOS QUE POSSUEM DESCONTO OU JUROS*/
       AND L.DTCANCEL IS NULL
      /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
       AND L.DTESTORNOBAIXA IS NULL
/*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
       AND L.DTPAGTO IS NOT NULL
     /*CONSIDERAR LANCAMENTOS PAGOS APENAS*/
       AND L.NUMTRANS IS NULL
     /*SOMEMNTE LAN�AMENTOS SEM NUMTRANS PREECHIDO*/
    UNION ALL
/*JUROS PAGOS A FORNECEDOR--*/
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           L.TXPERM AS VALOR,
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
           'J' AS TIPO,
           (
               CASE
                   WHEN L.DUPLIC IS NULL
                       OR L.DUPLIC = '0' THEN 'JUR N� ' || L.NUMNOTA || ' - ' || L.HISTORICO
                   ELSE 'JUR N� ' || L.NUMNOTA || '-' || L.DUPLIC || ' - ' || L.HISTORICO
               END
           ) HISTORICO
      FROM PCLANC L
     INNER JOIN BASEPCLANC B ON L.RECNUM = B.RECNUM
     INNER JOIN DESCONTOFINANCEIROJUR D ON L.RECNUM = D.RECNUMBAIXA
     WHERE L.TXPERM > 0
     /*SOMENTE REGISTROS COM JUROS PAGOS*/
       AND D.HISTORICO LIKE 'JUROS%'
     /*PARA TERMOS SOMENTE O LANCAMENTO DE JUROS E NAO DE DESCONTO, IMPEDINDO DUPLICIDADE*/
    UNION ALL
/*DEMAIS LANCAMENTOS FILTRADOS NA PCLANC--*/
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
                   WHEN L.NUMNOTA IS NULL
                       OR L.NUMNOTA = '0' THEN
                       CASE
                           WHEN L.CODCONTA IN (
                               610101, 620110, 620111, 650101
                           ) THEN
     /*RENDIMENTOS, IR, IOF, TARIFAS*/ L.HISTORICO || ' - ' || B.NOME
                           ELSE L.RECNUM || ' - ' || L.HISTORICO
                       END
                   WHEN L.DUPLIC IS NULL
                       OR L.DUPLIC = '0' THEN 'NF ' || L.NUMNOTA || ' - ' || L.HISTORICO
                   ELSE 'NF ' || L.NUMNOTA || ' - ' || L.DUPLIC || ' - ' || L.HISTORICO
               END
           ) HISTORICO
      FROM PCLANC L
     INNER JOIN BASEPCLANC B ON L.RECNUM = B.RECNUM
      LEFT JOIN VIEW_JC_LANC_ADIANTAMENTOFOR AF ON L.RECNUM = AF.RECNUM
      LEFT JOIN VIEW_JC_LANC_ADIANTFOR_BAIXA AB ON L.RECNUM = AB.RECNUM
      LEFT JOIN TODOS_LANC_FINANCEIROJUR T ON L.RECNUM = T.RECNUM
      LEFT JOIN VIEW_JC_IMPOSTO_NFSE I ON L.RECNUM = I.RECNUM
      LEFT JOIN VIEW_JC_CARTAO_MKT CM ON L.RECNUM = CM.RECNUM
      LEFT JOIN PCLANC_EMPRESAS_DIFERENTES LE ON L.RECNUM = LE.RECNUM
      LEFT JOIN ALUGUEL_CARTAO A ON L.RECNUM = A.RECNUM
      LEFT JOIN MUTUOS M ON L.RECNUM = M.RECNUM
      LEFT JOIN VERBAS_AVULSAS V ON L.RECNUM = V.RECNUM
     WHERE NOT (L.CODCONTA = 37
       AND L.CODROTINABAIXA = 631)
      /*FILTROS NAS VIEW RELACIONADAS--*/
       AND AF.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE ADIANTAMENTO AO FORNECEDOR*/
       AND AB.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE BAIXA DO ADIANTAMENTO AO FORNECEDOR*/
       AND T.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE DESCONTO FINANCEIRO E JUROS PARA N�O DUPLICAR*/
       AND I.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE IMPOSTOS DE NOTAS DE SERVICOS E FUNCIONARIOS*/
       AND CM.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE CART�O DE CREDITO E NOTAS DE COMISSAO*/
       AND LE.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE EMPRESAS COM BANCOS DE OUTRA EMPRESA*/
       AND A.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DE ALUGUEL DE MAQUINA DE CARTAO*/
       AND M.RECNUM IS NULL
     /*RETIRAR LAN�AMENTOS DOS CAIXAS DOS MUTUOS*/
       AND V.RECNUM IS NULL
     /*RETIRAR LA�AMENTOS DE VERBAS AVULSAS RECEBIDAS COMO DINHEIRO*/
    UNION ALL
/*LANCAMENTOS DOS IMPOSTOS DAS NOTAS DE SERVICO E FUNCIONARIOS--*/
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           COALESCE (L.VPAGOBORDERO, B.VALOR) AS VALOR,
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
           'I' AS TIPO,
           (
               CASE
                   WHEN B.GRUPOCONTA NOT IN (
                       510, 515
                   ) THEN ('NFS ' || L.NUMNOTA || ' - ' || L.HISTORICO2 || ' - ' || F.FORNECEDOR)
                   ELSE (L.RECNUM || ' - ' || L.HISTORICO2 || ' - ' || L.HISTORICO)
               END
           ) AS HISTORICO
      FROM PCLANC L
     INNER JOIN BASEPCLANC B ON L.RECNUM = B.RECNUM
     INNER JOIN VIEW_JC_IMPOSTO_NFSE I ON L.RECNUM = I.RECNUM
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
    UNION ALL
/*LANCAMENTOS DE COMISSAO DOS MARKETPLACES--*/
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           (
               CASE
                   WHEN B.VPAGO < 0 THEN (B.VPAGO * - 1)
                   ELSE B.VPAGO
               END
           ) AS VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPETENCIA AS DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           B.CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           B.TIPO,
           B.HISTORICO
      FROM VIEW_JC_CARTAO_MKT B
     WHERE B.CODCONTABCLIENTE IS NOT NULL
     /*PARA TERMOS TODOS OS LANCAMENTOS QUE ENVOLVE COMISSAO DE MKT*/
       AND ((B.CODBANCO IN (
        40, 41
    )
       AND B.VPAGO < 0)
        OR (B.NUMTRANS = 0)
        OR (B.CODBANCO IN (
        36, 39
    )
       AND B.CODCONTA = 410104)
        OR (B.CODBANCO = 11
       AND B.CODCONTA = 620106))
     /*SOMENTE LANCAMENTOS DE PAGAMENTO DAS NOTAS E IMPOSTOS PARA DEDUZIR DO VALOR*/
    UNION ALL
/*LANCAMENTOS DOS PAGAMENTOS DE NFS COM CARTAO DE CREDITO--*/
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           (
               CASE
                   WHEN B.VPAGO < 0 THEN (B.VPAGO * - 1)
                   ELSE B.VPAGO
               END
           ) AS VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPETENCIA AS DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           B.CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           'C' AS TIPO,
           B.HISTORICO
      FROM VIEW_JC_CARTAO_MKT B
     WHERE B.CODBANCO IN (
        41
    )
     /*PARA TERMOS TODOS OS LANCAMENTOS QUE ENVOLVE CARTAO DE CREDITO*/
       AND (B.VPAGO < 0
     /*SOMENTE LANCAMENTOS DE PAGAMENTO DAS PARCELAS*/
        OR (B.TIPOPARCEIRO = 'O'
       AND B.VPAGO > 0))
     /*LANCAMENTOS DIRETO NA CONTA DE DESPESA*/
    UNION ALL
/*LANCAMENTOS ENTRE EMPRESAS DIFERENTES MOVIMENTANDO CONTA--*/
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           B.VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPETENCIA AS DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           '' AS CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           'EC' AS TIPO,
           L.HISTORICO
      FROM PCLANC L
     INNER JOIN PCLANC_EMPRESAS_DIFERENTES B ON L.RECNUM = B.RECNUM
    UNION ALL
/*LANCAMENTOS ENTRE EMPRESAS DIFERENTES MOVIMENTANDO BANCO--*/
    SELECT B.CODFILIALBANCO AS CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           B.VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPETENCIA AS DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           '' AS CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           'EB' AS TIPO,
           (B.RECNUM || ' - ENVIO EMPRESTIMOS A TERCEIROS') AS HISTORICO
      FROM PCLANC L
     INNER JOIN PCLANC_EMPRESAS_DIFERENTES B ON L.RECNUM = B.RECNUM
    UNION ALL
/*LANCAMENTOS REFERENTE A ALUGUEL DE MAQUINAS DE CART�O--*/
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           B.VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPETENCIA AS DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           B.CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           'A' AS TIPO,
           (
               CASE B.TIPOPARCEIRO
                   WHEN 'F'   THEN (B.RECNUM || ' - ' || B.FORNECEDOR || ' - ' || L.HISTORICO)
                   WHEN 'C'   THEN (B.RECNUM || ' - ' || B.CLIENTE || ' - ' || L.HISTORICO)
                   ELSE (B.RECNUM || ' - ' || L.HISTORICO)
               END
           ) AS HISTORICO
      FROM PCLANC L
     INNER JOIN ALUGUEL_CARTAO B ON L.RECNUM = B.RECNUM
    UNION ALL
/*LANCAMENTOS REFERENTE AOS MUTUOS--*/
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
           'MT' AS TIPO,
           (B.RECNUM || ' - ' || L.HISTORICO) AS HISTORICO
      FROM PCLANC L
     INNER JOIN MUTUOS B ON L.RECNUM = B.RECNUM
     WHERE NOT ((B.CODBANCO = 14
       AND B.CODCONTA = 300102)
        OR (B.CODBANCO = 15
       AND B.CODCONTA = 300101))
     /*RETIRAR LANCAMENTOS DE APORTE E PAGAMENTO*/
    UNION ALL
/*LANCAMENTOS VERBAS AVULSAS RECEBIDAS EM DINHEIRO--*/
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           (
               CASE
                   WHEN B.VPAGO < 0 THEN (B.VPAGO * - 1)
                   ELSE B.VPAGO
               END
           ) AS VALOR,
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
           'V' AS TIPO,
           (L.RECNUM || ' - VERBA FORNECEDOR - ' || L.HISTORICO) AS HISTORICO
      FROM PCLANC L
     INNER JOIN VERBAS_AVULSAS B ON L.RECNUM = B.RECNUM;
/