CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_SE AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'SE'
       AND CODNCMEX IN (
        '39221000.1', '39222000.', '39229000.', '39241000.', '39241000.1', '70099200.', '70139900.', '84433299.', '84713012.', '84714110.'
        , '84719012.', '85044040.', '85171891.', '85181090.', '85285920.', '87116000.', '87116000.1', '87119000.'
        , '90191000.1'
    );