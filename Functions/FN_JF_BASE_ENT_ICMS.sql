CREATE OR REPLACE FUNCTION FN_JF_BASE_ENT_ICMS
(
  pVALORCOMPRA IN NUMBER,
  pPERCICMSRED IN NUMBER,
  pPERCICMS    IN NUMBER
) RETURN NUMBER IS
  v_CUSTOLIQ NUMBER;

BEGIN
  IF pPERCICMSRED > 0 THEN
    v_CUSTOLIQ := ROUND(pVALORCOMPRA * (pPERCICMSRED / pPERCICMS), 6);
  ELSE
    v_CUSTOLIQ := ROUND(pVALORCOMPRA * pPERCICMS, 6);
  END IF;
  RETURN v_CUSTOLIQ;

END;