SELECT M.DTCOMPENSACAO,
       M.NUMSEQ,
       M.NUMTRANS,
       M.DATA,
       M.CODBANCO,
       M.VALOR,
       M.TIPO,
       M.HISTORICO,
       M.DTCONCIL,
       M.CODFUNCCONCIL AS CODFUNC,
       m.rowid
  FROM PCMOVCR M
 WHERE 1 = 1
   AND (M.DATA > TO_DATE('01/06/2024', 'DD/MM/YYYY') OR M.DTCOMPENSACAO > TO_DATE('01/02/2022', 'DD/MM/YYYY'))
   AND TO_NUMBER(TO_CHAR(M.DTCOMPENSACAO, 'YYYY') || TO_CHAR(M.DTCOMPENSACAO, 'MM')) <>
       TO_NUMBER(TO_CHAR(M.DATA, 'YYYY') || TO_CHAR(M.DATA, 'MM'))
   AND ABS(M.DTCOMPENSACAO - M.DATA) > 15
   AND M.CODROTINALANC IN (643,632,639)
   AND M.DTESTORNO IS NULL;
/
