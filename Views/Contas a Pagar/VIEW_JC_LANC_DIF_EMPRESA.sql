CREATE OR REPLACE VIEW VIEW_JC_LANC_DIF_EMPRESA AS
    WITH BANCOS_EMPRESA AS
     (SELECT B.CODBANCO,
             (CASE
               WHEN B.CODFILIAL IN (1, 2, 7, 8, 11, 12, 13, 14, 99) THEN
                '1'
               ELSE
                B.CODFILIAL
             END) AS CODEMPRESA
        FROM PCBANCO B),
    LANCAMENTOS_EMPRESA AS
     (SELECT L.RECNUM,
             (CASE
               WHEN L.CODFILIAL IN (1, 2, 7, 8, 11, 12, 13, 14, 99) THEN
                '1'
               ELSE
                L.CODFILIAL
             END) AS CODEMPRESA
        FROM PCLANC L
       WHERE L.TIPOPARCEIRO = 'F')
    SELECT B.CODFILIAL,
           B.RECNUM,
           B.VPAGO,
           (CASE
             WHEN B.VPAGO < 0 THEN
              (B.VPAGO * -1)
             ELSE
              B.VPAGO
           END) AS VALOR,
           B.DTCOMPETENCIA,
           B.DTPAGTO,
           B.DTCOMPETENCIA AS DTCOMPENSACAO,
           B.CODFILIALBANCO,
           B.CODBANCO,
           B.CODCONTABILBANCO,
           B.CODCONTA,
           B.GRUPOCONTA,
           B.CODFORNEC,
           '' AS CODCONTABCLIENTE,
           B.TIPOPARCEIRO,
           B.NUMTRANS,
           B.HISTORICO
      FROM VIEW_JC_LANC_BASE B
     INNER JOIN BANCOS_EMPRESA S ON B.CODBANCO = S.CODBANCO
     INNER JOIN LANCAMENTOS_EMPRESA T ON B.RECNUM = T.RECNUM
     WHERE S.CODEMPRESA <> T.CODEMPRESA
     /*SOMENTE LANCAMENTO ENTRE EMPRESAS DIFERENTES*/;
/
