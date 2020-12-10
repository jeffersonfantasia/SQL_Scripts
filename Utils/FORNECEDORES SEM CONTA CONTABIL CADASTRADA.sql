/*FORNECEDORES SEM CONTA CONTABIL CADASTRADA--*/
WITH FORNEC_CONTABIL AS (
    SELECT (CODFILIAL || '-' || CODFORNEC) AS COD_ID
      FROM BROKERCONTABIL
)
SELECT L.CODFILIAL,
       (
           CASE
               WHEN L.CODCONTA = 100001 THEN L.DTLANC
               ELSE L.DTEMISSAO
           END
       ) DTEMISSAO,
       L.DTLANC,
       L.RECNUM,
       L.CODCONTA,
       C.CONTA,
       L.NUMNOTA, 
      /* L.VPAGO,*/
       L.CODFORNEC,
       F.FORNECEDOR,
       F.CGC,
       F.ESTADO
  FROM PCLANC L
  LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
  LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
  LEFT JOIN FORNEC_CONTABIL B ON (L.CODFILIAL || '-' || L.CODFORNEC) = B.COD_ID
 WHERE L.TIPOPARCEIRO = 'F'
   AND C.GRUPOCONTA NOT IN (
    140, 200, 300, 650, 680, 810, 820
)
   AND L.CODCONTA NOT IN (
    410105, 530106, /*545102,*/ 610103, 620107
)
   AND L.CODFORNEC NOT IN (
    1, 7543, 8215
)
   AND L.TIPOLANC = 'C'
   AND (
    CASE
        WHEN L.CODCONTA = 100001 THEN L.DTLANC
        ELSE L.DTEMISSAO
    END
) BETWEEN '01-JAN-2020' AND ADD_MONTHS (LAST_DAY (TRUNC (SYSDATE)), -1)
   AND B.COD_ID IS NULL
 GROUP BY L.CODFILIAL,
          L.DTEMISSAO,
          L.DTLANC,
          L.RECNUM,
          L.CODCONTA,
          C.CONTA,
          L.NUMNOTA,  
         /* L.VPAGO,*/
          L.CODFORNEC,
          F.FORNECEDOR,
          F.CGC,
          F.ESTADO
 ORDER BY F.FORNECEDOR;
/
SELECT ROWID,
       F.CGC,
       F.*
  FROM PCFORNEC F
 WHERE CODFORNEC = 9745;
SELECT F.CGC,
       F.*
  FROM PCFORNEC F
 WHERE CGC = '12.621.274/0005-00';
/
WITH FORNEC_CONTABIL AS (
    SELECT (CODFILIAL || '-' || CODFORNEC) AS COD_ID
      FROM BROKERCONTABIL
)
SELECT L.CODFORNEC,
       F.FORNECEDOR,
       F.CGC,
       F.ESTADO
  FROM PCLANC L
  LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
  LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
  LEFT JOIN FORNEC_CONTABIL B ON (L.CODFILIAL || '-' || L.CODFORNEC) = B.COD_ID
 WHERE L.TIPOPARCEIRO = 'F'
   AND C.GRUPOCONTA NOT IN (
    140, 200, 300, 650, 680, 810, 820
)
   AND L.CODCONTA NOT IN (
    410105, 530106, 545102, 610103, 620107
)
   AND L.CODFORNEC NOT IN (
    1, 7543, 8215
)
   AND L.TIPOLANC = 'C'
   AND (
    CASE
        WHEN L.CODCONTA = 100001 THEN L.DTLANC
        ELSE L.DTEMISSAO
    END
) BETWEEN '01-JAN-2020' AND ADD_MONTHS (LAST_DAY (TRUNC (SYSDATE)), - 1)
   AND L.CODFILIAL IN (
    1, 2, 7
)
   AND B.COD_ID IS NULL
 GROUP BY L.CODFORNEC,
          F.FORNECEDOR,
          F.CGC,
          F.ESTADO
 ORDER BY F.FORNECEDOR;
/
/*Analise de contas contabeis entre fornecedores*/
SELECT DISTINCT F.CODFORNEC,
                F.FORNECEDOR,
                F.CGC,
                F.ESTADO,
                B.CODCONTAB
  FROM PCFORNEC F
  LEFT JOIN BROKERCONTABIL B ON F.CODFORNEC = B.CODFORNEC
 WHERE NVL (B.CODFILIAL, 0) IN (
    0, 1, 2, 7
)
   AND F.CODFORNEC IN (
    9193,
9804
)
 GROUP BY F.CODFORNEC,
          F.FORNECEDOR,
          F.CGC,
          F.ESTADO,
          B.CODCONTAB
 ORDER BY F.FORNECEDOR;
/