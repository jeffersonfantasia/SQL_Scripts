CREATE OR REPLACE VIEW VIEW_JC_PREST_PERDAS AS
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
                 /*PARA QUE NAO TRAGA INFORMACAO DE JUROS*/
                   WHEN T.VPAGO > T.VALOR THEN T.VALOR
                   ELSE T.VPAGO
               END
           ) VALOR,
           T.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           T.NUMTRANSVENDA,
           T.CARTORIO,
           T.PROTESTO,
           'P' AS TIPO,
           ('PERDA DUP ' || T.DUPLICATA || ' - ' || TRIM (T.CLIENTE)) AS HISTORICO
      FROM VIEW_JC_BASE_PREST T
     WHERE T.CODCOB = 'PERD';
/