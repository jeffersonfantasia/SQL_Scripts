CREATE OR REPLACE VIEW VIEW_JC_JUROS_RECEBIDOS AS
    SELECT T.CODDUPLIC,
           T.CODFILIAL,
           T.DATA,
           T.DTVENC,
           T.DTEMISSAO,
           T.DUPLICATA,
           T.CODBANCO,
           T.CODCONTABILBANCO,
           (
               CASE
                   WHEN T.CODCOB = 'JUR' THEN T.VPAGO
                   ELSE (T.TXPERM + NVL (T.VLROUTROSACRESC, 0))
               END
           ) AS VALOR,
           T.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           T.CARTORIO,
           T.PROTESTO,
           'J' AS TIPO,
           ('JUR RECEB DUP ' || T.DUPLICATA || ' - ' || TRIM (T.CLIENTE)) AS HISTORICO
      FROM VIEW_JC_BASE_PREST T
     INNER JOIN VIEW_JC_PREST_COB C ON T.CODCOB = C.CODCOB
     INNER JOIN VIEW_JC_PREST_BANCOS B ON T.CODBANCO = B.CODBANCO
 /*SOMENTE DUPLICATAS COM JUROS*/
     WHERE (T.TXPERM > 0);
/