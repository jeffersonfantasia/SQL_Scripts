CREATE OR REPLACE VIEW VIEW_JC_NCMTABELABASE_SC AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE UFDESTINO = 'SC'
       AND CODNCMEX IN (
        '18069000.', '32131000.', '33030020.', '33041000.', '33042010.', '33043000.', '33049100.', '33049910.', '33049990.', '33049990.1'
        , '33051000.', '33072010.', '34011190.', '34013000.', '39221000.1', '39222000.', '39229000.', '39249000.1', '39249000.2',
        '39249000.3', '39269040.', '39269090.2', '40149090.', '42021210.', '42021220.', '42021220.1', '42021220.2', '42029900.', '42029900.1'
        , '42029900.2', '48202000.', '48209000.', '56012190.', '70099200.', '82142000.', '87116000.', '87119000.', '90251190.', '90251990.'
        , '94052000.', '96032100.', '96032900.', '96032900.1', '96033000.', '96050000.', '96081000.', '96082000.', '96083000.', '96151100.'
        , '96190000.', '96190000.1'
    );