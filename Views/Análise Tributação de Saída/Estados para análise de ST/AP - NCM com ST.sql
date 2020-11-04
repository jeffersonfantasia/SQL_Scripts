CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_AP AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'AP'
       AND CODNCMEX IN (
        '18069000.', '33030020.', '33041000.', '33042010.', '33043000.', '33049100.', '33049910.', '33049990.', '33049990.1', '33051000.'
        , '33072010.', '34013000.', '39221000.1', '39222000.', '39229000.', '39232110.', '39232190.', '39232990.', '39249000.1', '39249000.2'
        , '39269040.', '39269090.2', '40149090.', '42021210.', '42021220.', '42021220.1', '42021220.2', '56012190.', '82142000.',
        '84433299.', '84713012.', '84714110.', '84716053.', '84719012.', '85044040.', '85094010.', '85102000.', '85163100.', '85163200.'
        , '85181090.', '85182100.', '85183000.', '85271990.', '85285920.', '85366910.', '87116000.', '87119000.', '90191000.1', '90251990.'
        , '94052000.', '96032100.', '96032900.', '96032900.1', '96033000.', '96050000.', '96151100.', '96190000.', '96190000.1'
    );