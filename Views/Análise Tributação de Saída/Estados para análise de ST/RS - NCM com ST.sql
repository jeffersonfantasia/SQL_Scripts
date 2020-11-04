CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_RS AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'RS'
       AND CODNCMEX IN (
        '18069000.', '32131000.', '33030020.', '33041000.', '33042010.', '33043000.', '33049100.', '33049910.', '33049990.', '33049990.1'
        , '33051000.', '33072010.', '34011190.', '34013000.', '39221000.1', '39222000.', '39229000.', '39232110.', '39232190.', '39232990.'
        , '39241000.', '39249000.1', '39249000.3', '40149090.', '42021210.', '42021220.', '42021220.1', '42021220.2', '42029200.'
        , '42029200.1', '42029900.', '42029900.1', '42029900.2', '48201000.', '48202000.', '48209000.', '56012190.', '70099200.',
        '70139900.', '73110000.', '82142000.', '84433299.', '84713012.', '84714110.', '84716053.', '84719012.', '85044040.', '85094010.'
        , '85102000.', '85163100.', '85163200.', '85171891.', '85181090.', '85182100.', '85183000.', '85271990.', '85285920.', '85366910.'
        , '87116000.', '87119000.', '90191000.1', '90251190.', '90251990.', '94052000.', '96032100.', '96032900.', '96032900.1', '96033000.'
        , '96050000.', '96081000.', '96082000.', '96083000.', '96151100.', '96190000.', '96190000.1'
    );