CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_PB AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'PB'
       AND CODNCMEX IN (
        '73110000.', '84145990.', '87116000.', '87116000.1', '87119000.'
    );
