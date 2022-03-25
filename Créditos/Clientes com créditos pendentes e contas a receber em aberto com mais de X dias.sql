WITH CLIENTE_PRINCIPAL AS (
    SELECT CODCLI,
           CLIENTE AS CLIENTE_PRINCIPAL
      FROM PCCLIENT
     WHERE CODCLI = CODCLIPRINC
), TRANSACAO_VENDA_DEVOLVIDA AS (
    SELECT NUMTRANSENT,
           MAX (M.NUMTRANSDEV) AS NUMTRANSVENDA
      FROM PCMOV M
     WHERE NVL (NUMTRANSDEV, 0) <> 0
       AND NVL (NUMTRANSDEV, 0) <> 0
     GROUP BY NUMTRANSENT
), CLIENTE_PRINC_DUPLIC_ABERTO AS (
    SELECT DISTINCT P.CODCLI,
                    SUM (P.VALOR - NVL (P.VALORDESC, 0)) AS TOTAL_RECEBER_PRINCIPAL
      FROM PCPREST P
     WHERE P.DTPAG IS NULL
     GROUP BY P.CODCLI
), CLIENTE_DUPLIC_ABERTO AS (
    SELECT DISTINCT P.CODCLI,
                    SUM (P.VALOR - NVL (P.VALORDESC, 0)) AS TOTAL_RECEBER_CLIENTE
      FROM PCPREST P
     WHERE P.DTPAG IS NULL
     GROUP BY P.CODCLI
)
SELECT T.CODCLIPRINC,
       L.CLIENTE_PRINCIPAL,
       V.CODSUPERVISOR AS CODSUPERV,
       V.NOME AS SUPERVISOR,
       C.CODCLI,
       T.CLIENTE,
       C.NUMNOTA AS NOTA_DEV,
       C.VALOR AS VL_CREDITOS,
       S.NUMNOTA AS NOTA_VENDA,
       S.VLTOTGER AS VL_VENDA,
       S.CODCOB,
       B.CODCLICC,
       T2.CLIENTE AS CLIENTE_COBRANCA,
       A2.TOTAL_RECEBER_CLIENTE,
       A.TOTAL_RECEBER_PRINCIPAL,
       (
           CASE
               WHEN C.NUMTRANSENTDEVCLI IS NULL THEN 'CREDITO MANUAL'
               WHEN S.NUMNOTA IS NULL THEN 'MULTIPLAS NOTAS'
               ELSE 'NOTA UNICA'
           END
       ) AS OBS
  FROM PCCRECLI C
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  LEFT JOIN CLIENTE_PRINCIPAL L ON T.CODCLIPRINC = L.CODCLI
  LEFT JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI = D.NUMTRANSENT
  LEFT JOIN PCNFSAID S ON S.NUMTRANSVENDA = D.NUMTRANSVENDA
  LEFT JOIN PCUSUARI U ON T.CODUSUR1 = U.CODUSUR
  LEFT JOIN PCSUPERV V ON U.CODSUPERVISOR = V.CODSUPERVISOR
  LEFT JOIN PCCOB B ON S.CODCOB = B.CODCOB
  LEFT JOIN PCCLIENT T2 ON B.CODCLICC = T2.CODCLI
  LEFT JOIN CLIENTE_PRINC_DUPLIC_ABERTO A ON L.CODCLI = A.CODCLI
  LEFT JOIN CLIENTE_DUPLIC_ABERTO A2 ON C.CODCLI = A2.CODCLI
 WHERE NVL (C.VALOR, 0) <> 0
   AND C.DTDESCONTO IS NULL
   AND C.DTESTORNO IS NULL
   AND C.DTLANC <= TRUNC (SYSDATE) - 1
 ORDER BY T.CODCLIPRINC, OBS;
/