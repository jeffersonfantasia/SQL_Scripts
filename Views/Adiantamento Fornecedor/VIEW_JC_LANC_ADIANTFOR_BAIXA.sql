CREATE OR REPLACE VIEW VIEW_JC_LANC_ADIANTFOR_BAIXA AS
    WITH LANC_CONCILIADO AS (
        SELECT RECNUMPAGTO
          FROM PCLANCADIANTFORNEC
    )
     /*PARA TRAZER SOMENTE LANCAMENTOS QUE FORAM ADIANTAMENTOS PARA FORNECEDOR*/
    SELECT L.CODFILIAL,
           L.RECNUM,
           L.VPAGO,
     /*SE O VALOR FOR  > 0 ENT�O HOUVE O CONCILIACAO, SE FOR < 0 HOUVE DESCONTO FINANCEIRO*/
           (
               CASE
                   WHEN L.VPAGO < 0 THEN NVL (L.VPAGO, 0) * - 1
                   ELSE L.VPAGO
               END
           ) AS VALOR,
     /*TRANSFORMAR OS VALORES NEGATIVOS PARA ARQUIVO CONTABILIDADE*/
           L.DTPAGTO AS DATA,
           L.CODCONTA,
           L.CODFORNEC,
           L.TIPOPARCEIRO,
           (
               CASE
                   WHEN L.VPAGO < 0 THEN (L.RECNUM || ' - ' || 'DESC. - NF ' || L.NUMNOTA || ' - ' || F.FORNECEDOR || ' - ' || L.
                   HISTORICO)
                   ELSE (L.RECNUM || ' - ' || 'BX ADIANT. - NF ' || L.NUMNOTA || ' - ' || F.FORNECEDOR || ' - ' || L.HISTORICO)
               END
           ) HISTORICO
      FROM PCLANC L
     INNER JOIN LANC_CONCILIADO C
     /*PARA TRAZER SOMENTE LANCAMENTOS QUE FORAM ADIANTAMENTOS PARA FORNECEDOR*/
      ON L.RECNUM = C.RECNUMPAGTO
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
     WHERE L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
       AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
       AND L.NUMTRANS IS NULL
     /*LANCAMENTO QUE NAO HOUVE MOVIMENTACAO DE NUMERARIOS*/
       ;
/