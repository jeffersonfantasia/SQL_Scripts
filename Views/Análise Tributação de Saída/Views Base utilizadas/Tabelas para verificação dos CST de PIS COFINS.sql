/*TABELA BASE PARA CST 01*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_CST01 AS
    SELECT *
      FROM VIEW_JC_TABELABASE_ICMS18
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ICMS12
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ICMS25;
/

/*TABELA BASE PARA CST 04*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_CST04 AS
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC2;
/

/*TABELA BASE PARA CST 06*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_CST06 AS
    SELECT *
      FROM VIEW_JC_TABELABASE_ICMS_CST41
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_ICMS_CST40
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_ICMS_CST00
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SP_ST_PC3;
/

/*TABELA BASE PARA CST 49*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_CST49 AS
    SELECT *
      FROM VIEW_JC_TABELABASE_SN
    UNION
    SELECT *
      FROM VIEW_JC_TABELABASE_SNE;
/