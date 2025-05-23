/*TABELA BASE PARA CST PIS COFINS 06 E DESTAQUE DE ICMS    */
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_ICMS_CST00 AS
    SELECT * FROM VIEW_JC_TABELABASE WHERE CODNCMEX IN ('49030000.1');
/

/*TABELA BASE PARA CST PIS COFINS 06 E PRODUTO ST    */
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_SP_ST_PC3 AS
    SELECT * FROM VIEW_JC_TABELABASE WHERE CODNCMEX IN ('96032100.');
/

/*TABELA BASE PARA CST PIS COFINS 04 E PRODUTO ST    */
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_SP_ST_PC2 AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE CODNCMEX IN ('33030020.',
                        '33041000.',
                        '33042010.',
                        '33042090.',
                        '33043000.',
                        '33049100.',
                        '33049910.',
                        '33049990.',
                        '33049990.1',
                        '33051000.',
                        '33072010.',
                        '34011190.');
/

/*TABELA BASE PARA CST PIS COFINS 01 E PRODUTO ST    */
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_SP_ST_PC1 AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE CODNCMEX IN ('18069000.',
                        '32131000.',
												'34013000.',
                        '39221000.1',
                        '39222000.',
                        '39229000.',
                        '39232110.',
                        '39232190.',
                        '39232990.',
                        '39241000.',
                        '39241000.1',
                        '39241000.2',
                        '39249000.1',
                        '39249000.2',
                        '39249000.3',
                        '39269040.',
                        '39269090.2',
                        '40149090.',
                        '42021210.',
                        '42021220.',
                        '42021220.1',
                        '42021220.2',
                        '42029200.',
                        '42029200.1',
                        '42029900.',
                        '42029900.1',
                        '42029900.2',
                        '48201000.',
                        '48202000.',
                        '48209000.',
                        '56012190.',
                        '70099200.',
                        '70139900.',
                        '73110000.',
                        '82130000.',
                        '82142000.',
                        '84145990.',
                        '84433299.',
                        '84439933.',
                        '84713012.',
                        '84714110.',
                        '84716052.',
                        '84716053.',
                        '84719012.',
                        '85044040.',
                        '85094010.',
                        '85098090.',
                        '85102000.',
                        '85163100.',
                        '85163200.',
                        '85167990.',
                        '85171891.',
                        '85185000.',
												'85182100.',
                        '85182200.',
                        '85183000.',
                        '85271300.',
                        '85271900.',
                        '85285920.',
                        '85366910.',
                        '87116000.',
                        '87119000.',
                        '90191000.1',
                        '90251190.',
                        '90251199.',
                        '90251990.',
                        '94052000.',
                        '94054200.',
                        '95045000.',
                        '96032900.',
                        '96032900.1',
                        '96033000.',
                        '96050000.',
                        '96081000.',
                        '96082000.',
                        '96083000.',
                        '96151100.',
                        '96151900.',
                        '96190000.',
                        '96190000.1');
/

/*UNIAO DAS TABELAS ST QUE S�O ISENTOS DE PIS COFINS*/
CREATE OR REPLACE VIEW VIEW_JC_ST_SEM_PISCOFINS AS
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC3
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC2;
/


/*UNIAO DAS TABELAS ICMS E ST QUE S�O ISENTOS DE PIS COFINS 06*/
CREATE OR REPLACE VIEW VIEW_JC_ICMS_ST_PISCOFINS06 AS
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC3
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_ICMS_CST00;
/

/*UNIAO DAS TABELAS ICMS ISENTOS DE PIS COFINS 06 E ST ISENTOS DE PIS COFINS 04*/
CREATE OR REPLACE VIEW VIEW_JC_ICMS06_ST04_PISCOFINS AS
    SELECT *
      FROM VIEW_JC_TABELABASE_ICMS_CST00
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC2;
/


/*UNIAO DAS TABELAS ICMS E ST QUE S�O ISENTOS DE PIS COFINS 04/06*/
CREATE OR REPLACE VIEW VIEW_JC_ICMS_ST_SEM_PISCOFINS AS
    SELECT *
      FROM VIEW_JC_TABELABASE_ICMS_CST00
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC3
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC2;
/
