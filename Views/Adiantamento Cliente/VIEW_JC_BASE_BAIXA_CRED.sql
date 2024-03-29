CREATE OR REPLACE VIEW VIEW_JC_BASE_BAIXA_CRED AS
    WITH ADIANT_REALIZADOS_VERIFICA_MES AS (
  /*RELACAO DOS ADIANTAMENTOS FEITOS COM OS CODIGOS UNICOS QUE S�O GERADOS*/
        SELECT C.CODIGO,
               (
                   CASE
                       WHEN ((TO_NUMBER (TO_CHAR (C.DTDESCONTO, 'YYYY') || TO_CHAR (C.DTDESCONTO, 'MM')) <> TO_NUMBER (TO_CHAR (C
                       .DTLANC, 'YYYY') || TO_CHAR (C.DTLANC, 'MM')))
                          AND C.DTESTORNO IS NOT NULL) THEN 1
                       ELSE 0
                   END
               ) AS VERIFICAR_DATA
          FROM PCCRECLI C
         INNER JOIN VIEW_JC_ADIANT_CLIENTE V ON C.NUMTRANS = V.NUMTRANS
         WHERE C.HISTORICO NOT LIKE 'DESDOBRAMENTO EM BAIXA%'
     /*RETIRAR LAN�AMENTOS DE DESDOBRAMENTO*/
    )
    SELECT C.CODFILIAL,
           C.DTESTORNO,
           C.DTLANC,
           C.DTDESCONTO,
           C.CODROTINA,
           C.ROTINABAIXA,
           C.CODIGO AS CODCRED,
           C.NUMCRED,
           C.NUMTRANS,
           C.NUMLANCBAIXA,
           C.NUMTRANSBAIXA,
           C.NUMTRANSVENDADESC AS NUMTRANSACAO,
           C.CODMOVIMENTO,
           T.CODCONTAB,
           B.CODCONTABIL AS CODCONTABILBANCO,
           C.VALOR AS VALOR_ORIG,
           (
               CASE
                   WHEN C.VALOR < 0 THEN (C.VALOR * - 1)
                   ELSE C.VALOR
               END
           ) AS VALOR,
           C.NUMNOTADESC,
           T.CGCENT CPF_CNPJ,
           T.CLIENTE,
           A.VERIFICAR_DATA
      FROM PCCRECLI C
     INNER JOIN ADIANT_REALIZADOS_VERIFICA_MES A ON C.CODIGO = A.CODIGO
      LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
      LEFT JOIN PCMOVCR M ON C.NUMTRANS = M.NUMTRANS
       AND M.DTESTORNO IS NULL
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO;
/