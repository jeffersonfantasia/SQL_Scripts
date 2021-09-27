CREATE OR REPLACE VIEW VIEW_BI_CONTAS_RECEBER AS
    SELECT CAST (T.CODFILIAL AS NUMBER) AS CODFILIAL,
           T.CODCLI,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           T.DTEMISSAO,
           T.DTVENC,
           T.CODCOB,
           T.VALOR,
           (NVL (T.VALOR, 0) - NVL (T.VALORDESC, 0)) AS VALORLIQ,
           T.CODUSUR,
           (
               CASE
                   WHEN DTVENC < TRUNC (SYSDATE) - 1 THEN 'VENCIDO'
                   ELSE 'EM ABERTO'
               END
           ) AS STATUS,
           (
               CASE
                   WHEN DTVENC < TRUNC (SYSDATE) - 1 THEN (TRUNC (SYSDATE) - DTVENC)
                   ELSE 0
               END
           ) AS DIAS_ATRASO,
           (
               CASE NVL (T.CARTORIO, 'N')
                   WHEN 'S'   THEN 'SIM'
                   WHEN 'N'   THEN 'NÃO'
                   ELSE T.CARTORIO
               END
           ) AS CARTORIO,
           (
               CASE NVL (T.PROTESTO, 'N')
                   WHEN 'S'   THEN 'SIM'
                   WHEN 'N'   THEN 'NÃO'
                   ELSE T.PROTESTO
               END
           ) AS PROTESTO
      FROM PCPREST T
     WHERE T.DTPAG IS NULL
       AND T.DTDESD IS NULL
       AND T.DTCANCEL IS NULL
       AND T.CODCOB NOT IN (
        'SENT'
    );
/