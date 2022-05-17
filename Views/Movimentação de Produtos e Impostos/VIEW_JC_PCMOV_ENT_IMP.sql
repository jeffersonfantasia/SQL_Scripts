CREATE OR REPLACE VIEW VIEW_JC_PCMOV_ENT_IMP AS
SELECT DATAMES,
       CODFILIAL,
       TIPOCONTABIL,
       SUM(VLICMS) AS VLTOTALICMS,
       SUM(VLPIS) AS VLTOTALPIS,
       SUM(VLCOFINS) AS VLTOTALCOFINS
  FROM (SELECT LAST_DAY(M.DTMOV) AS DATAMES,
               M.CODFILIAL,
               'E' AS TIPOCONTABIL,
               (CASE
                 WHEN I.GERAICMSLIVROFISCAL = 'S' THEN
                  ROUND(NVL((I.VLBASEICMS * I.PERCICM / 100), 0), 2)
                 ELSE
                  0
               END) AS VLICMS,
               ROUND(NVL(I.VLPIS, 0), 2) AS VLPIS,
               ROUND(NVL(I.VLCOFINS, 0), 2) AS VLCOFINS
          FROM PCMOV M
          LEFT JOIN PCNFENT E ON M.NUMTRANSENT = E.NUMTRANSENT
          LEFT JOIN VIEW_JC_ITEM_NOTAFISCAL I ON M.NUMTRANSENT =
                                                 I.NUMTRANSACAO
                                             AND M.NUMSEQ = I.NUMSEQ
                                             AND M.CODPROD = I.CODPROD
                                             AND M.CODFILIALNF = I.CODFILIAL
                                             AND I.TIPOMOV = 'E'
         WHERE M.DTCANCEL IS NULL
           AND M.STATUS IN ('A', 'AB')
              /*SOMENTE MOVIMENTAÇÕES DE SAIDA DE MERCADORIA*/
           AND E.ESPECIE NOT IN ('OE')
           AND M.CODOPER LIKE 'E%'
        UNION ALL
        SELECT LAST_DAY(M.DTENT) AS DATAMES,
               M.CODFILIAL,
               'E' AS TIPOCONTABIL,
               M.VLICMS,
               ROUND(NVL(M.VLPIS, 0), 2) AS VLPIS,
               ROUND(NVL(M.VLCOFINS, 0), 2) AS VLCOFINS
          FROM VIEW_JC_LANC_FISCAL M)
 GROUP BY DATAMES, CODFILIAL, TIPOCONTABIL
 ORDER BY CODFILIAL, DATAMES;
/