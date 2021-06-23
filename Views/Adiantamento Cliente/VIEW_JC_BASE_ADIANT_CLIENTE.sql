CREATE OR REPLACE VIEW VIEW_JC_BASE_ADIANT_CLIENTE AS
    SELECT C.CODFILIAL,
           C.DTLANC,
           C.CODIGO AS CODCRED,
     /*USADO NA CONSTRUCAO DA VIEW_JC_PCPREST_BAIXA_CRED*/
           C.NUMTRANS,
           C.NUMTRANSBAIXA,
           C.CODMOVIMENTO,
           C.VALOR AS VLPAGO,
           (
               CASE
                   WHEN C.VALOR < 0 THEN C.VALOR * - 1
                   ELSE C.VALOR
               END
           ) AS VALOR,
     /*TRANSFORMAR OS VALORES NEGATIVOS PARA ARQUIVO CONTABILIDADE*/
           T.CLIENTE
      FROM PCCRECLI C
      LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.NUMERARIO = 'S';
/