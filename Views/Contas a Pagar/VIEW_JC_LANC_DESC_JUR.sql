CREATE OR REPLACE VIEW VIEW_JC_LANC_DESC_JUR AS
    SELECT L.RECNUM,
           L.HISTORICO2,
           L.DESCONTOFIN,
           L.CODCONTA
      FROM PCLANC L
     WHERE (L.DESCONTOFIN > 0
        OR L.TXPERM > 0)
      /*SOMENTE LANCAMENTOS QUE POSSUEM DESCONTO OU JUROS*/
       AND L.DTCANCEL IS NULL
      /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
       AND L.DTESTORNOBAIXA IS NULL
/*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/;
/