CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_PE AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'PE'
       AND CODNCMEX IN (
        '39221000.1', '39222000.', '39229000.', '40149090.', '42021210.', '42021220.', '42021220.1', '42021220.2', '56012190.', '70099200.', '84145990.' 
        , '84433299.', '84713012.', '84714110.', '84719012.', '85163100.', '85163200.', '85171891.', '85176272.', '85181090.'
        , '85182200.', '85366910.', '87116000.', '87116000.1', '87119000.', '90191000.1', '90251990.', '94052000.', '94054200.', '94056000.'
        , '96032900.', '96032900.1', '96033000.', '96050000.', '96151100.', '96190000.', '96190000.1'
    );
