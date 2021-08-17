CREATE OR REPLACE VIEW VIEW_BI_FILIAL AS
    SELECT CAST (CODIGO AS NUMBER) AS CODFILIAL,
           (
               CASE
                   WHEN FANTASIA IS NULL THEN 'FILIAL 99'
                   ELSE FANTASIA
               END
           ) AS FILIAIS,
           (
               CASE
                   WHEN NOMEREMETENTE IS NULL THEN 'FILIAL 99'
                   ELSE NOMEREMETENTE
               END
           ) AS EMPRESAS
      FROM PCFILIAL
      WHERE CODIGO NOT IN ('99')
     ORDER BY CODIGO;
/