CREATE OR REPLACE VIEW VIEW_JC_VERIFICA_PIS_COFINS AS
    WITH 
/*----VERIFICACAO DOS CST DE PIS COFINS PARA PRODUTOS LR 01------------*/ 
PIS_COFINS_LC01 AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_CST01 A
         INNER JOIN VIEW_JC_TABELABASE_LR B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
         WHERE (
            CASE
                WHEN A.CODTRIBPISCOFINS = 1 THEN 1
                ELSE 0
            END
        ) = 0
    ),

/*----VERIFICACAO DOS CST DE PIS COFINS PARA PRODUTOS LR 04------------*/ 
PIS_COFINS_LC04 AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_CST04 A
         INNER JOIN VIEW_JC_TABELABASE_LR B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
         WHERE (
            CASE
                WHEN A.CODTRIBPISCOFINS = 2 THEN 1
                ELSE 0
            END
        ) = 0
    ),  

/*----VERIFICACAO DOS CST DE PIS COFINS PARA PRODUTOS LR 06------------*/ 
PIS_COFINS_LC06 AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_CST06 A
         INNER JOIN VIEW_JC_TABELABASE_LR B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
         WHERE (
            CASE
                WHEN A.CODTRIBPISCOFINS = 3 THEN 1
                ELSE 0
            END
        ) = 0
    ),   

/*----VERIFICACAO DOS CST DE PIS COFINS PARA PRODUTOS SN 04------------*/ 
PIS_COFINS_SN04 AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_CST04 A
         INNER JOIN VIEW_JC_TABELABASE_SN B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
         WHERE (
            CASE
                WHEN A.CODTRIBPISCOFINS = 2 THEN 1
                ELSE 0
            END
        ) = 0
    ),  

/*----VERIFICACAO DOS CST DE PIS COFINS PARA PRODUTOS SN 06------------*/ 
PIS_COFINS_SN06 AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_CST06 A
         INNER JOIN VIEW_JC_TABELABASE_SN B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
         WHERE (
            CASE
                WHEN A.CODTRIBPISCOFINS = 3 THEN 1
                ELSE 0
            END
        ) = 0
    ), 
   
/*----VERIFICACAO DOS CST DE PIS COFINS PARA PRODUTOS SN 49------------*/ 
PIS_COFINS_SN49 AS (
        SELECT A.*
          FROM VIEW_JC_TABELABASE_CST01 A
         INNER JOIN VIEW_JC_TABELABASE_SN B ON A.CODFILIAL = B.CODFILIAL
           AND A.UFDESTINO = B.UFDESTINO
           AND A.CODPROD = B.CODPROD
         WHERE (
            CASE
                WHEN A.CODTRIBPISCOFINS = 4 THEN 1
                ELSE 0
            END
        ) = 0
    ) 
   
/*-----RESULTADO DAS TABELAS VIRTUAIS-------------*/
    SELECT *
      FROM PIS_COFINS_LC01
    UNION
    SELECT *
      FROM PIS_COFINS_LC04
    UNION
    SELECT *
      FROM PIS_COFINS_LC06
    UNION
    SELECT *
      FROM PIS_COFINS_SN04
    UNION
    SELECT *
      FROM PIS_COFINS_SN06
    UNION
    SELECT *
      FROM PIS_COFINS_SN49;
/