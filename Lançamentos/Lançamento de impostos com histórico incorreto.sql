SELECT L.CODFILIAL,
       L.RECNUM,
       L.DTLANC,
       L.CODCONTA,
       L.CODFORNEC,
       L.HISTORICO,
       L.HISTORICO2,
       L.NUMNOTA,
       L.VALOR,
       L.CODFUNCAUTOR AS CODFUNCLANC
  FROM PCLANC L
 WHERE HISTORICO2 IN (TRIM('IR'), TRIM('GPS'))
