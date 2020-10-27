--Pendência cadastro produtos B2B Corporativo
WITH PRECOS_KIT AS
 (SELECT F.CODPRODACAB AS CODPROD, 
         SUM(NVL(T.PVENDA, 0)) AS PVENDA
   FROM PCFORMPROD F
  INNER JOIN PCPRODUT P
     ON P.CODPROD = F.CODPRODACAB
   LEFT JOIN PCTABPR T
     ON F.CODPRODMP = T.CODPROD
  WHERE T.NUMREGIAO = 6
    AND P.TIPOMERC IN ('CB', 'KT')
  GROUP BY F.CODPRODACAB)
 SELECT *
   FROM (SELECT F.CODFILIAL,
                F.ENVIARFORCAVENDAS,
                P.CODFORNEC,
                N.FORNECEDOR,
                F.CODPROD,
                P.DESCRICAO,
                (CASE
                  WHEN P.TIPOMERC IN ('CB', 'KT') THEN
                   K.PVENDA
                  ELSE
                   T.PVENDA
                END) AS PVENDA,
                W.NOMEECOMMERCE,
                W.TITULOPRODUTO ETIQUETA_CORP,
                W.GENEROCORPORATIVO,
                W.IDADECORPORATIVO,
                P.OBS,
                P.DTEXCLUSAO
           FROM PCPRODFILIAL F
          INNER JOIN PCPRODUT P
             ON F.CODPROD = P.CODPROD
           LEFT JOIN ESTPRODUTOWEB W
             ON F.CODPROD = W.CODPROD
           LEFT JOIN PCFORNEC N
             ON P.CODFORNEC = N.CODFORNEC
           LEFT JOIN PCTABPR T
             ON P.CODPROD = T.CODPROD
           LEFT JOIN PRECOS_KIT K
             ON P.CODPROD = K.CODPROD  
          WHERE T.NUMREGIAO = 6
            AND F.CODFILIAL = 6
            AND F.ENVIARFORCAVENDAS = 'S')
  WHERE (NOMEECOMMERCE IS NULL OR ETIQUETA_CORP IS NULL OR OBS = 'PV' OR
        DTEXCLUSAO IS NOT NULL OR PVENDA = 0 OR PVENDA IS NULL OR
        GENEROCORPORATIVO IS NULL OR IDADECORPORATIVO IS NULL)
  ORDER BY FORNECEDOR, CODPROD;
  

--Pendência cadastro produtos B2B Corporativo
 SELECT *
   FROM (SELECT F.CODFILIAL,
                F.ENVIARFORCAVENDAS,
                P.CODFORNEC,
                N.FORNECEDOR,
                F.CODPROD,
                P.DESCRICAO,
                (CASE
                  WHEN P.TIPOMERC IN ('CB', 'KT') THEN
                   1
                  ELSE
                   T.PVENDA
                END) AS PVENDA,
                W.NOMEECOMMERCE,
                W.TITULOPRODUTO ETIQUETA_CORP,
                W.GENEROCORPORATIVO,
                W.IDADECORPORATIVO,
                P.OBS,
                P.DTEXCLUSAO
           FROM PCPRODFILIAL F
          INNER JOIN PCPRODUT P
             ON F.CODPROD = P.CODPROD
           LEFT JOIN ESTPRODUTOWEB W
             ON F.CODPROD = W.CODPROD
           LEFT JOIN PCFORNEC N
             ON P.CODFORNEC = N.CODFORNEC
           LEFT JOIN PCTABPR T
             ON P.CODPROD = T.CODPROD
          /* LEFT JOIN PRECOS_KIT K
             ON P.CODPROD = K.CODPROD  */
          WHERE T.NUMREGIAO = 6
            AND F.CODFILIAL = 6
            AND F.ENVIARFORCAVENDAS = 'S')
  WHERE (NOMEECOMMERCE IS NULL OR ETIQUETA_CORP IS NULL OR OBS = 'PV' OR
        DTEXCLUSAO IS NOT NULL OR PVENDA = 0 OR PVENDA IS NULL OR
        GENEROCORPORATIVO IS NULL OR IDADECORPORATIVO IS NULL)
  ORDER BY FORNECEDOR, CODPROD;
  


