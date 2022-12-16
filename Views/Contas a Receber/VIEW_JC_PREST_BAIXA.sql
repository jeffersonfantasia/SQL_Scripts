CREATE OR REPLACE VIEW VIEW_JC_PREST_BAIXA AS
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
           (
               CASE
                   WHEN T.CODCOB = 'DESC' THEN T.VALORDESC
                   WHEN T.CODCOB = 'JUR'  THEN T.VPAGO
                   /*PARA QUE NAO TRAGA INFORMACAO DO VALOR DE JUROS*/
                   WHEN T.VPAGO > T.VALOR THEN (
                       CASE
                           WHEN (NVL (T.VLJUROS, 0) = 0
                              AND NVL (T.VALORDESC, 0) = 0) THEN T.VPAGO
                           /*CASO HAJA DESCONTO NA DUPLICATA DEVEMOS TRAZER O VALOR MENOS O DESCONTO*/
                           WHEN NVL (T.VALORDESC, 0) > 0 THEN (T.VALOR - NVL (T.VALORDESC, 0))
                           ELSE T.VALOR
                       END
                   )
                   /*CORRIGIR BUG DO SISTEMA*/
                   WHEN T.VPAGO < 0       THEN 0
                   /*PARA TRAZER A INFORMAÇÃO QUE REALMENTE RECEBEU, POIS EXISTE DIFERENCA DE 0,01 AS VEZES*/
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
           (
               CASE
                   WHEN T.STATUS = 'ESTORNO' THEN 'BE'
                   ELSE 'B'
               END
           ) AS TIPO,
           (
               CASE
                   WHEN T.CODCOB = 'DESC' THEN ('DESC DUP ' || T.DUPLICATA || ' - ' || TRIM (T.CLIENTE))
                   WHEN T.CODCOB = 'JUR'  THEN ('JUR RECEB DUP ' || T.DUPLICATA || ' - ' || TRIM (T.CLIENTE))
                   ELSE ('DUP ' || T.DUPLICATA || ' - ' || TRIM (T.CLIENTE))
               END
           ) AS HISTORICO
      FROM VIEW_JC_BASE_PREST T
     INNER JOIN VIEW_JC_PREST_COB C ON T.CODCOB = C.CODCOB
     INNER JOIN VIEW_JC_PREST_BANCOS B ON T.CODBANCO = B.CODBANCO;
/