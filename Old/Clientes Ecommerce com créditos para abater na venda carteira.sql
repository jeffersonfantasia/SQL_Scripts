WITH TRANSACAO_VENDA AS (
  SELECT NUMTRANSENT,
         MAX (M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NUMTRANSDEV IS NOT NULL
     AND NUMTRANSENT IS NOT NULL
   GROUP BY NUMTRANSENT
)
SELECT S.CODSUPERVISOR CODSUPERV,
       S.NOME SUPERVISOR,
       B.CODCLI,
       B.CLIENTE,
       A.NUMNOTA NOTA_DEV,
       A.VALOR VL_CREDITOS,
       D.NUMNOTA NOTA_VENDA,
       D.VLTOTGER VL_VENDA,
       D.CODCOB
  FROM PCCLIENT B,
       PCCRECLI A,
       PCSUPERV S,
       PCUSUARI I,
       PCNFSAID D,
       PCCOB T,
       TRANSACAO_VENDA TV
 WHERE B.CODCLI = D.CODCLI
   AND I.CODUSUR = B.CODUSUR1
   AND I.CODSUPERVISOR = S.CODSUPERVISOR
   AND D.NUMTRANSVENDA = TV.NUMTRANSVENDA
   AND A.NUMTRANSENTDEVCLI = TV.NUMTRANSENT
   AND T.CODCOB = D.CODCOB
   AND NVL (A.VALOR, 0) <> 0
   AND A.DTDESCONTO IS NULL
   AND A.DTESTORNO IS NULL
   AND S.CODSUPERVISOR IN (
  7, 8
)
   AND D.CODCOB = 'C'
 ORDER BY S.CODSUPERVISOR,
          B.CODCLIPRINC
/