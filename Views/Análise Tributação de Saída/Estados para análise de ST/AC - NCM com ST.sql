CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_AC AS
 SELECT *
   FROM VIEW_JC_TABELABASE
  WHERE UFDESTINO = 'AC'
    AND CODNCMEX IN ('85181090.','87116000.','87119000.','90191000.1');