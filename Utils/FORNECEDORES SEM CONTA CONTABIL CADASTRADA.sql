/*DESPESAS COM FORNECEDORES SEM CONTA CONTABIL CADASTRADA--*/
WITH FORNEC_CONTABIL AS (
    SELECT (CODFILIAL || '-' || CODFORNEC) AS COD_ID
      FROM BROKERCONTABIL
), DESPESAS AS (
    SELECT L.CODFILIAL,
           L.DATA,
           L.RECNUM AS NUMTRANS,
           L.CODCONTA,
           T.CONTA,
           T.GRUPOCONTA,
           C.NUMNOTA,
           L.VALOR,
           'ROT' AS ESPECIE,
           750 AS CODFISCAL,
           L.CODFORNEC,
           F.FORNECEDOR,
           F.CGC,
           F.ESTADO
      FROM VIEW_JC_LANC_GERENCIAL L
      LEFT JOIN PCLANC C ON L.RECNUM = C.RECNUM
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
      LEFT JOIN PCCONTA T ON L.CODCONTA = T.CODCONTA
    UNION ALL
    SELECT E.CODFILIAL,
           E.DTENT AS DATA,
           E.NUMTRANSENT AS NUMTRANS,
           E.CODCONTA,
           C.CONTA,
           C.GRUPOCONTA,
           F.NUMNOTA,
           E.VALOR,
           F.ESPECIE,
           E.CODFISCAL,
           E.CODFORNEC,
           R.FORNECEDOR,
           R.CGC,
           R.ESTADO
      FROM VIEW_JC_LANC_FISCAL E
      LEFT JOIN PCNFENT F ON E.NUMTRANSENT = F.NUMTRANSENT
      LEFT JOIN PCCONTA C ON E.CODCONTA = C.CODCONTA
      LEFT JOIN PCFORNEC R ON E.CODFORNEC = R.CODFORNEC
    UNION ALL
    SELECT DISTINCT E.CODFILIAL,
                    M.DATA,
                    M.NUMTRANSACAO AS NUMTRANS,
                    100001 AS CODCONTA,
                    'COMPRA MERCADORIA' AS CONTA,
                    100 AS GRUPOCONTA,
                    E.NUMNOTA,
                    E.VLTOTAL AS VALOR,
                    E.ESPECIE,
                    TO_NUMBER (M.CODFISCAL) AS CODFISCAL,
                    M.CODFORCLI AS CODFORNEC,
                    F.FORNECEDOR,
                    F.CGC,
                    F.ESTADO
      FROM VIEW_BI_MOVPROD M
     INNER JOIN PCNFENT E ON M.NUMTRANSACAO = E.NUMTRANSENT
     INNER JOIN PCFORNEC F ON M.CODFORCLI = F.CODFORNEC
     WHERE M.CODFISCAL IN (
        1102, 2102, 1403, 1405, 2403
    )
)
SELECT E.*
  FROM DESPESAS E
  LEFT JOIN FORNEC_CONTABIL B ON (E.CODFILIAL || '-' || E.CODFORNEC) = B.COD_ID
 WHERE E.DATA BETWEEN '01-JAN-2020' AND ADD_MONTHS (LAST_DAY (TRUNC (SYSDATE)), - 0)
   AND E.GRUPOCONTA NOT IN (
    810, 820
)
   AND B.COD_ID IS NULL;
/
/*ANALISE DE FORNECEDORES*/
SELECT ROWID,
       F.CGC,
       F.*
  FROM PCFORNEC F
 WHERE CODFORNEC IN (
    10071,10067
);
/
SELECT F.CGC,
       F.*
  FROM PCFORNEC F
 WHERE CGC = '12.621.274/0005-00';
