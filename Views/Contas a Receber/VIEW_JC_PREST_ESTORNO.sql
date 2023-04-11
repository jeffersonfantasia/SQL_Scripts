CREATE OR REPLACE VIEW VIEW_JC_PREST_ESTORNO AS
    SELECT T.CODFILIAL,
           T.DATA,
           T.DTVENC,
           T.DTEMISSAO,
           T.NUMNOTA,
           T.CPF_CNPJ,
           NVL(T.VLJUROS,0) VLJUROS,
           NVL(T.VLMULTA,0) VLMULTA,
           NVL(T.VALORDESC,0) VALORDESC,
           T.DUPLICATA,
           T.CODBANCO,
           T.CODCONTABILBANCO,
           NVL((NVL (T.VPAGO, T.VALOR) * - 1) - (NVL (T.VLMULTA, 0) * - 1) - (NVL (T.VLJUROS, 0) * - 1),0) AS VALOR,
           T.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           T.NUMTRANSVENDA,
           T.CARTORIO,
           T.PROTESTO,
           'E' AS TIPO,
           ('ESTORNO DUP ' || T.DUPLICATA || ' - ' || TRIM (T.CLIENTE)) AS HISTORICO
      FROM VIEW_JC_BASE_PREST T
     INNER JOIN VIEW_JC_PREST_BANCOS B ON T.CODBANCO = B.CODBANCO
     WHERE T.CODCOB = 'ESTR';
/
