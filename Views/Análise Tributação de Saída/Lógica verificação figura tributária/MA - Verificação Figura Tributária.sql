/*-------------------------------------VERIFICAÇÃO DO CODST MA - LUCRO REAL E SIMPLES NACIONAL -----------------------------------*/

CREATE OR REPLACE VIEW VIEW_JC_VERIFICA_CODST_MA AS
WITH
--LUCRO REAL DIF ALIQ
LC_ST AS
 (SELECT A.*
    FROM VIEW_JC_TABELABASE_LR A
   INNER JOIN VIEW_JC_NCMTABELABASE_MA B --CONSIDERAR PRODUTOS COM NCM DIF ALIQ
      ON A.CODFILIAL = B.CODFILIAL
     AND A.UFDESTINO = B.UFDESTINO
     AND A.CODPROD = B.CODPROD
   LEFT JOIN VIEW_JC_ICMS_CST40_41 C --DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS
      ON A.CODFILIAL = C.CODFILIAL
     AND A.UFDESTINO = C.UFDESTINO
     AND A.CODPROD = C.CODPROD     
   WHERE (C.CODPROD IS NULL)
    AND ((CASE WHEN A.IMPORTADO = 'N' THEN
              (CASE WHEN A.CODST = 104 THEN 1 ELSE 0 END) --SE FOR NACIONAL
         ELSE (CASE WHEN A.CODST = 93 THEN 1 ELSE 0 END) --SE FOR IMPORTADO
         END) = 0 OR (
            /*VERFICA CST PISCOFINS 01 PARA PRODUTOS ST*/
            CASE
                WHEN A.CODTRIBPISCOFINS = 1 THEN 1
                ELSE 0
            END
        ) = 0)),

         
--LUCRO REAL OUTROS PRODUTOS
LC_NORMAL AS
 (SELECT A.*
    FROM VIEW_JC_TABELABASE_LR A
   LEFT JOIN VIEW_JC_NCMTABELABASE_MA B --DESCONSIDERAR PRODUTOS COM NCM DIF ALIQ
      ON A.CODFILIAL = B.CODFILIAL
     AND A.UFDESTINO = B.UFDESTINO
     AND A.CODPROD = B.CODPROD
   LEFT JOIN VIEW_JC_ICMS_CST40_41 C --DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS
      ON A.CODFILIAL = C.CODFILIAL
     AND A.UFDESTINO = C.UFDESTINO
     AND A.CODPROD = C.CODPROD    
   LEFT JOIN VIEW_JC_ICMS_ST_SEM_PISCOFINS D --DESCONSIDERAR PRODUTOS ICMS E ST ISENTOS DE ICMS E PIS COFINS 04/06
      ON A.CODFILIAL = D.CODFILIAL
     AND A.UFDESTINO = D.UFDESTINO
     AND A.CODPROD = D.CODPROD   
   WHERE A.UFDESTINO = 'MA'
    AND (B.CODPROD IS NULL AND C.CODPROD IS NULL AND D.CODPROD IS NULL)
    AND (CASE WHEN A.IMPORTADO = 'N' THEN
              (CASE WHEN A.CODST = 90 THEN 1 ELSE 0 END) --SE FOR NACIONAL
         ELSE (CASE WHEN A.CODST = 89 THEN 1 ELSE 0 END) --SE FOR IMPORTADO
         END) = 0 ),

LC_SEMPISCOFINS AS
 (SELECT A.*
    FROM VIEW_JC_TABELABASE_LR A
   INNER JOIN VIEW_JC_ICMS_ST_SEM_PISCOFINS B --CONSIDERAR PRODUTOS ICMS E ST ISENTOS DE ICMS E PIS COFINS 04/06
      ON A.CODFILIAL = B.CODFILIAL
     AND A.UFDESTINO = B.UFDESTINO
     AND A.CODPROD = B.CODPROD
    AND A.UFDESTINO = 'MA'
    AND (CASE WHEN A.IMPORTADO = 'N' THEN
              (CASE WHEN A.CODST = 112 THEN 1 ELSE 0 END) --SE FOR NACIONAL
         ELSE (CASE WHEN A.CODST = 87 THEN 1 ELSE 0 END) --SE FOR IMPORTADO
         END) = 0 ),  
 
                        
