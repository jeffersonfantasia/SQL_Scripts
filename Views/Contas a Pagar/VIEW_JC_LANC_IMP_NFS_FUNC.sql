CREATE OR REPLACE VIEW VIEW_JC_LANC_IMP_NFS_FUNC AS
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           COALESCE (B.VPAGOBORDERO, B.VALOR) AS VALOR,
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
                       510, 515, 230
                   ) THEN ('NFS ' || B.NUMNOTA || ' - ' || B.HISTORICO2 || ' - ' || F.FORNECEDOR)
                   ELSE (B.RECNUM || ' - ' || B.HISTORICO2 || ' - ' || B.HISTORICO)
               END
           ) AS HISTORICO
      FROM VIEW_JC_LANC_BASE B
     INNER JOIN VIEW_JC_IMPOSTO_NFSE I ON B.RECNUM = I.RECNUM
      LEFT JOIN PCFORNEC F ON B.CODFORNEC = F.CODFORNEC;
/
