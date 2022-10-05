SELECT P.CODFILIAL,
       P.DTEMISSAO,
       P.CODCLI,
       C.CLIENTE,
       P.CODCOB,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       P.DTVENC
  FROM PCPREST P
  JOIN PCCLIENT C ON C.CODCLI = P.CODCLI
 WHERE P.DTCANCEL IS NULL
   AND P.CODCOB = 'BK'
   AND P.CODBARRA IS NULL
   AND P.DTPAG IS NULL
   AND P.DTDESD IS NULL
   AND P.DTEMISSAO < TRUNC(SYSDATE)
    --PARA NAO PEGAR OS TITULOS LIVRARIA DA VILA E BMP
   AND P.DTEMISSAO > TO_DATE('02/08/2022','DD/MM/YYYY')
   --PARA NAO PEGAR TITULOS PRORROGADOS
   AND NVL(P.TIPOPRORROG,'') <> 'E'
 ORDER BY P.DTEMISSAO;
 /