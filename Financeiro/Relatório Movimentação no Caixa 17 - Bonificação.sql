SELECT A.DATACOMPLETA,
       A.CODBANCO,
       A.CODCOB,
       A.CODROTINALANC ROT_LANC,
       A.VALOR,
       A.TIPO,
       A.HISTORICO,
       A.CODFUNC,
       B.NOME
  FROM PCMOVCR A, PCEMPR B
 WHERE A.CODFUNC = B.MATRICULA
   AND A.CODBANCO = 17
   AND A.DATA >= TRUNC(SYSDATE) - 30
 ORDER BY A.DATACOMPLETA;