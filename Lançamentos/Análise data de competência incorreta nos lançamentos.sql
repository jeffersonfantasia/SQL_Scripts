SELECT L.DTCOMPETENCIA,
       L.DTEMISSAO,
       L.DTLANC,
       L.RECNUM,
       L.CODCONTA,
       L.NUMBANCO,
       HISTORICO,
       DTPAGTO
  FROM PCLANC L
 WHERE (DTCOMPETENCIA > TRUNC (SYSDATE)
   AND DTPAGTO IS NOT NULL)
    OR (DTCOMPETENCIA < DTEMISSAO - 30)
   AND L.DTEMISSAO >= TO_DATE ('01/01/2020', 'DD/MM/YYYY')
   AND L.DTESTORNOBAIXA IS NULL
   AND NOT (L.VALOR < 0
   AND L.NUMBANCO = 41);
/