CREATE OR REPLACE VIEW VIEW_JC_SALDO_BANCOS AS
    SELECT B.CODFILIAL,
           M.CODBANCO,
           B.NOME AS BANCO,
           B.TIPOCXBCO,
           M.DTCOMPENSACAO,
           M.DTCONCIL,
           M.DATACOMPLETA,
           M.NUMTRANS,
           (
               CASE
                   WHEN M.TIPO = 'D' THEN M.VALOR
                   ELSE (M.VALOR * - 1)
               END
           ) AS VALOR,
           (M.HISTORICO || ' - ' || M.HISTORICO2) AS HISTORICO,
           M.VLSALDOCONCIL,
           M.VLSALDO
      FROM PCMOVCR M
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE B.FLUXOCX = 'S'
       AND M.CODCOB = 'D'
       AND M.DTESTORNO IS NULL;
/