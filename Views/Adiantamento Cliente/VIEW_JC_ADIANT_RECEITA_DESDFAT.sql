CREATE OR REPLACE VIEW VIEW_JC_ADIANT_RECEITA_DESDFAT AS
SELECT C.CODFILIAL,
       C.DTLANC AS DATA,
       C.CODIGO AS CODCRED,
       C.NUMCRED,
       '' AS CODCONTAB,
       0 AS CODCONTABILBANCO,
       C.NUMLANCBAIXA AS NUMTRANSACAO,
       C.NUMTRANS,
       (CASE
         WHEN C.VALOR < 0 THEN
          C.VALOR * -1
         ELSE
          C.VALOR
       END) AS VALOR,
       'RDF' AS TIPO,
       ('N� LANC. ' || C.NUMLANCBAIXA || ' - RECEITA CRED ' || C.NUMCRED || ' - ' || T.CLIENTE) AS HISTORICO
  FROM PCCRECLI C
 INNER JOIN  VIEW_JC_BASE_ADIANT_DESD_FAT D ON C.NUMCRED = D.NUMCRED
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  LEFT JOIN VIEW_JC_ADIANT_RECEITA_SIMPLES V ON C.CODIGO = V.CODCRED
  LEFT JOIN VIEW_JC_ADIANT_RECEITA_DESD S ON C.CODIGO = S.CODCRED
  LEFT JOIN VIEW_JC_ADIANT_RECEITA_DESD_TW W ON C.CODIGO = W.CODCRED
  LEFT JOIN VIEW_JC_ADIANT_DES_DUP_RECEITA R ON C.CODIGO = R.CODCRED
 WHERE C.NUMLANCBAIXA IS NOT NULL
 --RETIRAR REGISTROS J� BAIXADOS NAS VIEWS DE RECEITA SIMPLES / DESDOBRADO / DESDOBRADO TWICE
 AND V.CODCRED IS NULL
 AND S.CODCRED IS NULL
 AND W.CODCRED IS NULL
 AND R.CODCRED IS NULL;
 /