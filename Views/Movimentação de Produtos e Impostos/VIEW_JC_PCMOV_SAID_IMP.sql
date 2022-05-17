CREATE OR REPLACE VIEW VIEW_JC_PCMOV_SAID_IMP AS
SELECT DATAMES,
       CODFILIAL,
       TIPOCONTABIL,
       SUM(VLICMS) AS VLTOTALICMS,
       SUM(VLPIS) AS VLTOTALPIS,
       SUM(VLCOFINS) AS VLTOTALCOFINS
  FROM (SELECT LAST_DAY(M.DTMOV) AS DATAMES,
               M.CODFILIAL,
               'S' AS TIPOCONTABIL,
               (CASE
                 WHEN I.GERAICMSLIVROFISCAL = 'S' THEN
                  ROUND(NVL((I.VLBASEICMS * I.PERCICM / 100), 0), 2)
                 ELSE
                  0
               END) AS VLICMS,
               ROUND(NVL(I.VLPIS, 0), 2) AS VLPIS,
               ROUND(NVL(I.VLCOFINS, 0), 2) AS VLCOFINS
          FROM PCMOV M
          LEFT JOIN VIEW_JC_ITEM_NOTAFISCAL I ON M.NUMTRANSVENDA =
                                                 I.NUMTRANSACAO
                                             AND M.NUMSEQ = I.NUMSEQ
                                             AND M.CODFILIALNF = I.CODFILIAL
                                             AND M.CODPROD = I.CODPROD
                                                /*AMARRACAO FUNDAMENTAL FECHAR O JOIN*/
                                             AND I.TIPOMOV = 'S'
         WHERE M.DTCANCEL IS NULL
              /*TRAZER APENAS MOVIMENTAÇÕES CONTABEIS*/
           AND M.STATUS IN ('A', 'AB')
           AND M.CODOPER LIKE 'S%'
              /*RETIRAR NOTAS EMITIDAS ERRADAS*/
           AND NOT (M.CODFISCAL IN (5927) AND M.CODFILIAL IN (3, 4)))
 GROUP BY DATAMES, CODFILIAL, TIPOCONTABIL
 ORDER BY CODFILIAL, DATAMES;
/