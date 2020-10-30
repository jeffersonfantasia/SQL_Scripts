SELECT *
  FROM (
    SELECT TAB.CODFILIAL,
           TAB.CODFORNEC,
           TAB.FORNECEDOR,
           TAB.CODPROD,
           TAB.DESCRICAO,
           TAB.PBRUTO_240,
           TAB.PROXCOMPRA_240,
           TAB.DTULTENT,
           TAB.DTAPLIC,
           (
               SELECT ROUND (CUSTOFIN, 4)
                 FROM PCHISTEST
                WHERE CODFILIAL = TAB.CODFILIAL
                  AND CODPROD = TAB.CODPROD
                  AND DATA = TAB.DTAPLIC - 1
           ) APLIC_CUSTOFIN_ANT,
           (
               SELECT ROUND (MIN (CUSTOFINATUAL), 4)
                 FROM PCAPLICVERBAI
                WHERE CODFILIAL = TAB.CODFILIAL
                  AND CODPROD = TAB.CODPROD
                  AND DTAPLIC = TAB.DTAPLIC
           ) APLIC_CUSTOFIN,
           (
               SELECT VALORULTENT
                 FROM PCHISTEST
                WHERE CODFILIAL = TAB.CODFILIAL
                  AND CODPROD = TAB.CODPROD
                  AND DATA = TAB.DTAPLIC - 1
           ) APLIC_ULTENT_ANT,
           (
               SELECT VALORULTENT
                 FROM PCHISTEST
                WHERE CODFILIAL = TAB.CODFILIAL
                  AND CODPROD = TAB.CODPROD
                  AND DATA = TRUNC (SYSDATE) - 1
           ) APLIC_ULTENT_ATUAL,
           TAB.CUSTOFIN_1103,
           TAB.VALORULTENT_1103
      FROM (
        SELECT E.CODFILIAL,
               P.CODFORNEC,
               D.FORNECEDOR,
               E.CODPROD,
               P.DESCRICAO,
               ROUND ((F.CUSTOREP * ((100 - F.PERCDESC) / 100)), 4) PBRUTO_240,
               ROUND (E.CUSTOPROXIMACOMPRA, 4) PROXCOMPRA_240,
               E.DTULTENT,
               ROUND (E.CUSTOFIN, 4) CUSTOFIN_1103,
               E.VALORULTENT VALORULTENT_1103,
               (
                   SELECT MAX (DTAPLIC)
                     FROM PCAPLICVERBAI
                    WHERE CODFILIAL = E.CODFILIAL
                      AND CODPROD = E.CODPROD
                      AND ROTINALANC = 'PCSIS1806.EXE'
               ) DTAPLIC
          FROM PCEST E,
               PCPRODUT P,
               PCPRODFILIAL F,
               PCFORNEC D
         WHERE P.CODFORNEC = D.CODFORNEC
           AND E.CODPROD = P.CODPROD
           AND F.CODPROD = P.CODPROD
           AND E.CODFILIAL = F.CODFILIAL
           AND P.DTEXCLUSAO IS NULL
           AND P.TIPOMERC = 'L'
           AND P.REVENDA = 'S'
           AND E.CODFILIAL IN (
            1, 2, 7
        )
    ) TAB
)
 WHERE DTAPLIC IS NOT NULL
   AND DTAPLIC >= DTULTENT
   AND DTAPLIC >= TRUNC (SYSDATE) - 2
 ORDER BY DTAPLIC DESC,
          CODFILIAL;
/