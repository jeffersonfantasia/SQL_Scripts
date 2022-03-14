CREATE OR REPLACE VIEW VIEW_JC_PREST_ESTORNO_JUROS AS
    SELECT T.CODDUPLIC,
           T.CODFILIAL,
           T.DATA,
           T.DTVENC,
           T.DTEMISSAO,
           T.DUPLICATA,
           T.CODBANCO,
           T.CODCONTABILBANCO,
           (T.TXPERM * - 1) AS VALOR,
           T.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           T.NUMTRANSVENDA,
           T.CARTORIO,
           T.PROTESTO,
           'EJ' AS TIPO,
           ('ESTORNO JUROS DUP ' || T.DUPLICATA || ' - ' || TRIM (T.CLIENTE)) AS HISTORICO
      FROM VIEW_JC_BASE_PREST T
     INNER JOIN VIEW_JC_PREST_BANCOS B ON T.CODBANCO = B.CODBANCO
     WHERE T.CODCOB = 'ESTR'
       AND NVL (T.TXPERM, 0) <> 0;
/