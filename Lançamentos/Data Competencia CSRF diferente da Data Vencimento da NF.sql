WITH LANC_CSRF AS
 (SELECT L.RECNUMPRINC,
         L.RECNUM,
         (L.CODFORNEC || '-' || F.FORNECEDOR) FORNECEDOR,
         L.NUMNOTA,
         L.DTCOMPETENCIA DTCOMPETENCIA,
         (SELECT L2.DTVENC FROM PCLANC L2 WHERE L2.RECNUM = L.RECNUMPRINC) DTVENC_NF,
         L.HISTORICO
    FROM PCLANC L
    LEFT JOIN PCFORNEC F ON F.CODFORNEC = L.CODFORNEC
   WHERE L.CODCONTA = 2257)

SELECT *
  FROM LANC_CSRF
 WHERE DTCOMPETENCIA <> DTVENC_NF
    OR RECNUMPRINC = RECNUM;
		
		
WITH LANC_IR_INSS_ISS AS
 (SELECT L.RECNUMPRINC,
         L.RECNUM,
         (L.CODFORNEC || '-' || F.FORNECEDOR) FORNECEDOR,
         L.NUMNOTA,
         L.DTCOMPETENCIA DTCOMPETENCIA,
         (SELECT L2.DTCOMPETENCIA FROM PCLANC L2 WHERE L2.RECNUM = L.RECNUMPRINC) DTCOMPETENCIA_NF,
         L.HISTORICO
    FROM PCLANC L
    LEFT JOIN PCFORNEC F ON F.CODFORNEC = L.CODFORNEC
   WHERE L.CODCONTA IN (2253, 2256, 2258)
     AND NOT (L.CODCONTA = 2256 AND L.CODFORNEC = 9177))

SELECT * FROM LANC_IR_INSS_ISS WHERE DTCOMPETENCIA <> DTCOMPETENCIA_NF;

--UPDATE
MERGE INTO PCLANC L
USING (
  WITH LANC_IR_INSS_ISS AS
   (SELECT L.RECNUMPRINC,
           L.RECNUM,
           (L.CODFORNEC || '-' || F.FORNECEDOR) FORNECEDOR,
           L.NUMNOTA,
           L.DTCOMPETENCIA DTCOMPETENCIA,
           (SELECT L2.DTCOMPETENCIA FROM PCLANC L2 WHERE L2.RECNUM = L.RECNUMPRINC) DTCOMPETENCIA_NF,
           L.HISTORICO
      FROM PCLANC L
      LEFT JOIN PCFORNEC F ON F.CODFORNEC = L.CODFORNEC
     WHERE L.CODCONTA IN (2253, 2256, 2258)
       AND NOT (L.CODCONTA = 2256 AND L.CODFORNEC = 9177))
  
  SELECT *
    FROM LANC_IR_INSS_ISS
   WHERE DTCOMPETENCIA <> DTCOMPETENCIA_NF) X ON (L.RECNUM = X.RECNUM) WHEN MATCHED THEN
    UPDATE SET L.DTCOMPETENCIA = X.DTCOMPETENCIA_NF;

