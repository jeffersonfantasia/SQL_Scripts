CREATE OR REPLACE VIEW VIEW_BI_ENT_DEVOLUCAO AS
    SELECT CODFISCAL,
           DESCCFO AS DESCRICAO
      FROM PCCFO
     WHERE CODFISCAL IN (
        1202, 1411, 2202, 2411
    );
/