CREATE OR REPLACE VIEW VIEW_JC_BROKERCONTABIL AS
SELECT (CASE
         WHEN B.CODFILIAL IN (1, 2, 7) THEN
          ('1-' || B.CODCONTAB)
         ELSE
          (B.CODFILIAL || '-' || B.CODCONTAB)
       END) AS ID, --USADO PARA UNIAO COM A TABELA dBalancete
       B.CODFORNEC,
       B.CODFILIAL,
       (F.FORNECEDOR  || ' - ' || B.CODCONTAB ) AS DESCRICAO_CONTA, --PARA FACILITAR A UNIAO ENTRE TABELAS E ORDENAR POR ALFABETICA
       B.CODCONTAB,
       37 AS ID_NIVEL1 --ESSE E O CODIGO QUE FAZ O VINCULO COM A HIERARQUIA CORRETA
  FROM BROKERCONTABIL B
  LEFT JOIN PCFORNEC F
    ON B.CODFORNEC = F.CODFORNEC
 ORDER BY F.FORNECEDOR;
