--UPDATE

BEGIN

END;

--SELECT * FROM PCENCERRAMENTOFINANCEIRO F WHERE F.ANO = 2025 AND F.MES = 06

/*
   MERGE INTO PCLANC L
   USING (SELECT L.DTEMISSAO,
                 L.DTCOMPETENCIA,
                 L.DTLANC,
                 L.RECNUM,
                 L.CODCONTA,
                 L.CODFORNEC,
                 L.HISTORICO,
                 L.NUMNOTA,
                 L.DUPLIC,
                 L.VALOR,
                 L.DTVENC,
                 L.TIPOLANC,
                 L.FORNECEDOR
            FROM PCLANC L
           WHERE L.DTPAGTO IS NULL
             AND L.DTCOMPETENCIA <= '30/06/2025'
             AND L.CODCONTA NOT IN (100001, 3703, 2253, 2251,2254, 2255, 2256, 2257, 2261)) X
   
   ON (L.RECNUM = X.RECNUM)
   WHEN MATCHED THEN
     UPDATE SET L.DTCOMPETENCIA = X.DTVENC

SELECT l.rowid, L.DTEMISSAO,
                 L.DTCOMPETENCIA,
                 L.DTLANC,
                 L.RECNUM,
                 L.CODCONTA,
                 L.CODFORNEC,
                 L.HISTORICO,
                 L.NUMNOTA,
                 L.DUPLIC,
                 L.VALOR,
                 L.DTVENC,
                 L.TIPOLANC,
                 L.FORNECEDOR
            FROM PCLANC L
           WHERE L.DTPAGTO IS NULL
             AND L.DTCOMPETENCIA <= '30/06/2025'
             AND L.CODCONTA NOT IN (100001, 3703, 2253, 2251,2254, 2255, 2256, 2257, 2261);



DELETE PCENCERRAMENTOFINANCEIRO;



BEGIN
 PRC_FECHAMENTO_FINANCEIRO(TO_DATE('30/06/2025', 'DD/MM/YYYY'));
END;

*/

/*
BEGIN
  BEGIN
    PRC_SINC_TABELAS_DW;
  END;
  
  BEGIN
  FOR REC IN (
        SELECT OBJECT_NAME
        FROM USER_OBJECTS
        WHERE OBJECT_TYPE = 'TABLE'
    ) LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || REC.OBJECT_NAME || ' TO CONSULTA';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE ON ' || REC.OBJECT_NAME || ' TO BROKER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || REC.OBJECT_NAME || ' TO BIJC';
    END LOOP;
	END;	

END; */ 

