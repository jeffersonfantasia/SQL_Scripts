-----ANALISE MARGEM PRODUTOS ESTRELA
SELECT *
  FROM (SELECT T.CODPROD,
               P.DESCRICAO,
               P.CODNCMEX,
               T.NUMREGIAO,
               R.REGIAO,
               T.MARGEM,
               (CASE
               ----PRODUTOS PROMOCIONAIS 2024
                 WHEN T.CODPROD IN (815147, 815149, 815160, 817173, 817179, 817394) THEN
                  (CASE
                    WHEN P.CODNCMEX = '49019900.' THEN
                     34.90
                    WHEN P.CODNCMEX <> '49019900.'
                         AND T.NUMREGIAO = 1 THEN
                     33.62
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'N'
                         AND T.NUMREGIAO = 3 THEN
                     37.38
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'N'
                         AND T.NUMREGIAO = 4 THEN
                     36.08
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'N'
                         AND T.NUMREGIAO = 7 THEN
                     37.38
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'S'
                         AND T.NUMREGIAO IN (3, 4) THEN
                     36.03
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'S'
                         AND T.NUMREGIAO = 7 THEN
                     37.63
                    ELSE
                     NULL
                  END)
               ----PRODUTOS PROMOCIONAIS FEV-2025
                 WHEN T.CODPROD IN (131416,
                                    131417,
                                    797023,
                                    800586,
                                    811625,
                                    814371,
                                    814350,
                                    817176,
                                    817398,
                                    817177,
                                    817178,
                                    822255,
                                    822256,
                                    809390,
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
                                    823756) THEN
                  (CASE
                    WHEN P.CODNCMEX = '49019900.' THEN
                     40.84
                    WHEN P.CODNCMEX <> '49019900.'
                         AND T.NUMREGIAO = 1 THEN
                     32.96
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'N'
                         AND T.NUMREGIAO = 3 THEN
                     37.38
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'N'
                         AND T.NUMREGIAO = 4 THEN
                     35.65
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'N'
                         AND T.NUMREGIAO = 7 THEN
                     37.67
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'S'
                         AND T.NUMREGIAO IN (3, 4) THEN
                     38.59
                    WHEN P.CODNCMEX <> '49019900.'
                         AND P.IMPORTADO = 'S'
                         AND T.NUMREGIAO = 7 THEN
                     40.11
                    ELSE
                     NULL
                  END)
               ----MARGEM PADRAO
                 WHEN P.CODNCMEX = '49019900.' THEN
                  37.73
                 WHEN P.CODNCMEX <> '49019900.'
                      AND T.NUMREGIAO = 1 THEN
                  30.78
                 WHEN P.CODNCMEX <> '49019900.'
                      AND P.IMPORTADO = 'N'
                      AND T.NUMREGIAO = 3 THEN
                  34.91
                 WHEN P.CODNCMEX <> '49019900.'
                      AND P.IMPORTADO = 'N'
                      AND T.NUMREGIAO = 4 THEN
                  33.32
                 WHEN P.CODNCMEX <> '49019900.'
                      AND P.IMPORTADO = 'N'
                      AND T.NUMREGIAO = 7 THEN
                  35.21
                 WHEN P.CODNCMEX <> '49019900.'
                      AND P.IMPORTADO = 'S'
                      AND T.NUMREGIAO IN (3, 4) THEN
                  36.03
                 WHEN P.CODNCMEX <> '49019900.'
                      AND P.IMPORTADO = 'S'
                      AND T.NUMREGIAO = 7 THEN
                  37.63
                 ELSE
                  NULL
               END) MARGEM_CALC
          FROM PCTABPR T
          JOIN PCREGIAO R ON R.NUMREGIAO = T.NUMREGIAO
          JOIN PCPRODUT P ON P.CODPROD = T.CODPROD
          JOIN PCFORNEC F ON F.CODFORNEC = P.CODFORNEC
         WHERE F.CODFORNECPRINC = 2
           AND T.NUMREGIAO IN (1, 3, 4, 7))
 WHERE MARGEM <> MARGEM_CALC;

