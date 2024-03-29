WITH PRODUTOS_FILHOS AS (
    SELECT CODPROD AS CODFILHO,
           CODPRODMASTER,
           DESCRICAO AS DESCRICAO_FILHO
      FROM PCPRODUT P
     WHERE CODPRODMASTER <> CODPROD
)
SELECT P.CODPROD AS CODPAI,
       P.DESCRICAO DESCRICAO_PAI,
       COUNT (F.CODFILHO) AS QTD_FILHOS,
       MAX (F.CODFILHO) AS CODFILHO,
       MAX (F.DESCRICAO_FILHO) AS DESCRICAO_FILHO
  FROM PCPRODUT P
 INNER JOIN PRODUTOS_FILHOS F ON P.CODPROD = F.CODPRODMASTER
 GROUP BY P.CODPROD,
          P.DESCRICAO
HAVING COUNT (F.CODFILHO) = 1;
/