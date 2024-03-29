CREATE OR REPLACE FUNCTION FN_JF_BASE_ENT_PIS_COFINS
(
  pVALORCOMPRA IN NUMBER,
  pBASEICMS    IN NUMBER,
  pPERCICMS    IN NUMBER,
  pPERCIPI     IN NUMBER
) RETURN NUMBER IS
  v_BASEPISCOFINS NUMBER;
BEGIN
  --SEM ICMS NA BASE DE PIS COFINS
  v_BASEPISCOFINS := ROUND ((pVALORCOMPRA - (pBASEICMS * pPERCICMS) + (pVALORCOMPRA * pPERCIPI)), 6) ;
  --COM ICMS NA BASE DE PIS COFINS
  --v_BASEPISCOFINS := ROUND((pVALORCOMPRA + (pVALORCOMPRA * pPERCIPI)), 6);
  RETURN v_BASEPISCOFINS;

END;
