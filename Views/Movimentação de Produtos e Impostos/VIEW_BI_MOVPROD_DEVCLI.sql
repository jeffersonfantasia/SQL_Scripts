CREATE OR REPLACE VIEW VIEW_BI_MOVPROD_DEVCLI AS
    SELECT M.*
      FROM VIEW_BI_MOVPROD M
     INNER JOIN VIEW_BI_ENT_DEVOLUCAO F ON M.CODFISCAL = F.CODFISCAL;
/