/*Relatório Produtos sem flag Gera ICMS no livro fiscal   */
WITH NCM_ICMS_OU_ST AS
 (SELECT DISTINCT P.CODNCMEX, F.GERAICMSLIVROFISCAL GERAICMS
    FROM PCPRODUT P
    JOIN PCPRODFILIAL F ON P.CODPROD = F.CODPROD
   WHERE F.CODFILIAL = '1'
     AND F.GERAICMSLIVROFISCAL IS NOT NULL)
SELECT --p.rowid, 
       T.DTCADASTRO,
       P.CODFILIAL,
       T.CODPRODMASTER,
       P.CODPROD,
       T.DESCRICAO,
       T.CODNCMEX,
       P.GERAICMSLIVROFISCAL REGIME_ICMS,
       P.GERAICMSLIVROFISCALENT ICMS_ENT,
       P.GERAICMSLIVROFISCALDEVFORNEC ICMS_DEV,
       N.GERAICMS
  FROM PCPRODFILIAL P
  JOIN PCPRODUT T ON T.CODPROD = P.CODPROD
  LEFT JOIN NCM_ICMS_OU_ST N ON T.CODNCMEX = N.CODNCMEX
 WHERE ((P.GERAICMSLIVROFISCAL IS NULL OR
       P.GERAICMSLIVROFISCAL <> N.GERAICMS OR
       (P.GERAICMSLIVROFISCALENT IS NULL OR
       P.GERAICMSLIVROFISCALENT <> N.GERAICMS)) OR
       (P.GERAICMSLIVROFISCALDEVFORNEC IS NULL OR
       P.GERAICMSLIVROFISCALDEVFORNEC <> N.GERAICMS))
   AND T.DTCADASTRO <= TRUNC(SYSDATE)
   AND T.DTEXCLUSAO IS NULL
   AND T.CODPRODMASTER IS NOT NULL
	 --AND P.GERAICMSLIVROFISCAL IS NULL
 ORDER BY T.CODNCMEX, T.DTCADASTRO DESC, P.CODPROD, TO_NUMBER(P.CODFILIAL);
/
---UPDATE MARGE---
MERGE
  INTO PCPRODFILIAL F
  USING (
  WITH NCM_ICMS_OU_ST AS
   (SELECT DISTINCT P.CODNCMEX, F.GERAICMSLIVROFISCAL GERAICMS
      FROM PCPRODUT P
      JOIN PCPRODFILIAL F ON P.CODPROD = F.CODPROD
     WHERE F.CODFILIAL = '1'
       AND F.GERAICMSLIVROFISCAL IS NOT NULL)
  SELECT P.CODFILIAL,
         P.CODPROD,
         T.DESCRICAO,
         T.CODNCMEX,
         P.GERAICMSLIVROFISCAL REGIME_ICMS,
         N.GERAICMS
    FROM PCPRODFILIAL P
    JOIN PCPRODUT T ON T.CODPROD = P.CODPROD
    JOIN NCM_ICMS_OU_ST N ON T.CODNCMEX = N.CODNCMEX
   WHERE ((P.GERAICMSLIVROFISCAL IS NULL OR
         P.GERAICMSLIVROFISCAL <> N.GERAICMS OR
         (P.GERAICMSLIVROFISCALENT IS NULL OR
         P.GERAICMSLIVROFISCALENT <> N.GERAICMS)) OR
         (P.GERAICMSLIVROFISCALDEVFORNEC IS NULL OR
         P.GERAICMSLIVROFISCALDEVFORNEC <> N.GERAICMS))
     AND T.DTCADASTRO <= TRUNC(SYSDATE)
     AND T.DTEXCLUSAO IS NULL 
		 --AND P.GERAICMSLIVROFISCAL IS NULL
		 --AND T.CODNCMEX <> '39249000.2'
     AND T.CODPRODMASTER IS NOT NULL) X ON (F.CODPROD = X.CODPROD AND F.CODFILIAL = X.CODFILIAL) WHEN MATCHED THEN UPDATE SET F.GERAICMSLIVROFISCAL = X.GERAICMS, F.GERAICMSLIVROFISCALENT = X.GERAICMS, F.GERAICMSLIVROFISCALDEVFORNEC = X.GERAICMS;

UPDATE PCPRODFILIAL
   SET GERAICMSLIVROFISCAL = 'N', GERAICMSLIVROFISCALENT = 'N', GERAICMSLIVROFISCALDEVFORNEC = 'N'
 WHERE GERAICMSLIVROFISCAL = 'S'
   AND CODPROD IN (819188, 819191);

UPDATE PCPRODFILIAL
   SET GERAICMSLIVROFISCAL = 'S', GERAICMSLIVROFISCALENT = 'S', GERAICMSLIVROFISCALDEVFORNEC = 'S'
 WHERE GERAICMSLIVROFISCAL = 'N'
   AND CODPROD IN (819871);

SELECT P.ROWID, T.DTCADASTRO,
       P.CODFILIAL,
       T.CODPRODMASTER,
       P.CODPROD,
       T.DESCRICAO,
       T.CODNCMEX,
       P.GERAICMSLIVROFISCAL REGIME_ICMS,
       P.GERAICMSLIVROFISCALENT ICMS_ENT,
       P.GERAICMSLIVROFISCALDEVFORNEC ICMS_DEV
  FROM PCPRODFILIAL P, PCPRODUT T
 WHERE T.CODPROD = P.CODPROD
   AND P.CODPROD IN (819494);
	 
	 SELECT P.ROWID, T.DTCADASTRO,
       P.CODFILIAL,
       T.CODPRODMASTER,
       P.CODPROD,
       T.DESCRICAO,
       T.CODNCMEX,
       P.GERAICMSLIVROFISCAL REGIME_ICMS,
       P.GERAICMSLIVROFISCALENT ICMS_ENT,
       P.GERAICMSLIVROFISCALDEVFORNEC ICMS_DEV
  FROM PCPRODFILIAL P, PCPRODUT T
 WHERE T.CODPROD = P.CODPROD
   AND T.CODNCMEX IN ('39269090.')
	 AND P.CODFILIAL = '1'
	 AND P.GERAICMSLIVROFISCAL = 'N';
	 
/
