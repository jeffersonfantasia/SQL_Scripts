SELECT 2 AS TAG,
       '03744425000101' AS "CGC EMPRESA",
       9357 AS "AG�NCIA",
       '007500' AS "CONTA",
       SUBSTR(FI.RAZAOSOCIAL, 1, 30) AS "NOME EMPRESA",
       SUBSTR(A.FORNECEDOR, 1, 30) AS "NOME FAVORECIDO",
       F.CGCAUX AS "CGC/CPF FAVORECIDO",
       A.DTEMISSAO AS "DATA EMISS�O",
       A.NUMNOTA AS "SEU NUMERO",
       --'                       ' AS "USO DA EMPRESA",
       --REPLACE(TO_CHAR(A.VLTOTAL,'9999999999D99'),',','') AS "VALOR",
       B.DUPLIC AS "USO DA EMPRESA",
       TRIM(REPLACE(TO_CHAR(B.VALOR, '99999999D99'), ',', '')) AS "VALOR DUPLICATA",
       B.DTVENC AS "DATA VENCIMENTO"
  FROM PCNFENT A, PCLANC B, PCFORNEC F, PCFILIAL FI
 WHERE A.NUMTRANSENT = B.NUMTRANSENT
   AND A.DTENT >= '03-04-2017'
   AND A.CODFORNEC = F.CODFORNEC
   AND FI.CODIGO = A.CODFILIAL
   AND F.CODFORNECPRINC = '2';
