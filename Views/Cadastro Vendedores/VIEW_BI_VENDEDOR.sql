CREATE OR REPLACE VIEW VIEW_BI_VENDEDOR AS
    SELECT U.CODUSUR,
           (
               CASE
                   WHEN (U.BLOQUEIO = 'S'
                      AND U.CODSUPERVISOR = 1) THEN 'OUTROS CAPITAL'
                   WHEN (U.BLOQUEIO = 'S'
                      AND U.CODSUPERVISOR = 2) THEN 'OUTROS CAPITAL'
                   WHEN (U.BLOQUEIO = 'S'
                      AND U.CODSUPERVISOR = 5) THEN 'OUTROS LOJA'
                   ELSE U.USURDIRFV
               END
           ) AS VENDEDOR,
           U.CODSUPERVISOR,
           V.NOME AS SUPERVISOR,
           V.CODGERENTE,
           G.NOMEGERENTE AS GERENTE
      FROM PCUSUARI U
      LEFT JOIN PCSUPERV V ON V.CODSUPERVISOR = U.CODSUPERVISOR
      LEFT JOIN PCGERENTE G ON V.CODGERENTE = G.CODGERENTE;
/