CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_AL AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'AL'
       AND CODNCMEX IN (
        '18069000.', '32131000.', '33030020.', '33041000.', '33042010.', '33043000.', '33049100.', '33049910.', '33049990.', '33051000.'
        , '33072010.', '34013000.', '39221000.1', '39222000.', '39229000.', '39232110.', '39232190.', '39232990.', '42021210.', '42021220.'
        , '42021220.1', '42021220.2', '42029200.', '42029200.1', '42029200.3', '42029900.', '42029900.1', '42029900.2', '48201000.', '48202000.'
        , '48209000.', '70099200.', '73110000.', '82142000.', '84433299.', '84713012.', '84714110.', '84716052.', '84716053.', '84719012.', '85098090.', '85102000.'
        , '85163100.', '85163200.', '85171891.', '85176272.', '85181090.', '85182200.', '85271900.', '85285920.', '87116000.', '87116000.1'
        , '87119000.', '90191000.1', '90251190.', '90251990.', '94056000.', '96032900.', '96032900.1', '96033000.', '96033000.1',
        '96050000.', '96081000.', '96082000.', '96083000.', '96151100.'
    );
/