--Dev 1346 - Clientes Ecommerce com cr�ditos sem v�nculo com cliente principal correto
WITH TRANSACAO_VENDA AS (
    SELECT NUMTRANSENT,
           MAX (M.NUMTRANSDEV) AS NUMTRANSVENDA
      FROM PCMOV M
     WHERE NUMTRANSDEV IS NOT NULL
       AND NUMTRANSENT IS NOT NULL
     GROUP BY NUMTRANSENT
)
SELECT B.CODCLIPRINC,
       (
           SELECT CLIENTE
             FROM PCCLIENT
            WHERE CODCLI = B.CODCLIPRINC
       ) CLIENTE_PRINCIPAL,
       S.CODSUPERVISOR CODSUPERV,
       S.NOME SUPERVISOR,
       B.CODCLI,
       B.CLIENTE,
       A.NUMNOTA NOTA_DEV,
       A.VALOR VL_CREDITOS,
       D.NUMNOTA NOTA_VENDA,
       D.VLTOTGER VL_VENDA,
       D.CODCOB,
       T.CODCLICC,
       (
           SELECT CLIENTE
             FROM PCCLIENT
            WHERE CODCLI = T.CODCLICC
       ) CLIENTE_COBRANCA
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
   AND (B.CODCLIPRINC <> T.CODCLICC
    OR B.CODCLIPRINC IS NULL
   AND T.CODCLICC IS NOT NULL)
 ORDER BY T.CODCLICC,
          S.CODSUPERVISOR,
          B.CODCLIPRINC;
/

MERGE INTO PCCLIENT C
USING (
  WITH TRANSACAO_VENDA AS
   (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
      FROM PCMOV M
     WHERE NUMTRANSDEV IS NOT NULL
       AND NUMTRANSENT IS NOT NULL
     GROUP BY NUMTRANSENT)
  SELECT B.CODCLIPRINC,
         (SELECT CLIENTE FROM PCCLIENT WHERE CODCLI = B.CODCLIPRINC) CLIENTE_PRINCIPAL,
         S.CODSUPERVISOR CODSUPERV,
         S.NOME SUPERVISOR,
         B.CODCLI,
         B.CLIENTE,
         A.NUMNOTA NOTA_DEV,
         A.VALOR VL_CREDITOS,
         D.NUMNOTA NOTA_VENDA,
         D.VLTOTGER VL_VENDA,
         D.CODCOB,
         T.CODCLICC,
         (SELECT CLIENTE FROM PCCLIENT WHERE CODCLI = T.CODCLICC) CLIENTE_COBRANCA
    FROM PCCLIENT        B,
         PCCRECLI        A,
         PCSUPERV        S,
         PCUSUARI        I,
         PCNFSAID        D,
         PCCOB           T,
         TRANSACAO_VENDA TV
   WHERE B.CODCLI = D.CODCLI
     AND I.CODUSUR = B.CODUSUR1
     AND I.CODSUPERVISOR = S.CODSUPERVISOR
     AND D.NUMTRANSVENDA = TV.NUMTRANSVENDA
     AND A.NUMTRANSENTDEVCLI = TV.NUMTRANSENT
     AND T.CODCOB = D.CODCOB
     AND NVL(A.VALOR, 0) <> 0
     AND A.DTDESCONTO IS NULL
     AND A.DTESTORNO IS NULL
     AND S.CODSUPERVISOR IN (7, 8)
     AND (B.CODCLIPRINC <> T.CODCLICC OR B.CODCLIPRINC IS NULL AND T.CODCLICC IS NOT NULL) ) X 
  ON (C.CODCLI = X.CODCLI)
  WHEN MATCHED THEN
    UPDATE SET C.CODCLIPRINC = X.CODCLICC  ;
/

SELECT ROWID,
       C.CODCLIPRINC,
       C.*
  FROM PCCLIENT C
 WHERE C.CODCLI IN (
    277931
);
/

--MYAUDIT --Clientes Ecommerce com cr�ditos sem v�nculo com cliente principal correto

WITH TRANSACAO_VENDA AS (
    SELECT NUMTRANSENT,
           MAX (M.NUMTRANSDEV) AS NUMTRANSVENDA
      FROM PCMOV M
     WHERE NUMTRANSDEV IS NOT NULL
       AND NUMTRANSENT IS NOT NULL
     GROUP BY NUMTRANSENT
)
SELECT B.CODCLIPRINC,
       (
           SELECT CLIENTE
             FROM PCCLIENT
            WHERE CODCLI = B.CODCLIPRINC
       ) CLIENTE_PRINCIPAL,
       S.CODSUPERVISOR CODSUPERV,
       S.NOME SUPERVISOR,
       B.CODCLI,
       B.CLIENTE,
       A.NUMNOTA NOTA_DEV,
       A.VALOR VL_CREDITOS,
       D.NUMNOTA NOTA_VENDA,
       D.VLTOTGER VL_VENDA,
       D.CODCOB,
       T.CODCLICC,
       (
           SELECT CLIENTE
             FROM PCCLIENT
            WHERE CODCLI = T.CODCLICC
       ) CLIENTE_COBRANCA
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
--  AND A.CODCLI IN ()

 ORDER BY S.CODSUPERVISOR,
          B.CODCLIPRINC,
          T.CODCLICC;
/