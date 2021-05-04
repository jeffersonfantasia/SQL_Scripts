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
                   WHEN 'F'   THEN (B.RECNUM || ' - ' || F.FORNECEDOR || ' - ' || L.HISTORICO)
                   WHEN 'C'   THEN (B.RECNUM || ' - ' || C.CLIENTE || ' - ' || L.HISTORICO)
                   ELSE (B.RECNUM || ' - ' || L.HISTORICO)
               END
           ) AS HISTORICO
      FROM PCLANC L
     INNER JOIN VIEW_JC_LANC_BASE B ON L.RECNUM = B.RECNUM
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
      LEFT JOIN PCCLIENT C ON L.CODFORNEC = C.CODCLI
     WHERE L.CODCONTA = 620105
         /*SOMENTE LANCAMENTOS DE TAXAS DE CARTAO*/;
/