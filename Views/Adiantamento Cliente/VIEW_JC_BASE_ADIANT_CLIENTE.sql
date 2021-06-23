CREATE OR REPLACE VIEW VIEW_JC_BASE_ADIANT_CLIENTE AS
    SELECT C.CODFILIAL,
           C.DTLANC,
           C.DTESTORNO,
           C.CODIGO AS CODCRED,
     /*USADO NA CONSTRUCAO DA VIEW_JC_PCPREST_BAIXA_CRED*/
           C.NUMTRANS,
           C.NUMTRANSBAIXA,
           C.CODMOVIMENTO,
           C.HISTORICO,
           C.NUMCRED,
           C.VALOR AS VLPAGO,
           (
               CASE
                   WHEN C.VALOR < 0 THEN C.VALOR * - 1
                   ELSE C.VALOR
               END
           ) AS VALOR,
     /*TRANSFORMAR OS VALORES NEGATIVOS PARA ARQUIVO CONTABILIDADE*/
           T.CLIENTE,
           C.CODROTINA
      FROM PCCRECLI C
      LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.NUMERARIO = 'S'
       AND C.CODMOVIMENTO IS NOT NULL
       AND (C.NUMTRANS IS NOT NULL
        OR C.NUMTRANSBAIXA IS NOT NULL);
/