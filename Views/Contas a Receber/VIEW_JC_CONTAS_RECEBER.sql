CREATE OR REPLACE VIEW VIEW_JC_CONTAS_RECEBER AS
    SELECT T.CODFILIAL,
           T.CODCLI,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           T.DTEMISSAO,
           T.DTVENC,
           T.DTPAG,
           T.CODCOB,
           NVL (B.CARTAO, 'N') AS CARTAO,
           T.VALOR,
           (NVL (T.VALOR, 0) - NVL (T.VALORDESC, 0)) AS VALORLIQ,
           T.CODUSUR,
           (
               CASE NVL (T.CARTORIO, 'N')
                   WHEN 'S'   THEN 'SIM'
                   WHEN 'N'   THEN 'N�O'
                   ELSE T.CARTORIO
               END
           ) AS CARTORIO,
           (
               CASE NVL (T.PROTESTO, 'N')
                   WHEN 'S'   THEN 'SIM'
                   WHEN 'N'   THEN 'N�O'
                   ELSE T.PROTESTO
               END
           ) AS PROTESTO
      FROM PCPREST T
      LEFT JOIN PCCOB B ON T.CODCOB = B.CODCOB
     WHERE T.DTPAG IS NULL
       AND T.DTCANCEL IS NULL
       AND T.CODCOB NOT IN (
        'SENT'
    );