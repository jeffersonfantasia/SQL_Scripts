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
    OR RECNUMPRINC = RECNUM
