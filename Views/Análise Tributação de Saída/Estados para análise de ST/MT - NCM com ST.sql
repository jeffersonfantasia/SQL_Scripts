CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_MT AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'MT'
       AND CODNCMEX IN (
        '39241000.2', '39269040.', '85181090.', '85183000.', '85182200.', '87116000.1', '90191000.1', '96032100.'
    );