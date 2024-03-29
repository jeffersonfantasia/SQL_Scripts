CREATE OR REPLACE VIEW VIEW_JC_JUROS_RECEBIDOS AS
SELECT T.CODFILIAL,
       T.DATA,
       T.DTVENC,
       T.DTEMISSAO,
       T.NUMNOTA,
       T.CPF_CNPJ,
       T.VLJUROS,
       T.VLMULTA,
       T.VALORDESC,
       T.DUPLICATA,
       T.CODBANCO,
       T.CODCONTABILBANCO,
       NVL(T.VLJUROS + NVL(T.VLMULTA, 0),0) AS VALOR,
       T.CODCONTAB,
       T.CODCLI,
       T.CODCOB,
       T.CODUSUR,
       T.NUMTRANS,
       T.NUMTRANSVENDA,
       T.CARTORIO,
       T.PROTESTO,
       CASE
         WHEN ((B.CODBACEN = 'MARKETPLACE' OR B.CODBANCO = 12) AND
              T.CODCONTAB IS NOT NULL) THEN
          'JM'
         ELSE
          'J'
       END AS TIPO,
       CASE
         WHEN ((B.CODBACEN = 'MARKETPLACE' OR B.CODBANCO = 12) AND
              T.CODCONTAB IS NOT NULL) THEN
          ('VL PAGO MAIOR DUP ' || T.DUPLICATA || ' - ' || TRIM(T.CLIENTE))
         ELSE
          ('JUR RECEB DUP ' || T.DUPLICATA || ' - ' || TRIM(T.CLIENTE))
       END AS HISTORICO
  FROM VIEW_JC_BASE_PREST T
 INNER JOIN VIEW_JC_PREST_COB C ON T.CODCOB = C.CODCOB
 INNER JOIN VIEW_JC_PREST_BANCOS B ON T.CODBANCO = B.CODBANCO
/*SOMENTE DUPLICATAS COM JUROS OU MULTAS*/
 WHERE (T.VLJUROS > 0 OR NVL(T.VLMULTA, 0)> 0)
   AND T.CODCOB NOT IN ('JUR', 'DESC');
/
