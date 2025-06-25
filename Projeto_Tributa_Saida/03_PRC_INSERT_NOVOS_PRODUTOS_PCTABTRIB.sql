CREATE OR REPLACE PROCEDURE PRC_JC_INSERT_NOVOS_PRODUTOS_PCTABTRIB AS

BEGIN

  FOR r IN (WITH PRODUTOS_SEM_TRIBUTACAO AS
               (SELECT S.CODPROD,
                      S.CODNCMEX,
                      S.IMPORTADO,
                      S.CODFILIAL,
                      S.UF,
                      F.CODTIPOEMPRESA
                 FROM VIEW_JC_PRODUTO_SEM_TRIB_SAIDA S
                 JOIN JC_TIPO_EMPRESA_FILIAL F ON F.CODFILIAL = S.CODFILIAL)
              
              SELECT S.CODPROD,
                     S.CODNCMEX,
                     S.IMPORTADO,
                     S.CODFILIAL,
                     S.UF,
                     T.CODST,
                     T.CODPISCOFINS
                FROM PRODUTOS_SEM_TRIBUTACAO S
                JOIN JC_CONFIGURA_TRIB_SAIDA T ON T.CODNCMEX = S.CODNCMEX
                                              AND T.UF = S.UF
                                              AND T.CODTIPOEMPRESA = S.CODTIPOEMPRESA
                                              AND T.IMPORTADO = S.IMPORTADO)
  
  LOOP
    BEGIN
    
      --INSERT DA TRIBUTAÇÃO DE SAIDA
      INSERT INTO PCTABTRIB
        (CODPROD,
         CODFILIALNF,
         UFDESTINO,
         CODST,
         DTULTALTER,
         CODTRIBPISCOFINS,
         IDENTIFICARTRIB,
         IDENTIFICARTRIBIPI,
         IDENTIFICARTRIBPISCOFINS,
         DTMXSALTER)
      VALUES
        (r.CODPROD,
         r.CODFILIAL,
         r.UF,
         r.CODST,
         SYSDATE,
         r.CODPISCOFINS,
         NULL,
         NULL,
         NULL,
         NULL);
    
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro encontrado: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20000, 'Erro durante a insercao na tabela: ' || SQLERRM);
    END;
  END LOOP;

  COMMIT;

END;
