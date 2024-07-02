WITH PRODUTO_ESTOQUE AS
 (SELECT E.CODFILIAL,
         F.CODFORNECPRINC,
         P.CODPROD,
         P.CODNCMEX NCM,
         P.IMPORTADO,
         P.CODMARCA,
         M.MARCA,
         P.CODLINHAPROD AS CODLINHA,
         L.DESCRICAO AS LINHA_PROD,
         E.QTESTGER AS QTESTOQUE,
         E.CUSTOPROXIMACOMPRA
    FROM PCPRODUT P
   INNER JOIN PCPRODFILIAL D ON P.CODPROD = D.CODPROD
    LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
    LEFT JOIN PCEST E ON P.CODPROD = E.CODPROD
                     AND D.CODFILIAL = E.CODFILIAL
    LEFT JOIN PCLINHAPROD L ON P.CODLINHAPROD = L.CODLINHA
    LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
   WHERE D.ENVIARFORCAVENDAS = 'S'
     AND NVL(P.OBS2, '0') NOT IN ('FL'))
SELECT *
  FROM (SELECT P.CODFILIAL,
               P.CODPROD,
               P.DESCRICAO,
               E.NCM,
               E.IMPORTADO,
               E.CODLINHA,
               E.LINHA_PROD,
               E.MARCA,
               P.NUMREGIAO,
               P.REGIAO,
               E.QTESTOQUE,
               P.MARGEM AS MIDEAL,
               ROUND(P.MARGEMPRECIFICACAO, 2) AS MPRECO,
               ROUND(E.CUSTOPROXIMACOMPRA, 4) CUSTOPROXIMACOMPRA,
               ROUND(L.PLIQUIDO, 4) AS CUSTOLIQAPLIC,
               ROUND(P.CUSTOSELECIONADO /
                     (1 - ((P.CODICMTAB + P.MARGEM) / 100)),
                     4) AS PSUGERIDO,
               ROUND(P.PVENDA, 4) AS PVENDA
          FROM VW_PRECIFICACAO P
          LEFT JOIN VIEW_JC_CUSTOLIQ_240 L ON P.CODPROD = L.CODPROD
                                          AND P.CODFILIAL = L.CODFILIAL
          LEFT JOIN PRODUTO_ESTOQUE E ON P.CODPROD = E.CODPROD
                                     AND P.CODFILIAL = E.CODFILIAL
         WHERE P.CODFILIAL = '2'
           AND P.NUMREGIAO IN (1, 3, 4)
           AND E.CODFORNECPRINC = 2
           AND P.CODPROD NOT IN (805833,
                                 811191,
                                 811375,
                                 814354,
                                 814403,
                                 815147,
                                 815148,
                                 815149,
                                 815160,
                                 815161,
                                 817172,
                                 817173,
                                 817179,
                                 817394,
                                 817395,
                                 817411,
                                 817413,
                                 817414,
                                 817419)
         ORDER BY P.CODPROD, P.NUMREGIAO)
 WHERE MIDEAL <> MPRECO
    OR ABS(CUSTOPROXIMACOMPRA - CUSTOLIQAPLIC) > 0.0001
    OR (PSUGERIDO <> PVENDA AND ABS(PSUGERIDO - PVENDA) > 0.9001)
    OR (NCM = '49019900.' AND MIDEAL <> 37.73)
    OR (NCM <> '49019900.' AND NUMREGIAO = 1 AND MIDEAL <> 30.78)
    OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 3 AND MIDEAL <> 34.91)
    OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 4 AND MIDEAL <> 33.03)
    OR (NCM <> '49019900.' AND IMPORTADO = 'S' AND NUMREGIAO IN (3, 4) AND MIDEAL <> 36.03)
