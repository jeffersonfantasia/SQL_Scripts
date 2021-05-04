CREATE OR REPLACE VIEW VIEW_JC_LANC_IMP_NFS_FUNC AS
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           COALESCE (L.VPAGOBORDERO, B.VALOR) AS VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           '' AS CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           'I' AS TIPO,
           (
               CASE
                   WHEN B.GRUPOCONTA NOT IN (
                       510, 515
                   ) THEN ('NFS ' || L.NUMNOTA || ' - ' || L.HISTORICO2 || ' - ' || F.FORNECEDOR)
                   ELSE (L.RECNUM || ' - ' || L.HISTORICO2 || ' - ' || L.HISTORICO)
               END
           ) AS HISTORICO
      FROM PCLANC L
     INNER JOIN VIEW_JC_LANC_BASE B ON L.RECNUM = B.RECNUM
     INNER JOIN VIEW_JC_IMPOSTO_NFSE I ON L.RECNUM = I.RECNUM
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC;
/