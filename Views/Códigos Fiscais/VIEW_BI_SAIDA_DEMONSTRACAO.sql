CREATE OR REPLACE VIEW VIEW_BI_SAIDA_DEMONSTRACAO AS
    SELECT CODFISCAL,
           DESCCFO AS DESCRICAO
      FROM PCCFO
     WHERE CODFISCAL IN (
        5912, 6912
    );
/