--SIMPLES NACIONAL DIF ALIQ
SN_ST AS
 (SELECT A.*
    FROM VIEW_JC_TABELABASE_SN A
   INNER JOIN VIEW_JC_NCMTABELABASE_MA B --CONSIDERAR PRODUTOS COM NCM DIF ALIQ
      ON A.CODFILIAL = B.CODFILIAL
     AND A.UFDESTINO = B.UFDESTINO
     AND A.CODPROD = B.CODPROD
   LEFT JOIN VIEW_JC_ICMS_CST40_41 C --DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS
      ON A.CODFILIAL = C.CODFILIAL
     AND A.UFDESTINO = C.UFDESTINO
     AND A.CODPROD = C.CODPROD         
   WHERE (C.CODPROD IS NULL)
    AND (CASE WHEN A.IMPORTADO = 'N' THEN
              (CASE WHEN A.CODST = 129 THEN 1 ELSE 0 END) --SE FOR NACIONAL
         ELSE (CASE WHEN A.CODST = 124 THEN 1 ELSE 0 END) --SE FOR IMPORTADO
         END) = 0 ),
 
         
--SIMPLES NACIONAL OUTROS PRODUTOS
SN_NORMAL AS
 (SELECT A.*
    FROM VIEW_JC_TABELABASE_SN A
   LEFT JOIN VIEW_JC_NCMTABELABASE_MA B --DESCONSIDERAR PRODUTOS COM NCM DIF ALIQ
      ON A.CODFILIAL = B.CODFILIAL
     AND A.UFDESTINO = B.UFDESTINO
     AND A.CODPROD = B.CODPROD
   LEFT JOIN VIEW_JC_ICMS_CST40_41 C --DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS
      ON A.CODFILIAL = C.CODFILIAL
     AND A.UFDESTINO = C.UFDESTINO
     AND A.CODPROD = C.CODPROD    
   WHERE A.UFDESTINO = 'MA'
    AND (B.CODPROD IS NULL AND C.CODPROD IS NULL)
    AND (CASE WHEN A.CODST = 118 THEN 1 ELSE 0 END) = 0 )

-------RESULTADO DAS TABELAS VIRTUAIS-------------
      SELECT * FROM LC_ST
UNION SELECT * FROM LC_NORMAL
UNION SELECT * FROM LC_SEMPISCOFINS
UNION SELECT * FROM SN_ST
UNION SELECT * FROM SN_NORMAL;/

/*---------------------------------------VERIFICAÇÃO DO CODST MA SIMPLES NACIONAL EXCESSIVO------------------------------------------*/

CREATE OR REPLACE VIEW VIEW_JC_VERIFICA_CODST_MA_SNE AS
WITH 
--SIMPLES NACIONAL EXCESSIVO DIF ALIQ
SNE_ST AS
 (SELECT A.*
    FROM VIEW_JC_TABELABASE_SNE A
   INNER JOIN VIEW_JC_NCMTABELABASE_MA B --CONSIDERAR PRODUTOS COM NCM DIF ALIQ
      ON A.CODFILIAL = B.CODFILIAL
     AND A.UFDESTINO = B.UFDESTINO
     AND A.CODPROD = B.CODPROD
   LEFT JOIN VIEW_JC_ICMS_CST40_41 C --DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS
      ON A.CODFILIAL = C.CODFILIAL
     AND A.UFDESTINO = C.UFDESTINO
     AND A.CODPROD = C.CODPROD    
   WHERE (C.CODPROD IS NULL )
    AND (CASE WHEN A.IMPORTADO = 'N' THEN
              (CASE WHEN A.CODST = 139 THEN 1 ELSE 0 END) --SE FOR NACIONAL
         ELSE (CASE WHEN A.CODST = 110 THEN 1 ELSE 0 END) --SE FOR IMPORTADO
         END) = 0 ),


--SIMPLES NACIONAL EXCESSIVO OUTROS PRODUTOS
SNE_NORMAL AS
 (SELECT A.*
    FROM VIEW_JC_TABELABASE_SNE A
   LEFT JOIN VIEW_JC_NCMTABELABASE_MA B --DESCONSIDERAR PRODUTOS COM NCM DIF ALIQ
      ON A.CODFILIAL = B.CODFILIAL
     AND A.UFDESTINO = B.UFDESTINO
     AND A.CODPROD = B.CODPROD
   LEFT JOIN VIEW_JC_ICMS_CST40_41 C --DESCONSIDERAR PRODUTOS ISENTOS DE ICMS E PIS COFINS
      ON A.CODFILIAL = C.CODFILIAL
     AND A.UFDESTINO = C.UFDESTINO
     AND A.CODPROD = C.CODPROD      
   WHERE A.UFDESTINO = 'MA'
    AND (B.CODPROD IS NULL AND C.CODPROD IS NULL)
    AND (CASE WHEN A.IMPORTADO = 'N' THEN
              (CASE WHEN A.CODST = 112 THEN 1 ELSE 0 END) --SE FOR NACIONAL
         ELSE (CASE WHEN A.CODST = 87 THEN 1 ELSE 0 END) --SE FOR IMPORTADO
         END) = 0 )

         
-------RESULTADO DAS TABELAS VIRTUAIS-------------
      SELECT * FROM SNE_ST
UNION SELECT * FROM SNE_NORMAL;/