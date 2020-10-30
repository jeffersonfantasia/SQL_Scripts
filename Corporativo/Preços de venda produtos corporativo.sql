SELECT F.CODFILIAL,
       P.CODFORNEC,
       C.FORNECEDOR,
       F.CODPROD,
       P.DESCRICAO,
       T.PVENDA
  FROM PCPRODFILIAL F,
       PCPRODUT P,
       PCTABPR T,
       PCFORNEC C
 WHERE F.CODPROD = P.CODPROD
   AND P.CODPROD = T.CODPROD
   AND P.CODFORNEC = C.CODFORNEC
   AND F.CODFILIAL = 6
   AND F.ENVIARFORCAVENDAS = 'S'
   AND T.NUMREGIAO = 6
 ORDER BY C.FORNECEDOR,
          P.DESCRICAO;
/