 SELECT * FROM
 (SELECT (SELECT PCPRODUT.CODPROD
            FROM PCPRODUT
           WHERE P.CODPRODMASTER = PCPRODUT.CODPROD) COD_PAI,
         (SELECT PCPRODUT.CODFAB
            FROM PCPRODUT
           WHERE P.CODPRODMASTER = PCPRODUT.CODPROD) FAB_PAI,
         (SELECT PCPRODUT.DESCRICAO
            FROM PCPRODUT
           WHERE P.CODPRODMASTER = PCPRODUT.CODPROD) PRODUTO_PAI,
         (SELECT PCPRODUT.CODNCMEX
            FROM PCPRODUT
           WHERE P.CODPRODMASTER = PCPRODUT.CODPROD) CODNCMEX_PAI,
         (SELECT PCPRODUT.CODFORNEC
            FROM PCPRODUT
           WHERE P.CODPRODMASTER = PCPRODUT.CODPROD) CODFORNEC_PAI, 
         P.CODPROD COD_FILHO,
         P.CODFAB FAB_FILHO,
         P.DESCRICAO PRODUTO_FILHO,
         P.CODNCMEX NCMEX_FILHO,
         P.CODFORNEC FORNEC_FILHO
          FROM PCPRODUT P )
         WHERE (CODNCMEX_PAI <> NCMEX_FILHO OR FORNEC_FILHO <> CODFORNEC_PAI)
         ORDER BY COD_PAI, FAB_FILHO ;