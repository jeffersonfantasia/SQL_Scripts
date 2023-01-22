CREATE OR REPLACE VIEW VIEW_JC_BASE_PREST AS
WITH STATUS_DUP_ESTORNO AS
 (SELECT T.NUMTRANSVENDA,
         T.PREST,
         CASE
           WHEN ((EXTRACT(YEAR FROM T.DTESTORNO) ||
                EXTRACT(MONTH FROM T.DTESTORNO) =
                EXTRACT(YEAR FROM T.DTPAG) || EXTRACT(MONTH FROM T.DTPAG)) OR
                T.CODCOB = 'ESTR') THEN
            'E'
           ELSE
            'N'
         END STATUS_PREST_ESTORNO
    FROM PCPREST T
   WHERE T.DTESTORNO IS NOT NULL
     AND T.DTINCLUSAOMANUAL IS NULL),
STATUS_DUP_ATUAL AS
 (SELECT P.NUMTRANSVENDA,
         P.PREST,
         TO_NUMBER(COALESCE(TRANSLATE(P.PREST,
                                      'ABCDEFGHIJKLMNOPQRSTUVXZWY',
                                      '0'),
                            '0')) - 2 TESTE,
         T.STATUS_PREST_ESTORNO,
         (CASE
           WHEN ((EXTRACT(YEAR FROM P.DTESTORNO) ||
                EXTRACT(MONTH FROM P.DTESTORNO) =
                EXTRACT(YEAR FROM P.DTPAG) || EXTRACT(MONTH FROM P.DTPAG)) OR
                P.CODCOB = 'ESTR') THEN
            'E'
           ELSE
            'N'
         END) STATUS_PREST_ATUAL
    FROM PCPREST P
    LEFT JOIN STATUS_DUP_ESTORNO T ON T.NUMTRANSVENDA = P.NUMTRANSVENDA
                                  AND TO_NUMBER(COALESCE(TRANSLATE(T.PREST,
                                                                   'ABCDEFGHIJKLMNOPQRSTUVXZWY',
                                                                   '0'),
                                                         '0')) =
                                      TO_NUMBER(COALESCE(TRANSLATE(P.PREST,
                                                                   'ABCDEFGHIJKLMNOPQRSTUVXZWY',
                                                                   '0'),
                                                         '0')) - 2
   WHERE P.DTINCLUSAOMANUAL IS NULL),
STATUS_PREST AS
 (SELECT P.NUMTRANSVENDA,
         P.PREST,
         (CASE
           WHEN P.STATUS_PREST_ESTORNO = 'N' OR P.STATUS_PREST_ATUAL = 'E' THEN
            'ESTORNO'
           ELSE
            'NORMAL'
         END) STATUS
    FROM STATUS_DUP_ATUAL P)
    SELECT --(T.DUPLIC || '-' || T.PREST || '-' || T.NUMTRANSVENDA) AS CODDUPLIC,
           DISTINCT T.CODFILIAL,
           E.STATUS,
           T.DUPLIC NUMNOTA,
           (SELECT X.CGCENT FROM PCPREST Y JOIN PCCLIENT X ON Y.CODCLI = X.CODCLI WHERE Y.NUMTRANSVENDA = T.NUMTRANSVENDA AND Y.PREST = '1') CPF_CNPJ,
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
           T.TXPERM VLJUROS,
           T.VLROUTROSACRESC VLMULTA,
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
      JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
      LEFT JOIN STATUS_PREST E ON E.NUMTRANSVENDA = T.NUMTRANSVENDA AND E.PREST = T.PREST
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
     WHERE M.DTESTORNO IS NULL;
/