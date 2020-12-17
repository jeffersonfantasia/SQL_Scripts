/*PEGAR OS CREDITO EM ABERTO DA FILIAL QUE FORAM GERADOS ATRAV�S DE DEVOLU��O--*/
WITH CREDITOS_DEV AS (
    SELECT C.CODCLI AS CODCLICRED,
           T.CLIENTE AS CLIENTE_CREDITO,
           SUM (C.VALOR) AS VLCREDITO,
           MAX (C.DTLANC) AS DTCREDITO
      FROM PCCRECLI C
      LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.CODFILIAL = 7
       AND C.DTDESCONTO IS NULL
       AND C.NUMTRANSENTDEVCLI IS NOT NULL
     GROUP BY C.CODCLI,
              T.CLIENTE
),
/*BUSCAR TODAS AS DUPLICATAS DOS CLIENTES COM CREDITO EM ABERTO*/
 DUPLICATAS_CLIENTE_CRED AS (
    SELECT DISTINCT C.CODCLICRED,
                    C.CLIENTE_CREDITO,
                    T.CODFILIAL,
                    T.CODCLI,
                    T.DUPLIC,
                    C.VLCREDITO,
                    C.DTCREDITO
      FROM PCPREST T
     INNER JOIN CREDITOS_DEV C ON T.CODCLI = C.CODCLICRED
)
SELECT *
  FROM (
    SELECT T.CODFILIAL,
           D.DTCREDITO,
           D.CODCLICRED,
           D.CLIENTE_CREDITO,
           D.VLCREDITO,
           T.CODCLI,
           C.CLIENTE,
           T.DUPLIC,
           TO_NUMBER (T.PREST) PREST,
           T.CODCOB,
           T.VALOR,
           T.VALORDESC,
           T.VPAGO,
           T.DTPAG,
           T.CODBAIXA,
           E.NOME_GUERRA
      FROM PCPREST T
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
      LEFT JOIN PCEMPR E ON T.CODBAIXA = E.MATRICULA
     INNER JOIN DUPLICATAS_CLIENTE_CRED D ON T.CODFILIAL = D.CODFILIAL
       AND T.DUPLIC = D.DUPLIC
)
 ORDER BY CODCLICRED,
          DUPLIC,
          PREST;
/