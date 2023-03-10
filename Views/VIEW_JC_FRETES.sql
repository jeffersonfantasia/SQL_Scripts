CREATE OR REPLACE VIEW VIEW_JC_FRETES AS
  WITH FRETE AS
   (SELECT DISTINCT DATA,
                    CODFILIAL,
                    TRANSPORTADORA,
                    NUMTRANSACAO,
                    CODCLI,
                    QTCTESNOTA,
                    VLTOTALFRETE
      FROM VIEW_JC_CTES V)

  SELECT COALESCE(M.CODFILIAL, F.CODFILIAL) CODFILIAL,
         COALESCE(M.DATA, F.DATA) DATA,
         COALESCE(M.NUMTRANSACAO, F.NUMTRANSACAO) NUMTRANSACAO,
         COALESCE(M.CODCLI, F.CODCLI) CODCLI,
         NVL(M.CODUSUR, 99) CODUSUR,
         NVL(M.TIPOFAT, 0) TIPOFAT,
         NVL(M.TIPOPESO, 0) TIPOPESO,
         CASE
           WHEN F.CODCLI = 10 THEN
            'CTE COMPLEMENTAR'
           WHEN M.VLTOTAL IS NULL THEN
            'NOTAS CANCELADAS'
           ELSE
            M.TIPO
         END TIPO,
         NVL(M.PESO, 0) PESO,
         COALESCE(F.TRANSPORTADORA, M.TRANSPORTADORA, 'SEM TRANSPORTADORA') TRANSPORTADORA,
         NVL(F.QTCTESNOTA, 0) QTCTES,
         NVL(M.VLTOTAL, 0) VLNOTA,
         NVL(F.VLTOTALFRETE, 0) VLFRETE
    FROM VIEW_JC_MOVNOTAS_FRETE M
    FULL JOIN FRETE F ON F.NUMTRANSACAO = M.NUMTRANSACAO
   WHERE COALESCE(M.DATA, F.DATA) >= TO_DATE('01/01/2017', 'DD/MM/YYYY');
