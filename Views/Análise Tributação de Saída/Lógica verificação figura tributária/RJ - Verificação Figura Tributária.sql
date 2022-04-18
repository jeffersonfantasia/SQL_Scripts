/*-------------------------------------VERIFICAÇÃO DO CODST RJ - LUCRO REAL E SIMPLES NACIONAL -----------------------------------*/
CREATE OR REPLACE VIEW VIEW_JC_VERIFICA_CODST_RJ AS
    WITH
/*LUCRO REAL DIF ALIQ*/ LC_ST AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_LR A
         /*CONSIDERAR PRODUTOS COM NCM DIF ALIQ*/
         INNER JOIN VIEW_JC_NCMTABELABASE_RJ B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
          /*DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS*/
          LEFT JOIN VIEW_JC_ICMS_CST40_41 C ON A.CODFILIAL = C.CODFILIAL
           AND A.UFDESTINO = C.UFDESTINO
           AND A.CODPROD = C.CODPROD
          /*DESCONSIDERAR PRODUTOS ST ISENTOS DE ICMS E PIS COFINS 04/06*/
          LEFT JOIN VIEW_JC_ST_SEM_PISCOFINS D ON A.CODFILIAL = D.CODFILIAL
           AND A.UFDESTINO = D.UFDESTINO
           AND A.CODPROD = D.CODPROD
         WHERE (C.CODPROD IS NULL
           AND D.CODPROD IS NULL)
           AND ((
            CASE
                /*SE FOR NACIONAL*/
                WHEN A.IMPORTADO = 'N' THEN (
                    CASE
                        WHEN A.CODST = 106 THEN 1
                        ELSE 0
                    END
                )
                /*SE FOR IMPORTADO*/
                ELSE (
                    CASE
                        WHEN A.CODST = 94 THEN 1
                        ELSE 0
                    END
                )
            END
        ) = 0
            OR (
            /*VERFICA CST PISCOFINS 01 PARA PRODUTOS ST*/
            CASE
                WHEN A.CODTRIBPISCOFINS = 1 THEN 1
                ELSE 0
            END
        ) = 0)
    ), LC_SEMPISCOFINS_ST AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_LR A
         /*CONSIDERAR PRODUTOS ST ISENTOS DE ICMS E PIS COFINS 04/06*/
         INNER JOIN VIEW_JC_ST_SEM_PISCOFINS B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
         WHERE 
         /*DESCONSIDERAR O NCM EM QUESTÃO */ A.CODNCMEX NOT IN (
            '33049990.1'
        )
           AND A.UFDESTINO = 'RJ'
           AND (
            CASE
                WHEN A.IMPORTADO = 'N' THEN (
                    CASE
                        WHEN A.CODST = 142 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR NACIONAL*/
                ELSE (
                    CASE
                        WHEN A.CODST = 109 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR IMPORTADO*/
            END
        ) = 0
    ), 

/*LUCRO REAL OUTROS PRODUTOS*/ LC_NORMAL AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_LR A
          LEFT JOIN VIEW_JC_NCMTABELABASE_RJ B
     /*DESCONSIDERAR PRODUTOS COM NCM DIF ALIQ*/ ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
          LEFT JOIN VIEW_JC_ICMS_CST40_41 C
     /*DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS*/ ON A.CODFILIAL = C.CODFILIAL
           AND A.UFDESTINO = C.UFDESTINO
           AND A.CODPROD = C.CODPROD
          LEFT JOIN VIEW_JC_TABELABASE_ICMS_CST00 D
     /*DESCONSIDERAR PRODUTOS ICMS ISENTOS DE ICMS E PIS COFINS 06*/ ON A.CODFILIAL = D.CODFILIAL
           AND A.UFDESTINO = D.UFDESTINO
           AND A.CODPROD = D.CODPROD
          LEFT JOIN VIEW_JC_TABELABASE_SP_ST_PC2 E
     /*DESCONSIDERAR NCMS FILTRADOS*/ ON A.CODFILIAL = E.CODFILIAL
           AND A.UFDESTINO = E.UFDESTINO
           AND A.CODPROD = E.CODPROD
           AND A.CODNCMEX IN (
            '33049990.1'
        )
         WHERE A.UFDESTINO = 'RJ'
           AND (B.CODPROD IS NULL
           AND C.CODPROD IS NULL
           AND D.CODPROD IS NULL
           AND E.CODPROD IS NULL)
           AND (
            CASE
                WHEN A.IMPORTADO = 'N' THEN (
                    CASE
                        WHEN A.CODST = 91 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR NACIONAL*/
                ELSE (
                    CASE
                        WHEN A.CODST = 89 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR IMPORTADO*/
            END
        ) = 0
    ), LC_SEMPISCOFINS AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_LR A
         INNER JOIN VIEW_JC_TABELABASE_ICMS_CST00 B
     /*CONSIDERAR PRODUTOS ICMS ISENTOS DE PIS COFINS 06*/ ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
          FULL OUTER JOIN VIEW_JC_TABELABASE_SP_ST_PC2 C
     /*UNIR COM PIS COFINS 04 SOMENTE NCMS FILTRADOS*/ ON A.CODFILIAL = C.CODFILIAL
           AND A.UFDESTINO = C.UFDESTINO
           AND A.CODPROD = C.CODPROD
           AND A.CODNCMEX IN (
            '33049990.1'
        )
         WHERE A.UFDESTINO = 'RJ'
           AND (
            CASE
                WHEN A.IMPORTADO = 'N' THEN (
                    CASE
                        WHEN A.CODST = 113 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR NACIONAL*/
                ELSE (
                    CASE
                        WHEN A.CODST = 87 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR IMPORTADO*/
            END
        ) = 0
    ),  

                        
/*SIMPLES NACIONAL DIF ALIQ*/ SN_ST AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_SN A
         INNER JOIN VIEW_JC_NCMTABELABASE_RJ B
     /*CONSIDERAR PRODUTOS COM NCM DIF ALIQ*/ ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
          LEFT JOIN VIEW_JC_ICMS_CST40_41 C
     /*DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS*/ ON A.CODFILIAL = C.CODFILIAL
           AND A.UFDESTINO = C.UFDESTINO
           AND A.CODPROD = C.CODPROD
         WHERE (C.CODPROD IS NULL)
           AND (
            CASE
                WHEN A.IMPORTADO = 'N' THEN (
                    CASE
                        WHEN A.CODST = 131 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR NACIONAL*/
                ELSE (
                    CASE
                        WHEN A.CODST = 125 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR IMPORTADO*/
            END
        ) = 0
    ),

         
/*SIMPLES NACIONAL OUTROS PRODUTOS*/ SN_NORMAL AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_SN A
          LEFT JOIN VIEW_JC_NCMTABELABASE_RJ B
     /*DESCONSIDERAR PRODUTOS COM NCM DIF ALIQ*/ ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
          LEFT JOIN VIEW_JC_ICMS_CST40_41 C
     /*DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS*/ ON A.CODFILIAL = C.CODFILIAL
           AND A.UFDESTINO = C.UFDESTINO
           AND A.CODPROD = C.CODPROD
         WHERE A.UFDESTINO = 'RJ'
           AND (B.CODPROD IS NULL
           AND C.CODPROD IS NULL)
           AND (
            CASE
                WHEN A.CODST = 118 THEN 1
                ELSE 0
            END
        ) = 0
    )
         
/*-----RESULTADO DAS TABELAS VIRTUAIS-------------*/
    SELECT *
      FROM LC_ST
    UNION
    SELECT *
      FROM LC_SEMPISCOFINS_ST
    UNION
    SELECT *
      FROM LC_NORMAL
    UNION
    SELECT *
      FROM LC_SEMPISCOFINS
    UNION
    SELECT *
      FROM SN_ST
    UNION
    SELECT *
      FROM SN_NORMAL;
/


/*-----------------------------------------VERIFICAÇÃO DO CODST RJ SIMPLES NACIONAL EXCESSIVO------------------------------------------*/
CREATE OR REPLACE VIEW VIEW_JC_VERIFICA_CODST_RJ_SNE AS
    WITH 
/*SIMPLES NACIONAL EXCESSIVO DIF ALIQ*/ SNE_ST AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_SNE A
         INNER JOIN VIEW_JC_NCMTABELABASE_RJ B
     /*CONSIDERAR PRODUTOS COM NCM DIF ALIQ*/ ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
          LEFT JOIN VIEW_JC_ICMS_CST40_41 C
     /*DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS*/ ON A.CODFILIAL = C.CODFILIAL
           AND A.UFDESTINO = C.UFDESTINO
           AND A.CODPROD = C.CODPROD
         WHERE (C.CODPROD IS NULL)
           AND (
            CASE
                WHEN A.IMPORTADO = 'N' THEN (
                    CASE
                        WHEN A.CODST = 142 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR NACIONAL*/
                ELSE (
                    CASE
                        WHEN A.CODST = 109 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR IMPORTADO*/
            END
        ) = 0
    ),

/*SIMPLES NACIONAL EXCESSIVO OUTROS PRODUTOS*/ SNE_NORMAL AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_SNE A
          LEFT JOIN VIEW_JC_NCMTABELABASE_RJ B
     /*DESCONSIDERAR PRODUTOS COM NCM DIF ALIQ*/ ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
          LEFT JOIN VIEW_JC_ICMS_CST40_41 C
     /*DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS*/ ON A.CODFILIAL = C.CODFILIAL
           AND A.UFDESTINO = C.UFDESTINO
           AND A.CODPROD = C.CODPROD
         WHERE A.UFDESTINO = 'RJ'
           AND (B.CODPROD IS NULL
           AND C.CODPROD IS NULL)
           AND (
            CASE
                WHEN A.IMPORTADO = 'N' THEN (
                    CASE
                        WHEN A.CODST = 113 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR NACIONAL*/
                ELSE (
                    CASE
                        WHEN A.CODST = 87 THEN 1
                        ELSE 0
                    END
                )
     /*SE FOR IMPORTADO*/
            END
        ) = 0
    )

         
/*-----RESULTADO DAS TABELAS VIRTUAIS-------------*/
    SELECT *
      FROM SNE_ST
    UNION
    SELECT *
      FROM SNE_NORMAL;
/