CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_PI AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'PI'
       AND CODNCMEX IN (
        '73110000.', '84145990.', '85181090.', '85182200.', '87116000.', '87116000.1', '87119000.'
    );