/
/*FORNECEDORES SEM CONTA CONTABIL CADASTRADA*/
WITH FORNEC_CONTABIL AS (
    SELECT (CODFILIAL || '-' || CODFORNEC) AS COD_ID
      FROM BROKERCONTABIL
), DESPESAS AS (
    SELECT L.CODFILIAL,
           L.DATA,
           L.RECNUM AS NUMTRANS,
           L.CODCONTA,
           T.CONTA,
           T.GRUPOCONTA,
           C.NUMNOTA,
           L.VALOR,
           'ROT' AS ESPECIE,
           750 AS CODFISCAL,
           L.CODFORNEC,
           F.FORNECEDOR,
           F.CGC,
           F.ESTADO
      FROM VIEW_JC_LANC_GERENCIAL L
      LEFT JOIN PCLANC C ON L.RECNUM = C.RECNUM
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
      LEFT JOIN PCCONTA T ON L.CODCONTA = T.CODCONTA
    UNION ALL
    SELECT E.CODFILIAL,
           E.DTENT AS DATA,
           E.NUMTRANSENT AS NUMTRANS,
           E.CODCONTA,
           C.CONTA,
           C.GRUPOCONTA,
           F.NUMNOTA,
           E.VALOR,
           F.ESPECIE,
           E.CODFISCAL,
           E.CODFORNEC,
           R.FORNECEDOR,
           R.CGC,
           R.ESTADO
      FROM VIEW_JC_LANC_FISCAL E
      LEFT JOIN PCNFENT F ON E.NUMTRANSENT = F.NUMTRANSENT
      LEFT JOIN PCCONTA C ON E.CODCONTA = C.CODCONTA
      LEFT JOIN PCFORNEC R ON E.CODFORNEC = R.CODFORNEC
    UNION ALL
    SELECT E.CODFILIAL,
           M.DATA,
           M.NUMTRANSACAO AS NUMTRANS,
           100001 AS CODCONTA,
           'COMPRA MERCADORIA' AS CONTA,
           100 AS GRUPOCONTA,
           E.NUMNOTA,
           M.VLTOTALNF AS VALOR,
           E.ESPECIE,
           M.CODFISCAL,
           M.CODFORCLI AS CODFORNEC,
           F.FORNECEDOR,
           F.CGC,
           F.ESTADO
      FROM VIEW_BI_MOVPROD M
     INNER JOIN PCNFENT E ON M.NUMTRANSACAO = E.NUMTRANSENT
     INNER JOIN PCFORNEC F ON M.CODFORCLI = F.CODFORNEC
     WHERE M.CODFISCAL IN (
        1102, 2102, 1403, 1405, 2403
    )
)
SELECT *
  FROM (
    SELECT (
        CASE
            WHEN E.CODFILIAL IN (
                1, 2, 7, 8
            ) THEN 'JC BROTHERS'
            WHEN E.CODFILIAL = 5 THEN 'JFF'
            WHEN E.CODFILIAL = 6 THEN 'BROKER CORP'
            WHEN E.CODFILIAL = 9 THEN 'CFF CLOUD'
            WHEN E.CODFILIAL = 10 THEN 'FFJ CORP'
            ELSE NULL
        END
    ) AS FILIAL,
           E.CODFORNEC,
           E.FORNECEDOR,
           E.CGC,
           E.ESTADO
      FROM DESPESAS E
      LEFT JOIN FORNEC_CONTABIL B ON (E.CODFILIAL || '-' || E.CODFORNEC) = B.COD_ID
     WHERE E.DATA BETWEEN '01-JAN-2020' AND ADD_MONTHS (LAST_DAY (TRUNC (SYSDATE)), - 1)
       AND E.GRUPOCONTA NOT IN (
        810, 820
    )
       AND B.COD_ID IS NULL
)
 GROUP BY FILIAL,
          CODFORNEC,
          FORNECEDOR,
          CGC,
          ESTADO
 ORDER BY FILIAL,
          CODFORNEC;
/
/*ANALISE DE CONTAS CONTABEIS DE FORNECEDORES*/
SELECT DISTINCT F.CODFORNEC,
                F.FORNECEDOR,
                F.CGC,
                F.ESTADO,
                B.CODCONTAB
  FROM PCFORNEC F
  LEFT JOIN BROKERCONTABIL B ON F.CODFORNEC = B.CODFORNEC
 WHERE NVL (B.CODFILIAL, 0) IN (
    0, 1, 2, 7, 8
)
   AND F.CODFORNEC IN (
    9985
)
 GROUP BY F.CODFORNEC,
          F.FORNECEDOR,
          F.CGC,
          F.ESTADO,
          B.CODCONTAB
 ORDER BY F.FORNECEDOR;
/