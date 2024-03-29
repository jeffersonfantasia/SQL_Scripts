CREATE OR REPLACE VIEW VIEW_JC_CUSTOCONT_ENTTV9 AS
WITH MOV_SAIDATV9 AS
 (SELECT M.NUMTRANSVENDA,
         M.NUMTRANSITEM AS NUMTRANSITEM_SAIDATV9,
         M.CODPROD,
         M.CUSTOCONT AS CUSTOCONT_SAIDATV9
    FROM PCMOV M
   WHERE M.CODFISCAL IN (5912, 6912)
     AND M.STATUS <> 'B'
     AND M.DTCANCEL IS NULL)
SELECT M.NUMTRANSITEM AS NUMTRANSITEM_ENTTV9, T.CUSTOCONT_SAIDATV9
  FROM PCMOV M
  LEFT JOIN MOV_SAIDATV9 T ON M.NUMTRANSDEV = T.NUMTRANSVENDA
                          AND M.CODPROD = T.CODPROD
 WHERE M.CODFISCAL IN (1913, 2913)
   AND STATUS <> 'B'
   AND M.DTCANCEL IS NULL;
/
