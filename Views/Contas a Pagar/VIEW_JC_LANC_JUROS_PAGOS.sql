CREATE OR REPLACE VIEW VIEW_JC_LANC_JUROS_PAGOS AS
    SELECT *
      FROM (
        SELECT B.CODFILIAL,
               B.RECNUM,
               B.VPAGO,
               B.TXPERM AS VALOR,
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
                       WHEN B.DUPLIC IS NULL
                           OR B.DUPLIC = '0' THEN 'JUR Nº ' || B.NUMNOTA || ' - ' || B.HISTORICO
                       ELSE 'JUR Nº ' || B.NUMNOTA || '-' || B.DUPLIC || ' - ' || B.HISTORICO
                   END
               ) HISTORICO
          FROM VIEW_JC_LANC_BASE B
         INNER JOIN VIEW_JC_LANC_DESCJUR_DEVIDOS D ON B.RECNUM = D.RECNUMBAIXA
         WHERE B.TXPERM > 0
     /*SOMENTE REGISTROS COM JUROS PAGOS*/
           AND D.HISTORICO LIKE 'JUROS%'
     /*PARA TERMOS SOMENTE O LANCAMENTO DE JUROS E NAO DE DESCONTO, IMPEDINDO DUPLICIDADE*/
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