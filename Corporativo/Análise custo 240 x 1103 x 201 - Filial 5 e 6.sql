/*Análise custo 240 x 1103 x 201 - Filial 5 e 6*/
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
       (CASE CUSTOFIN
         WHEN 0 THEN
          NULL
         ELSE
          CUSTOFIN
       END) CUSTOFIN
  FROM (SELECT E.CODFILIAL,
               P.DTCADASTRO,
               P.CODFORNEC,
               D.FORNECEDOR,
               D.TIPOFORNEC TIPO,
               D.ESTADO,
               P.IMPORTADO,
               E.CODPROD,
               P.DESCRICAO,
               F.GERAICMSLIVROFISCAL REGIME_ICMS,
               (SELECT ENVIARFORCAVENDAS
                  FROM PCPRODFILIAL
                 WHERE CODPROD = F.CODPROD
                   AND CODFILIAL = '6') ENVIAFV_6,
               (SELECT ROUND(CUSTOPROXIMACOMPRA, 4)
                  FROM PCEST
                 WHERE CODPROD = E.CODPROD
                   AND CODFILIAL = '3') CUSTOPROXIMA_3,
               (SELECT ROUND((NVL(CUSTOREP, 0) * ((100 - PERCDESC) / 100)), 4)
                  FROM PCPRODFILIAL
                 WHERE CODPROD = E.CODPROD
                   AND CODFILIAL = '3') PBRUTO_FIL_3,
               ROUND((NVL(F.CUSTOREP, 0) * ((100 - F.PERCDESC) / 100)), 4) PBRUTO_240,
               ROUND(NVL(E.CUSTOPROXIMACOMPRA, 0), 4) PROXCOMPRA_240,
               ROUND(NVL(E.CUSTOFIN, 0), 4) CUSTOFIN
          FROM PCEST E, PCPRODUT P, PCPRODFILIAL F, PCFORNEC D
         WHERE P.CODFORNEC = D.CODFORNEC
           AND E.CODPROD = P.CODPROD
           AND F.CODPROD = P.CODPROD
           AND E.CODFILIAL = F.CODFILIAL
           AND P.CODPROD = P.CODPRODMASTER
           AND P.DTEXCLUSAO IS NULL
           AND P.TIPOMERC = 'L'
           AND P.REVENDA = 'S'
           AND E.CODFILIAL IN ('5', '6')) C
 WHERE ENVIAFV_6 = 'S'
   AND (PBRUTO_240 <> PROXCOMPRA_240 OR PROXCOMPRA_240 <> CUSTOFIN)
   AND (ABS(PBRUTO_240 - PROXCOMPRA_240) > 0.01 OR CUSTOFIN = 0 OR
       PROXCOMPRA_240 = 0 OR ABS(CUSTOFIN - PROXCOMPRA_240) > 0.10)
 ORDER BY FORNECEDOR, CODPROD;
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
       ) CUSTOFIN
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
           ROUND (NVL (E.CUSTOFIN, 0), 4) CUSTOFIN
      FROM PCEST E,
           PCPRODUT P,
           PCPRODFILIAL F,
           PCFORNEC D
     WHERE P.CODFORNEC = D.CODFORNEC
       AND E.CODPROD = P.CODPROD
       AND F.CODPROD = P.CODPROD
       AND E.CODFILIAL = F.CODFILIAL
       AND P.CODPROD = P.CODPRODMASTER
       AND P.DTEXCLUSAO IS NULL
       AND P.TIPOMERC = 'L'
       AND P.REVENDA = 'S'
       AND E.CODFILIAL IN (
        5, 6, 10
    )
) C
 WHERE CODPROD IN (
    813321, 813327, 802135, 810433, 812170, 804216, 813323, 813324, 813322, 813328, 798063
);
/