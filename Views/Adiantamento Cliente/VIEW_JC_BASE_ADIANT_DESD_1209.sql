CREATE OR REPLACE VIEW VIEW_JC_BASE_ADIANT_DESD_1209 AS
  SELECT C.CODFILIAL,
         C.DTLANC,
         C.DTDESCONTO,
         C.NUMCRED,
         C.CODIGO AS CODCRED,
         C.NUMTRANS,
         C.NUMTRANSBAIXA,
         C.NUMTRANSVENDADESC,
         C.NUMNOTADESC,
         C.NUMLANCBAIXA,
         C.CODMOVIMENTO,
         C.CODCLI,
         C.VALOR
    FROM PCCRECLI C
   INNER JOIN VIEW_JC_ADIANT_CLIENT_RECEBIDO V ON C.NUMTRANS = V.NUMTRANSACAO
   WHERE C.CODROTINA = 1209
     AND C.NUMTRANSVENDADESC IS NULL
     AND C.VALOR > 0;
/