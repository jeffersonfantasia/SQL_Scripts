WITH PRODUTO_ESTOQUE AS
 (SELECT E.CODFILIAL,
         F.CODFORNECPRINC,
         P.CODPROD,
         P.CODNCMEX NCM,
         CASE
           WHEN P.NBM = '49019900' THEN
            'L'
           ELSE
            P.IMPORTADO
         END IMPORTADO,
         P.CODMARCA,
         M.MARCA,
         P.CODLINHAPROD AS CODLINHA,
         L.DESCRICAO AS LINHA_PROD,
         E.QTESTGER AS QTESTOQUE,
         E.CUSTOPROXIMACOMPRA
    FROM PCPRODUT P
    JOIN PCPRODFILIAL D ON P.CODPROD = D.CODPROD
    LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
    LEFT JOIN PCEST E ON P.CODPROD = E.CODPROD
                     AND D.CODFILIAL = E.CODFILIAL
    LEFT JOIN PCLINHAPROD L ON P.CODLINHAPROD = L.CODLINHA
    LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
    LEFT JOIN PCEMBALAGEM E ON P.CODPROD = E.CODPROD
                           AND E.CODFILIAL = D.CODFILIAL
                           AND E.UNIDADE = 'UN'
   WHERE F.CODFORNECPRINC = 2
     AND P.DTEXCLUSAO IS NULL
     AND P.OBS2 <> 'FL'
     AND P.CODPRODMASTER = P.CODPROD
     AND D.CODFILIAL IN ( '11')
     AND P.ENVIARFORCAVENDAS = 'S'
     AND D.ENVIARFORCAVENDAS = 'S'
     AND E.ENVIAFV = 'S'),

ANALISE_PRODUTOS_TABELA AS
 (SELECT *
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
                 ROUND(P.CUSTOSELECIONADO / (1 - ((P.CODICMTAB + P.MARGEM) / 100)), 4) AS PSUGERIDO,
                 ROUND(P.PVENDA, 4) AS PVENDA
            FROM VW_PRECIFICACAO P
            JOIN PCREGIAO R ON R.CODFILIAL = P.CODFILIAL
                           AND R.NUMREGIAO = P.NUMREGIAO
            LEFT JOIN VIEW_JC_CUSTOLIQ_240 L ON P.CODPROD = L.CODPROD
                                            AND P.CODFILIAL = L.CODFILIAL
            LEFT JOIN PRODUTO_ESTOQUE E ON P.CODPROD = E.CODPROD
                                       AND P.CODFILIAL = E.CODFILIAL
           WHERE P.CODFILIAL IN ('11')
             AND P.NUMREGIAO IN (1, 3, 4, 7)
             AND E.CODFORNECPRINC = 2
                --PROMOCIONAIS 2024
             AND P.CODPROD NOT IN (815147, 815149, 815160, 817173, 817179, 817394)
                --PROMOCIONAIS FEV-2025
             AND P.CODPROD NOT IN (797023,
                                   814371,
                                   814350,
                                   817176,
                                   817398,
                                   817177,
                                   817178,
                                   822256,
                                   811430,
                                   811634,
                                   811446,
                                   814409,
                                   815163,
                                   817396,
                                   817397,
                                   818926,
                                   818927,
                                   823755,
                                   823756)
           ORDER BY P.CODPROD,
                    P.NUMREGIAO)
   WHERE MIDEAL <> MPRECO
      OR ABS(CUSTOPROXIMACOMPRA - CUSTOLIQAPLIC) > 0.0001
      OR (PSUGERIDO <> PVENDA AND ABS(PSUGERIDO - PVENDA) > 0.9001)
      OR (NCM = '49019900.' AND MIDEAL <> 37.73)
      OR (NCM <> '49019900.' AND NUMREGIAO = 1 AND MIDEAL <> 30.78)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 3 AND MIDEAL <> 34.91)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 4 AND MIDEAL <> 33.32)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 7 AND MIDEAL <> 35.21)
      OR (NCM <> '49019900.' AND IMPORTADO = 'S' AND NUMREGIAO IN (3, 4) AND MIDEAL <> 36.03)
      OR (NCM <> '49019900.' AND IMPORTADO = 'S' AND NUMREGIAO = 7 AND MIDEAL <> 37.63)),

