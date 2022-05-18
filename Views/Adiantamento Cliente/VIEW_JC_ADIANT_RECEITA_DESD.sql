CREATE OR REPLACE VIEW VIEW_JC_ADIANT_RECEITA_DESD AS 
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
       'RD' AS TIPO,
       ('N� LANC. ' || C.NUMLANCBAIXA || ' - RECEITA CRED ' || C.NUMCRED || ' - ' || T.CLIENTE) AS HISTORICO
  FROM PCCRECLI C
 INNER JOIN VIEW_JC_BASE_ADIANT_DESDOBRE D ON C.NUMCRED = D.NUMCRED
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  LEFT JOIN VIEW_JC_ADIANT_RECEITA_SIMPLES V ON C.CODIGO = V.CODCRED
 WHERE C.NUMLANCBAIXA IS NOT NULL
 --RETIRAR REGISTROS J� BAIXADOS NA VIEW DE RECEITA SIMPLES
 AND V.CODCRED IS NULL;
 /