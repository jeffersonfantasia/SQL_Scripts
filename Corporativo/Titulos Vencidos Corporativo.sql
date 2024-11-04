WITH DIAS_UTEIS AS
 (SELECT D.DATA,
         D.DIAFINANCEIRO,
         (SELECT MIN(D2.DATA) DATA
            FROM PCDIASUTEIS D2
           WHERE D2.DIAFINANCEIRO = 'S'
             AND D.DATA < =D2.DATA
             AND D2.CODFILIAL = D.CODFILIAL) AS DTVENC_UTIL
    FROM PCDIASUTEIS D
   WHERE CODFILIAL = 1)
SELECT *
  FROM (SELECT T.CODUSUR,
               U.NOME,
               T.CODFILIAL,
               T.CODCLI,
               C.CLIENTE,
               (T.DUPLIC || '-' || T.PREST) DUPLICATA,
               T.DTEMISSAO,
               T.DTVENCORIG,
               D.DTVENC_UTIL DTVENC,
               T.VALOR,
               T.CODCOB,
               (TRUNC(SYSDATE) - D.DTVENC_UTIL) DIAS_ATRASO,
               --JUROS CALCULADOS = ((PERC JUROS / 30 DIAS) * VALOR DUPLICATA) * QTD DIAS ATRASADOS
               ROUND((((0.059 / 30) * T.VALOR) * (TRUNC(SYSDATE) - D.DTVENC_UTIL)),2) JUROS,
               (NVL(T.VALOR, 0) + ROUND((((0.059 / 30) * T.VALOR) * (TRUNC(SYSDATE) - D.DTVENC_UTIL)),2)) VALORJUROS
          FROM PCPREST T
          LEFT JOIN PCCLIENT C ON C.CODCLI = T.CODCLI
          LEFT JOIN PCUSUARI U ON U.CODUSUR = T.CODUSUR
          LEFT JOIN DIAS_UTEIS D ON T.DTVENC = D.DATA
         WHERE T.DTPAG IS NULL
					 AND T.CODUSUR = 14)
 WHERE DIAS_ATRASO > =  1 AND DIAS_ATRASO <=  60
 ORDER BY CODUSUR, DIAS_ATRASO DESC
