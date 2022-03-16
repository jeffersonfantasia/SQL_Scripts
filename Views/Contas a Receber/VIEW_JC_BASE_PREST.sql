CREATE OR REPLACE VIEW VIEW_JC_BASE_PREST AS
    SELECT (T.DUPLIC || '-' || T.PREST || '-' || T.NUMTRANSVENDA) AS CODDUPLIC,
           T.CODFILIAL,
           (
               CASE
                   WHEN (T.DTESTORNO IS NOT NULL
                      AND ROTINAPAG NOT LIKE '%1207%') THEN 'ESTORNO'
                   ELSE 'NORMAL'
               END
           ) AS STATUS,
           T.DTEMISSAO,
           T.DTBAIXA,
           T.DTPAG,
           T.DTVENC,
           T.DTINCLUSAOMANUAL,
           (
               CASE
                   WHEN B.CODBACEN = 'MARKETPLACE' THEN T.DTBAIXA
                   ELSE T.DTPAG
               END
           ) AS DATA,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL AS CODCONTABILBANCO,
           T.VALORDESC,
           T.VALOR,
           T.TXPERM,
           T.VLROUTROSACRESC,
           T.VPAGO,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANSVENDA,
           T.NUMTRANS,
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
           ) AS PROTESTO,
           COALESCE (TRIM (C.CLIENTE), TRIM (D.CLIENTE)) AS CLIENTE
      FROM PCPREST T
      /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
     WHERE M.DTESTORNO IS NULL;
/