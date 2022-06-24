CREATE OR REPLACE VIEW VIEW_BI_CONTAS_RECEBER AS
WITH DIAS_UTEIS AS
 (SELECT D.DATA,
         D.DIAFINANCEIRO,
         (SELECT MIN(D2.DATA) DATA
            FROM PCDIASUTEIS D2
           WHERE D2.DIAFINANCEIRO = 'S'
             AND D.DATA <= D2.DATA
             AND D2.CODFILIAL = D.CODFILIAL) AS DTVENC_UTIL
    FROM PCDIASUTEIS D
   WHERE CODFILIAL = 1)
SELECT CAST(T.CODFILIAL AS NUMBER) AS CODFILIAL,
       T.CODCLI,
       T.NUMTRANSVENDA,
       (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
       T.DTEMISSAO,
       T.DTVENC,
       D.DTVENC_UTIL,
       T.DTPAG,
       T.CODCOB,
       T.VALOR,
       (NVL(T.VALOR, 0) - NVL(T.VALORDESC, 0)) AS VALORLIQ,
       T.VPAGO,
       T.CODUSUR,
       (CASE
         WHEN T.CODCOB = 'PERD' THEN
          'PERDA'
         WHEN T.DTPAG IS NOT NULL THEN
          (CASE
            WHEN (TO_DATE(T.DTPAG, 'DD/MM/YYYY') -
                 TO_DATE(D.DTVENC_UTIL, 'DD/MM/YYYY')) > 0 AND
                 T.CODCOB != 'JUR' THEN
             'PAGO ATRASADO'
            ELSE
             'PAGO'
          END)
         WHEN D.DTVENC_UTIL < TRUNC(SYSDATE) - 1 THEN
          'VENCIDO'
         ELSE
          'EM ABERTO'
       END) AS STATUS,
       (CASE
         WHEN T.DTPAG IS NOT NULL THEN
          (CASE
            WHEN (TO_DATE(T.DTPAG, 'DD/MM/YYYY') -
                 TO_DATE(D.DTVENC_UTIL, 'DD/MM/YYYY')) < 0 THEN
             0
            ELSE
             (TO_DATE(T.DTPAG, 'DD/MM/YYYY') -
             TO_DATE(D.DTVENC_UTIL, 'DD/MM/YYYY'))
          END)
         WHEN D.DTVENC_UTIL < TRUNC(SYSDATE) - 1 THEN
          (TRUNC(SYSDATE) - D.DTVENC_UTIL)
         ELSE
          0
       END) AS DIAS_ATRASO,
       (CASE NVL(T.CARTORIO, 'N')
         WHEN 'S' THEN
          'SIM'
         WHEN 'N' THEN
          'NÃO'
         ELSE
          T.CARTORIO
       END) AS CARTORIO,
       (CASE NVL(T.PROTESTO, 'N')
         WHEN 'S' THEN
          'SIM'
         WHEN 'N' THEN
          'NÃO'
         ELSE
          T.PROTESTO
       END) AS PROTESTO,
       NVL(TO_DATE(T.DTULTALTER, 'DD/MM/YYYY'),
           TO_DATE(T.DTEMISSAO, 'DD/MM/YYYY')) AS DTULTALTER
  FROM PCPREST T
 INNER JOIN DIAS_UTEIS D ON T.DTVENC = D.DATA
 WHERE T.DTDESD IS NULL
   AND T.DTCANCEL IS NULL
   AND T.CODCOB NOT IN
       ('SENT', 'TR', 'CANC', 'BNF', 'ESTR', 'DEVT', 'DEVP')
   AND (NVL(T.VALOR, 0) - NVL(T.VALORDESC, 0)) >= 0;
/