CREATE OR REPLACE VIEW VIEW_JC_LANC_DESC_OBTIDO AS
    SELECT *
      FROM (
        SELECT B.CODFILIAL,
               B.RECNUM,
               B.VPAGO,
               B.DESCONTOFIN AS VALOR,
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
                       WHEN B.DUPLIC IS NULL
                           OR B.DUPLIC = '0' THEN 'DESC FIN Nº ' || B.NUMNOTA || ' - ' || B.HISTORICO
                       ELSE 'DESC FIN Nº ' || B.NUMNOTA || '-' || B.DUPLIC || ' - ' || B.HISTORICO
                   END
               ) HISTORICO
          FROM VIEW_JC_LANC_BASE B
         INNER JOIN VIEW_JC_LANC_DESCJUR_DEVIDOS D ON B.RECNUM = D.RECNUMBAIXA
         WHERE B.DESCONTOFIN > 0
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
              HISTORICO;
/