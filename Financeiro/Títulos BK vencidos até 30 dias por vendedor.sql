SELECT *
  FROM (SELECT T.CODUSUR,
               U.NOME,
               T.CODFILIAL,
               T.CODCLI,
               C.CLIENTE,
               (T.DUPLIC || '-' || T.PREST) DUPLICATA,
               T.DTEMISSAO,
               T.DTVENCORIG,
               T.DTVENC,
               T.VALOR,
               T.CODCOB,
               (TRUNC(SYSDATE) - T.DTVENC) DIAS_ATRASO,
               NVL(T.TXPERM, 0) JUROS,
               (NVL(T.VALOR, 0) + NVL(T.TXPERM, 0)) VALORJUROS
          FROM PCPREST T, PCCLIENT C, PCUSUARI U
         WHERE C.CODCLI = T.CODCLI
           AND U.CODUSUR = T.CODUSUR
           AND T.DTPAG IS NULL
           AND T.CODCOB = 'BK')
 WHERE DIAS_ATRASO <= 30
   AND DIAS_ATRASO >  1
 ORDER BY CODUSUR, DIAS_ATRASO DESC;