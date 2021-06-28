/*Análise custo 240 x 1103 x 201 - Filial 5 e 6*/
SELECT *
  FROM (
    SELECT CODFILIAL,
           DTCADASTRO,
           CODFORNEC,
           FORNECEDOR,
           TIPO,
           ESTADO,
           IMPORTADO,
           CODPROD,
           DESCRICAO,
           REGIME_ICMS,
           ENVIAFV_6,
           CUSTOPROXIMA_3,
           PBRUTO_FIL_3,
           PBRUTO_240,
           PROXCOMPRA_240,
           (
               CASE CUSTOFIN
                   WHEN 0 THEN NULL
                   ELSE CUSTOFIN
               END
           ) CUSTOFIN,
           (
               CASE PVENDA_R5
                   WHEN 0 THEN NULL
                   ELSE PVENDA_R5
               END
           ) PVENDA_R5,
           MARGEM
      FROM (
        SELECT E.CODFILIAL,
               P.DTCADASTRO,
               P.CODFORNEC,
               D.FORNECEDOR,
               D.TIPOFORNEC TIPO,
               D.ESTADO,
               P.IMPORTADO,
               E.CODPROD,
               P.DESCRICAO,
               F.GERAICMSLIVROFISCAL REGIME_ICMS,
               (
                   SELECT ENVIARFORCAVENDAS
                     FROM PCPRODFILIAL
                    WHERE CODPROD = F.CODPROD
                      AND CODFILIAL = 6
               ) ENVIAFV_6,
               (
                   SELECT ROUND (CUSTOPROXIMACOMPRA, 4)
                     FROM PCEST
                    WHERE CODPROD = E.CODPROD
                      AND CODFILIAL = 3
               ) CUSTOPROXIMA_3,
               (
                   SELECT ROUND ((NVL (CUSTOREP, 0) * ((100 - PERCDESC) / 100)), 4)
                     FROM PCPRODFILIAL
                    WHERE CODPROD = E.CODPROD
                      AND CODFILIAL = 3
               ) PBRUTO_FIL_3,
               ROUND ((NVL (F.CUSTOREP, 0) * ((100 - F.PERCDESC) / 100)), 4) PBRUTO_240,
               ROUND (NVL (E.CUSTOPROXIMACOMPRA, 0), 4) PROXCOMPRA_240,
               ROUND (NVL (E.CUSTOFIN, 0), 4) CUSTOFIN,
               ROUND (NVL (T.PVENDA, 0), 4) PVENDA_R5,
               T.MARGEM
          FROM PCEST E,
               PCPRODUT P,
               PCPRODFILIAL F,
               PCTABPR T,
               PCFORNEC D
         WHERE P.CODFORNEC = D.CODFORNEC
           AND E.CODPROD = P.CODPROD
           AND F.CODPROD = P.CODPROD
           AND E.CODFILIAL = F.CODFILIAL
           AND T.CODPROD = P.CODPROD
           AND P.CODPROD = P.CODPRODMASTER
           AND P.DTEXCLUSAO IS NULL
           AND P.TIPOMERC = 'L'
           AND P.REVENDA = 'S'
           AND E.CODFILIAL IN (
            5, 6
        )
           AND T.NUMREGIAO = 5
    ) C
     WHERE ENVIAFV_6 = 'S'
     /*and CODPROD IN(808869 )*/
       AND (PBRUTO_240 <> PROXCOMPRA_240
        OR PROXCOMPRA_240 <> CUSTOFIN
        OR CUSTOFIN <> PVENDA_R5)
) D
 WHERE (ABS (1 - (NVL (CUSTOFIN, PVENDA_R5) / NVL (PVENDA_R5, CUSTOFIN))) > 0.001
       /*OR PBRUTO_240 <> PROXCOMPRA_240 */
    OR ABS (PBRUTO_240 - PROXCOMPRA_240) > 0.01
    OR CUSTOFIN IS NULL
    OR PVENDA_R5 IS NULL
    OR PROXCOMPRA_240 = 0
    OR ABS (CUSTOFIN - PROXCOMPRA_240) > 0.10)
 ORDER BY FORNECEDOR,
          CODPROD;
/
SELECT CODFILIAL,
       DTCADASTRO,
       CODFORNEC,
       FORNECEDOR,
       TIPO,
       ESTADO,
       IMPORTADO,
       CODPROD,
       DESCRICAO,
       REGIME_ICMS,
       ENVIAFV_6,
       CUSTOPROXIMA_3,
       PBRUTO_FIL_3,
       PBRUTO_240,
       PROXCOMPRA_240,
       (
           CASE CUSTOFIN
               WHEN 0 THEN NULL
               ELSE CUSTOFIN
           END
       ) CUSTOFIN,
       (
           CASE PVENDA_R5
               WHEN 0 THEN NULL
               ELSE PVENDA_R5
           END
       ) PVENDA_R5,
       MARGEM
  FROM (
    SELECT E.CODFILIAL,
           P.DTCADASTRO,
           P.CODFORNEC,
           D.FORNECEDOR,
           D.TIPOFORNEC TIPO,
           D.ESTADO,
           P.IMPORTADO,
           E.CODPROD,
           P.DESCRICAO,
           F.GERAICMSLIVROFISCAL REGIME_ICMS,
           (
               SELECT ENVIARFORCAVENDAS
                 FROM PCPRODFILIAL
                WHERE CODPROD = F.CODPROD
                  AND CODFILIAL = 6
           ) ENVIAFV_6,
           (
               SELECT ROUND (CUSTOPROXIMACOMPRA, 4)
                 FROM PCEST
                WHERE CODPROD = E.CODPROD
                  AND CODFILIAL = 3
           ) CUSTOPROXIMA_3,
           (
               SELECT ROUND ((NVL (CUSTOREP, 0) * ((100 - PERCDESC) / 100)), 4)
                 FROM PCPRODFILIAL
                WHERE CODPROD = E.CODPROD
                  AND CODFILIAL = 3
           ) PBRUTO_FIL_3,
           ROUND ((NVL (F.CUSTOREP, 0) * ((100 - F.PERCDESC) / 100)), 4) PBRUTO_240,
           ROUND (NVL (E.CUSTOPROXIMACOMPRA, 0), 4) PROXCOMPRA_240,
           ROUND (NVL (E.CUSTOFIN, 0), 4) CUSTOFIN,
           ROUND (NVL (T.PVENDA, 0), 4) PVENDA_R5,
           T.MARGEM
      FROM PCEST E,
           PCPRODUT P,
           PCPRODFILIAL F,
           PCTABPR T,
           PCFORNEC D
     WHERE P.CODFORNEC = D.CODFORNEC
       AND E.CODPROD = P.CODPROD
       AND F.CODPROD = P.CODPROD
       AND E.CODFILIAL = F.CODFILIAL
       AND T.CODPROD = P.CODPROD
           /*AND P.CODPROD = P.CODPRODMASTER*/
       AND P.DTEXCLUSAO IS NULL
       AND P.TIPOMERC = 'L'
       AND P.REVENDA = 'S'
       AND E.CODFILIAL IN (
        5, 6
    )
       AND T.NUMREGIAO = 5
) C
 WHERE CODPROD IN (
    806377, 806326
);
/