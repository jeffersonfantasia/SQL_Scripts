CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_PE AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'PE'
       AND CODNCMEX IN (
        '39221000.1', '39222000.', '39229000.', '40149090.', '42021210.', '42021220.', '42021220.1', '42021220.2', '56012190.', '70099200.'
        , '82142000.', '84433299.', '84713012.', '84714110.', '84716053.', '84719012.', '85163100.', '85163200.', '85171891.', '85181090.'
        , '85182100.', '85183000.', '85366910.', '87116000.', '87119000.', '90191000.1', '90251990.', '94052000.', '96032100.', '96032900.'
        , '96032900.1', '96033000.', '96050000.', '96151100.', '96190000.', '96190000.1'
    );