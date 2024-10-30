CREATE OR REPLACE VIEW VIEW_JC_LANC_ALUGUEL_CARTAO AS
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
           (
               CASE B.TIPOPARCEIRO
                   WHEN 'F'   THEN F.CODCONTAB
                   WHEN 'C'   THEN C.CODCONTAB
                   ELSE NULL
               END
           ) AS CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           'A' AS TIPO,
           (
               CASE B.TIPOPARCEIRO
                   WHEN 'F'   THEN (B.RECNUM || ' - ' || F.FORNECEDOR || ' - ' || B.HISTORICO)
                   WHEN 'C'   THEN (B.RECNUM || ' - ' || C.CLIENTE || ' - ' || B.HISTORICO)
                   ELSE (B.RECNUM || ' - ' || B.HISTORICO)
               END
           ) AS HISTORICO
      FROM VIEW_JC_LANC_BASE B
      LEFT JOIN PCFORNEC F ON B.CODFORNEC = F.CODFORNEC
      LEFT JOIN PCCLIENT C ON B.CODFORNEC = C.CODCLI
     WHERE B.CODCONTA IN (3203, 3654, 4118, 620105, 620115)
         /*SOMENTE LANCAMENTOS DE TAXAS DE CARTAO*/;
/