ANALISE_PRODUTOS_PROMOCIONAIS_2024 AS
 (SELECT *
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
                 ROUND(P.CUSTOSELECIONADO / (1 - ((P.CODICMTAB + P.MARGEM) / 100)), 4) AS PSUGERIDO,
                 ROUND(P.PVENDA, 4) AS PVENDA
            FROM VW_PRECIFICACAO P
            JOIN PCREGIAO R ON R.CODFILIAL = P.CODFILIAL
                           AND R.NUMREGIAO = P.NUMREGIAO
            LEFT JOIN VIEW_JC_CUSTOLIQ_240 L ON P.CODPROD = L.CODPROD
                                            AND P.CODFILIAL = L.CODFILIAL
            LEFT JOIN PRODUTO_ESTOQUE E ON P.CODPROD = E.CODPROD
                                       AND P.CODFILIAL = E.CODFILIAL
           WHERE P.CODFILIAL IN ('11')
             AND P.NUMREGIAO IN (1, 3, 4, 7)
             AND P.CODPROD IN (815147, 815149, 815160, 817173, 817179, 817394)
           ORDER BY P.CODPROD,
                    P.NUMREGIAO)
   WHERE MIDEAL <> MPRECO
      OR ABS(CUSTOPROXIMACOMPRA - CUSTOLIQAPLIC) > 0.0001
      OR (PSUGERIDO <> PVENDA AND ABS(PSUGERIDO - PVENDA) > 0.9001)
      OR (NCM = '49019900.' AND MIDEAL <> 34.90)
      OR (NCM <> '49019900.' AND NUMREGIAO = 1 AND MIDEAL <> 33.62)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 3 AND MIDEAL <> 37.38)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 4 AND MIDEAL <> 36.08)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 7 AND MIDEAL <> 37.38)
      OR (NCM <> '49019900.' AND IMPORTADO = 'S' AND NUMREGIAO IN (3, 4) AND MIDEAL <> 36.03)
      OR (NCM <> '49019900.' AND IMPORTADO = 'S' AND NUMREGIAO = 7 AND MIDEAL <> 37.63)),

ANALISE_PRODUTOS_PROMOCIONAIS_FEV_2025 AS
 (SELECT *
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
                 ROUND(P.CUSTOSELECIONADO / (1 - ((P.CODICMTAB + P.MARGEM) / 100)), 4) AS PSUGERIDO,
                 ROUND(P.PVENDA, 4) AS PVENDA
            FROM VW_PRECIFICACAO P
            JOIN PCREGIAO R ON R.CODFILIAL = P.CODFILIAL
                           AND R.NUMREGIAO = P.NUMREGIAO
            LEFT JOIN VIEW_JC_CUSTOLIQ_240 L ON P.CODPROD = L.CODPROD
                                            AND P.CODFILIAL = L.CODFILIAL
            LEFT JOIN PRODUTO_ESTOQUE E ON P.CODPROD = E.CODPROD
                                       AND P.CODFILIAL = E.CODFILIAL
           WHERE P.CODFILIAL IN ('11')
             AND P.NUMREGIAO IN (1, 3, 4, 7)
             AND P.CODPROD IN (797023,
                               814371,
                               814350,
                               817176,
                               817398,
                               817177,
                               817178,
                               822256,
                               811430,
                               811634,
                               811446,
                               814409,
                               815163,
                               817396,
                               817397,
                               818926,
                               818927,
                               823755,
                               823756)
           ORDER BY P.CODPROD,
                    P.NUMREGIAO)
   WHERE MIDEAL <> MPRECO
      OR ABS(CUSTOPROXIMACOMPRA - CUSTOLIQAPLIC) > 0.0001
      OR (PSUGERIDO <> PVENDA AND ABS(PSUGERIDO - PVENDA) > 0.9001)
      OR (NCM = '49019900.' AND MIDEAL <> 40.84)
      OR (NCM <> '49019900.' AND NUMREGIAO = 1 AND MIDEAL <> 32.96)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 3 AND MIDEAL <> 37.38)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 4 AND MIDEAL <> 35.65)
      OR (NCM <> '49019900.' AND IMPORTADO = 'N' AND NUMREGIAO = 7 AND MIDEAL <> 37.67)
      OR (NCM <> '49019900.' AND IMPORTADO = 'S' AND NUMREGIAO IN (3, 4) AND MIDEAL <> 38.59)
      OR (NCM <> '49019900.' AND IMPORTADO = 'S' AND NUMREGIAO = 7 AND MIDEAL <> 40.11))

SELECT *
  FROM ANALISE_PRODUTOS_TABELA
UNION ALL
SELECT *
  FROM ANALISE_PRODUTOS_PROMOCIONAIS_2024
UNION ALL
SELECT * FROM ANALISE_PRODUTOS_PROMOCIONAIS_FEV_2025
