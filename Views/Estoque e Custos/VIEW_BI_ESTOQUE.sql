CREATE OR REPLACE VIEW VIEW_BI_ESTOQUE AS
    SELECT CAST (E.CODFILIAL AS NUMBER) AS CODFILIAL,
           E.DTULTALTERSRVPRC AS DATA,
           E.CODPROD,
           NVL (E.QTEST, 0) AS QTCONTABIL,
           NVL (E.QTESTGER, 0) AS QTGERENCIAL,
           (NVL (E.QTESTGER, 0) - NVL (E.QTBLOQUEADA, 0) - NVL (E.QTRESERV, 0)) AS QTDISPONIVEL,
           NVL (E.QTBLOQUEADA, 0) AS QTBLOQUEADA,
           NVL (E.QTRESERV, 0) AS QTRESERVADA,
           NVL (E.QTINDENIZ, 0) AS QTAVARIADA,
           NVL (E.QTFRENTELOJA, 0) AS QTFRENTELOJA,
           ROUND (NVL (E.CUSTOFIN, 0), 4) AS CUSTOFINANCEIRO,
           ROUND (NVL (E.CUSTOCONT, 0), 4) AS CUSTOCONTABIL,
           ROUND (NVL (E.CUSTOREP, 0), 4) AS CUSTOREPOSICAO,
           NVL (E.CODDEVOL, 0) AS CODBLOQUEIO
      FROM PCEST E;
/