CREATE MATERIALIZED VIEW MV_JC_PCMOV_ENT_IMP
REFRESH FORCE ON DEMAND
START WITH SYSDATE NEXT SYSDATE + 20/1152
AS
SELECT DATAMES,
       CODFILIAL,
       TIPOCONTABIL,
       SUM(VLICMS) AS VLTOTALICMS,
       SUM(VLPIS) AS VLTOTALPIS,
       SUM(VLCOFINS) AS VLTOTALCOFINS
  FROM (SELECT LAST_DAY(E.DTMOV) AS DATAMES,
               E.CODFILIAL,
               'E' AS TIPOCONTABIL,
               E.VLTOTALCREDICMSNF VLICMS,
               E.VLTOTALPIS VLPIS,
               E.VLTOTALCOFINS VLCOFINS
          FROM VIEW_JC_PCMOV_ENT E
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
