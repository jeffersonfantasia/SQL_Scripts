/*Ao fazer novas inclus�es de NCM, devemos realizar a atualiza��o da view de 18% de ICMS SP*/
/*TABELA BASE PARA NCM COM AL�QUOTA INTERNA DE SP ICMS 12%*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_SP_ICMS12 AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE CODNCMEX IN (
        '84719012.1', '85171231.', '85255019.', '85432000.', '85437099.', '88022010.', '94037000.'
    );

/*TABELA BASE PARA NCM COM AL�QUOTA INTERNA DE SP ICMS 12%*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_SP_ICMS13 AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE CODNCMEX IN (
        '94017900.', '94019900.', '94032090.', '94035000.', '94036000.', '94039090.''94017100.', '94018000.', '94018000.2'
    );


/*TABELA BASE PARA NCM COM AL�QUOTA INTERNA DE SP ICMS 25%*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_SP_ICMS25 AS
    SELECT *
      FROM VIEW_JC_TABELABASE
     WHERE CODNCMEX IN (
        '95044000.'
    );

/*TABELA BASE PARA NCM COM AL�QUOTA INTERNA DE SP ICMS 18%*/
CREATE OR REPLACE VIEW VIEW_JC_TABELABASE_SP_ICMS18 AS
    SELECT CODFILIAL,
           DTCADASTRO,
           CODPROD,
           CODFAB,
           REGIME_ICMS,
           DESCRICAO,
           IMPORTADO,
           CODNCMEX,
           UFDESTINO,
           CODST,
           MENSAGEM,
           CODTRIBPISCOFINS
      FROM VIEW_JC_TABELABASE
     WHERE REGIME_ICMS = 'S'
       AND UFDESTINO = 'SP'
       AND CODNCMEX NOT IN ('49011000.',
                            '49019900.',
                            '49030000.',
                            '49111090.1',
                            '49119900.1',
                            '49030000.1',
                            '84145190.',
                            '84145990.',
                            '84719012.1',
                            '85171231.',
                            '85255019.',
                            '85432000.',
                            '85437099.',
                            '88022010.',
                            '94017100.',
                            '94017900.',
                            '94018000.',
                            '94018000.2',
                            '94019900.',
                            '94032090.',
                            '94035000.',
                            '94036000.',
                            '94037000.',
                            '94039090.',
                            '95044000.')
     /*PARA NAO CONSIDERAR PRODUTOS ICMS COM ALIQUOTAS DIFERENTE DE 18% E COM CST PIS COFINS 01*/;
