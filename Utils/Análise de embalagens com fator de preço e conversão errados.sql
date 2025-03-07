----VERIFICAR PCEMBALAGEM
SELECT B.CODFILIAL,
       B.CODPROD,
       P.DESCRICAO,
       B.CODAUXILIAR,
       B.FATORPRECO,
       B.FATORCONVERSAO
  FROM BROKER.PCEMBALAGEM B
  LEFT JOIN BROKER.PCPRODUT P ON P.CODPROD = B.CODPROD
 WHERE B.UNIDADE = 'UN'
   AND B.CODFILIAL NOT IN ('3', '4')
   AND ((NVL(B.FATORPRECO,0) = 0 OR B.FATORPRECO > 1) OR B.FATORCONVERSAO <> 1);

---ATUALIZAR FATORPRECO DA PCEMBALAGEM
MERGE INTO PCEMBALAGEM B
USING (SELECT B.CODFILIAL,
              B.CODPROD,
              P.DESCRICAO,
              B.CODAUXILIAR,
              B.FATORPRECO,
              B.FATORCONVERSAO
         FROM PCEMBALAGEM B
         LEFT JOIN PCPRODUT P ON P.CODPROD = B.CODPROD
        WHERE B.UNIDADE = 'UN'
          AND B.CODFILIAL NOT IN ('3', '4')
          AND ((NVL(B.FATORPRECO,0) = 0 OR B.FATORPRECO > 1))) X
ON (B.CODFILIAL = X.CODFILIAL AND B.CODAUXILIAR = X.CODAUXILIAR AND B.CODPROD = X.CODPROD)
WHEN MATCHED THEN
  UPDATE SET B.FATORPRECO = 1;

---ATUALIZAR FATORCONVERSAO DA PCEMBALAGEM
MERGE INTO PCEMBALAGEM B
USING (SELECT B.CODFILIAL,
              B.CODPROD,
              P.DESCRICAO,
              B.CODAUXILIAR,
              B.FATORPRECO,
              B.FATORCONVERSAO
         FROM PCEMBALAGEM B
         LEFT JOIN PCPRODUT P ON P.CODPROD = B.CODPROD
        WHERE B.UNIDADE = 'UN'
          AND B.CODFILIAL NOT IN ('3', '4')
          AND B.FATORCONVERSAO <> 1) X
ON (B.CODFILIAL = X.CODFILIAL AND B.CODAUXILIAR = X.CODAUXILIAR AND B.CODPROD = X.CODPROD)
WHEN MATCHED THEN
  UPDATE SET B.FATORCONVERSAO = 1;
