CREATE OR REPLACE VIEW VIEW_JC_LANC_DESC_OBTIDO AS
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
                           OR L.DUPLIC = '0' THEN 'DESC FIN Nº ' || L.NUMNOTA || ' - ' || L.HISTORICO
                       ELSE 'DESC FIN Nº ' || L.NUMNOTA || '-' || L.DUPLIC || ' - ' || L.HISTORICO
                   END
               ) HISTORICO
          FROM PCLANC L
         INNER JOIN VIEW_JC_LANC_BASE B ON L.RECNUM = B.RECNUM
         INNER JOIN VIEW_JC_LANC_DESCJUR_DEVIDOS D ON L.RECNUM = D.RECNUMBAIXA
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
              HISTORICO;
/