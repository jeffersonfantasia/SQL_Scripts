CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_GO AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'GO'
       AND CODNCMEX IN (
        '87116000.', '87116000.1', '87119000.'
    );