CREATE OR REPLACE VIEW VIEW_BI_SAIDA_TRANSFERENCIA AS
    SELECT CODFISCAL,
           DESCCFO AS DESCRICAO
      FROM PCCFO
     WHERE CODFISCAL IN (
        5152, 5409, 6152, 6409
    );
/