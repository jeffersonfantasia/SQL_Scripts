CREATE OR REPLACE VIEW VIEW_JC_LANC_DESCJUR_DEVIDOS AS
    WITH DESC_JUR_FINANC_INDEVIDO AS
     /*SELECAO DOS LANCAMENTOS DE IMPOSTOS QUE TIVERAM DESCONTO OU JUROS*/ (
        SELECT T.RECNUM
          FROM VIEW_JC_LANC_DESC_JUR T
         WHERE T.HISTORICO2 IN (
            TRIM ('ISS'), TRIM ('CSRF'), TRIM ('IRRF'), TRIM ('INSS')
        )
    ), DESC_FINANC_CONTAS_GERENCIAIS AS
          /*SELECAO DOS LANCAMENTOS DE DESCONTOS QUE DEVERÃO SER DESCONSIDERADOS*/ (
        SELECT T.RECNUM
          FROM VIEW_JC_LANC_DESC_JUR T
         WHERE T.DESCONTOFIN > 0        
     /*SOMENTE LANCAMENTOS QUE POSSUEM DESCONTO*/
           AND T.CODCONTA IN (
            100003, 410105, 530102, 530106, 545102
        )
    /* CONSIDERAR CONTAS GERENCIAIS LISTADAS PARA RETIRAR ESSES DESCONTOS POSTERIOR*/
    )
    SELECT L.RECNUMBAIXA,
           L.HISTORICO
      FROM PCLANC L
      LEFT JOIN DESC_JUR_FINANC_INDEVIDO I ON L.RECNUMBAIXA = I.RECNUM
      LEFT JOIN DESC_FINANC_CONTAS_GERENCIAIS G ON L.RECNUMBAIXA = G.RECNUM
     WHERE (L.RECNUMBAIXA IS NOT NULL
       AND L.RECNUMBAIXA <> 0)
     /*LANCAMENTOS UTILIZADOS COMO DESCONTO OU JUROS EM OUTROS LANÇAMENTOS*/
       AND L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
       AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
       AND (L.NUMTRANSADIANTFOR IS NULL
        OR L.NUMTRANSADIANTFOR = 0)
     /*RETIRAR LANÇAMENTOS PARA EVITAR DUPLICIDADE COM LANÇAMENTOS 100% DE DESCONTO*/
       AND I.RECNUM IS NULL
       AND G.RECNUM IS NULL;
/