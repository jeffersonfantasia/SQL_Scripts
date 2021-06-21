CREATE OR REPLACE VIEW VIEW_JC_LANC_MUTUOS AS
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
           (B.RECNUM || ' - ' || B.HISTORICO) AS HISTORICO
      FROM VIEW_JC_LANC_BASE B
     WHERE B.CODBANCO IN (
        14, 15, 63
    )
        /*SOMENTE BANCOS DOS MUTUOS E EMPRESTIMOS BANCARIOS*/
       AND NOT ((B.CODBANCO = 14
       AND B.CODCONTA = 300102)
        OR (B.CODBANCO = 15
       AND B.CODCONTA = 300101)
        OR (B.CODCONTA = 300301
       AND B.CODBANCO = 63))
     /*RETIRAR LANCAMENTOS DE APORTE E PAGAMENTO*/;
/