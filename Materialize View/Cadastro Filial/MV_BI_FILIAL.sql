CREATE MATERIALIZED VIEW MV_BI_FILIAL
REFRESH FORCE ON DEMAND START WITH SYSDATE NEXT SYSDATE + 1/1152 AS
--ATUALIZACAO COM FREQUENCIA DE 1 MIN
WITH FILIAL AS
 (SELECT CAST(CODIGO AS NUMBER) "Cód. Filial",
         (CASE
           WHEN FANTASIA IS NULL THEN
            'FILIAL 99'
           ELSE
            FANTASIA
         END) "Filial",
         (CASE
           WHEN NOMEREMETENTE IS NULL THEN
            'JC BROTHERS'
           ELSE
            NOMEREMETENTE
         END) "Empresa"
    FROM PCFILIAL F
   ORDER BY TO_NUMBER(F.CODIGO))

SELECT "Cód. Filial",
       F."Filial",
       F."Empresa",
       (CASE
         WHEN F."Empresa" = 'JC BROTHERS' THEN
          'LUCRO REAL'
         ELSE
          'SIMPLES'
       END) "Tipo Empresa"
  FROM FILIAL F;
/