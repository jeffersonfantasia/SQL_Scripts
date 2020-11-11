CREATE OR REPLACE VIEW VIEW_JC_SALDO_BANCOS AS
SELECT B.CODFILIAL,
       M.CODBANCO,
       B.NOME AS BANCO,
       M.DTCOMPENSACAO,
       DTCONCIL,
       M.NUMTRANS,
       (CASE WHEN M.TIPO = 'D' THEN M.VALOR ELSE (M.VALOR * -1) END) AS VALOR,
       (M.HISTORICO ||' - '|| M.HISTORICO2) AS HISTORICO,
       VLSALDOCONCIL,
       M.VLSALDO
  FROM PCMOVCR M
  LEFT JOIN PCBANCO B
    ON M.CODBANCO = B.CODBANCO
 WHERE B.FLUXOCX = 'S'
   AND M.CODCOB = 'D'
   AND M.DTCONCIL IS NOT NULL
   AND M.DTESTORNO IS NULL
   AND M.DTESTORNOLANC IS NULL
;/