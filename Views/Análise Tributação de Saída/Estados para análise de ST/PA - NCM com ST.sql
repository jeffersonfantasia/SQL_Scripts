CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_PA AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'PA'
       AND CODNCMEX IN (
        '39249000.1', '39249000.2', '39249000.3', '73110000.', '87116000.', '87116000.1', '87119000.'
    );
