CREATE OR REPLACE VIEW VIEW_BI_CONTAS_RECEBER AS
 SELECT CAST(T.CODFILIAL AS NUMBER) AS CODFILIAL,
        T.CODCLI,
        T.NUMTRANSVENDA,
        (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
        T.DTEMISSAO,
        T.DTVENC,
        T.DTPAG,
        T.CODCOB,
        T.VALOR,
        (NVL(T.VALOR, 0) - NVL(T.VALORDESC, 0)) AS VALORLIQ,
        T.VPAGO,
        T.CODUSUR,
        (CASE
          WHEN DTPAG IS NOT NULL THEN
           (CASE WHEN (TO_DATE(T.DTPAG, 'DD/MM/YYYY') - TO_DATE(T.DTVENC, 'DD/MM/YYYY'))  > 0 THEN 
            'PAGO ATRASADO' 
           ELSE 
            'PAGO' END)
          WHEN DTVENC < TRUNC(SYSDATE) - 1 THEN
           'VENCIDO'
          ELSE
           'EM ABERTO'
        END) AS STATUS,
        (CASE
          WHEN DTPAG IS NOT NULL THEN
            (CASE WHEN (TO_DATE(T.DTPAG, 'DD/MM/YYYY') - TO_DATE(T.DTVENC, 'DD/MM/YYYY'))  < 0 
              THEN 0 ELSE (TO_DATE(T.DTPAG, 'DD/MM/YYYY') - TO_DATE(T.DTVENC, 'DD/MM/YYYY')) END)
          WHEN DTVENC < TRUNC(SYSDATE) - 1 THEN
           (TRUNC(SYSDATE) - DTVENC)
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
        NVL(TO_DATE(T.DTULTALTER, 'DD/MM/YYYY'), TO_DATE(T.DTEMISSAO, 'DD/MM/YYYY')) AS DTULTALTER
   FROM PCPREST T
  WHERE T.DTDESD IS NULL
    AND T.DTCANCEL IS NULL
    AND T.CODCOB NOT IN ('SENT', 'TR', 'CANC', 'BNF');
/