CREATE OR REPLACE VIEW VIEW_JC_PREST_PERDAS AS
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
            CASE
              WHEN VPAGO < 0 THEN
               VPAGO * -1
              WHEN T.VPAGO > T.VALOR THEN
               T.VALOR --PARA QUE NAO TRAGA INFORMACAO DE JUROS
              ELSE
               T.VPAGO
            END VALOR,
            T.CODCONTAB,
            T.CODCLI,
            T.CODCOB,
            T.CODUSUR,
            T.NUMTRANS,
            T.NUMTRANSVENDA,
            T.CARTORIO,
            T.PROTESTO,
            'P' AS TIPO,
            ('PERDA DUP ' || T.DUPLICATA || ' - ' || TRIM(T.CLIENTE)) AS HISTORICO
       FROM VIEW_JC_BASE_PREST T
      WHERE T.CODCOB = 'PERD';
/