----UPDATE
MERGE INTO PCTABPR T
USING (SELECT *
         FROM (SELECT T.CODPROD,
                      P.DESCRICAO,
                      P.CODNCMEX,
                      T.NUMREGIAO,
                      R.REGIAO,
                      T.MARGEM,
                      (CASE
                      ----PRODUTOS PROMOCIONAIS 2024
                        WHEN T.CODPROD IN (815147, 815149, 815160, 817173, 817179, 817394) THEN
                         (CASE
                           WHEN P.CODNCMEX = '49019900.' THEN
                            34.90
                           WHEN P.CODNCMEX <> '49019900.'
                                AND T.NUMREGIAO = 1 THEN
                            33.62
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'N'
                                AND T.NUMREGIAO = 3 THEN
                            37.38
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'N'
                                AND T.NUMREGIAO = 4 THEN
                            36.08
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'N'
                                AND T.NUMREGIAO = 7 THEN
                            37.38
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'S'
                                AND T.NUMREGIAO IN (3, 4) THEN
                            36.03
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'S'
                                AND T.NUMREGIAO = 7 THEN
                            37.63
                           ELSE
                            NULL
                         END)
                      ----PRODUTOS PROMOCIONAIS FEV-2025
                        WHEN T.CODPROD IN (131416,
                                           131417,
                                           797023,
                                           800586,
                                           811625,
                                           814371,
                                           814350,
                                           817176,
                                           817398,
                                           817177,
                                           817178,
                                           822255,
                                           822256,
                                           809390,
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
                                           823756) THEN
                         (CASE
                           WHEN P.CODNCMEX = '49019900.' THEN
                            40.84
                           WHEN P.CODNCMEX <> '49019900.'
                                AND T.NUMREGIAO = 1 THEN
                            32.96
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'N'
                                AND T.NUMREGIAO = 3 THEN
                            37.38
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'N'
                                AND T.NUMREGIAO = 4 THEN
                            35.65
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'N'
                                AND T.NUMREGIAO = 7 THEN
                            37.67
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'S'
                                AND T.NUMREGIAO IN (3, 4) THEN
                            38.59
                           WHEN P.CODNCMEX <> '49019900.'
                                AND P.IMPORTADO = 'S'
                                AND T.NUMREGIAO = 7 THEN
                            40.11
                           ELSE
                            NULL
                         END)
                      ----MARGEM PADRAO
                        WHEN P.CODNCMEX = '49019900.' THEN
                         37.73
                        WHEN P.CODNCMEX <> '49019900.'
                             AND T.NUMREGIAO = 1 THEN
                         30.78
                        WHEN P.CODNCMEX <> '49019900.'
                             AND P.IMPORTADO = 'N'
                             AND T.NUMREGIAO = 3 THEN
                         34.91
                        WHEN P.CODNCMEX <> '49019900.'
                             AND P.IMPORTADO = 'N'
                             AND T.NUMREGIAO = 4 THEN
                         33.32
                        WHEN P.CODNCMEX <> '49019900.'
                             AND P.IMPORTADO = 'N'
                             AND T.NUMREGIAO = 7 THEN
                         35.21
                        WHEN P.CODNCMEX <> '49019900.'
                             AND P.IMPORTADO = 'S'
                             AND T.NUMREGIAO IN (3, 4) THEN
                         36.03
                        WHEN P.CODNCMEX <> '49019900.'
                             AND P.IMPORTADO = 'S'
                             AND T.NUMREGIAO = 7 THEN
                         37.63
                        ELSE
                         NULL
                      END) MARGEM_CALC
                 FROM PCTABPR T
                 JOIN PCREGIAO R ON R.NUMREGIAO = T.NUMREGIAO
                 JOIN PCPRODUT P ON P.CODPROD = T.CODPROD
                 JOIN PCFORNEC F ON F.CODFORNEC = P.CODFORNEC
                WHERE F.CODFORNECPRINC = 2
                  AND T.NUMREGIAO IN (1, 3, 4, 7))
        WHERE MARGEM <> MARGEM_CALC) X
ON (X.CODPROD = T.CODPROD AND X.NUMREGIAO = T.NUMREGIAO)
WHEN MATCHED THEN
  UPDATE SET T.MARGEM = X.MARGEM_CALC
