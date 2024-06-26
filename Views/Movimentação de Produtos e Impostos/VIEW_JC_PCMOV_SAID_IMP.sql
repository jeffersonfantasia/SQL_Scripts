CREATE OR REPLACE VIEW VIEW_JC_PCMOV_SAID_IMP AS
  SELECT DATAMES,
         CODFILIAL,
         TIPOCONTABIL,
         SUM(VLICMS) AS VLTOTALICMS,
         SUM(VLPIS) AS VLTOTALPIS,
         SUM(VLCOFINS) AS VLTOTALCOFINS
    FROM (SELECT LAST_DAY(S.DTMOV) AS DATAMES,
                 S.CODFILIAL,
                 'S' AS TIPOCONTABIL,
                 S.VLTOTALCREDICMSNF VLICMS,
                 S.VLTOTALPIS VLPIS,
                 S.VLTOTALCOFINS VLCOFINS
            FROM MV_JC_PCMOV_SAID S
           WHERE S.CODFILIAL NOT IN ('3', '4'))
   GROUP BY DATAMES, CODFILIAL, TIPOCONTABIL
 ORDER BY CODFILIAL, DATAMES;
