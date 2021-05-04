CREATE OR REPLACE VIEW VIEW_JC_LANC_CARTAO_CORP AS
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
     /*LANCAMENTOS DIRETO NA CONTA DE DESPESA*/;
/