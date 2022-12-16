CREATE OR REPLACE VIEW VIEW_JC_PCPREST_GERADO_MKT AS
  SELECT T.CODDUPLIC,
         T.CODFILIAL,
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
         T.VALOR,
         T.CODCONTAB,
         T.CODCLI,
         T.CODCOB,
         T.CODUSUR,
         T.NUMTRANS,
         T.NUMTRANSVENDA,
         T.CARTORIO,
         T.PROTESTO,
         'IM' TIPO,
         ('DUP GERADA' || T.DUPLICATA || ' - ' || TRIM(T.CLIENTE)) HISTORICO
    FROM VIEW_JC_BASE_PREST T
    JOIN PCMOVCR M ON M.NUMCARR = T.NUMTRANSVENDA
                  AND M.CODBANCO = T.CODBANCO
    JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
   WHERE M.CODROTINALANC = 1206
     AND (B.CODBACEN = 'MARKETPLACE' OR B.CODBANCO = 12);
     /