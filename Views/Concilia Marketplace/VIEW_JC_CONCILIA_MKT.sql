CREATE OR REPLACE VIEW VIEW_JC_CONCILIA_MKT AS
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT,
         MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),

CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE_CREDITO,
         C.VALOR AS VALOR_CREDITO,
         C.DTLANC DTLANC_CRED,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)

SELECT P.CODFILIAL,
       P.DTEMISSAO,
       COALESCE(W.NUMPEDCLI, CT.NUMPEDCLI, P.NSUTEF) NUMPEDCLI,
       P.CODCLI,
       P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
       P.NUMTRANSVENDA,
       P.CODCOB,
       P.CODUSUR,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       NVL(P.VALORDESC, 0) VALORDESC,
       (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
       P.VALORESTORNO,
       P.DTVENC,
       P.DTPAG,
       P.CODBANCO,
       P.VPAGO,
       P.OBSTITULO,
       A.CLIENTE_CREDITO,
       A.VALOR_CREDITO,
       A.DTLANC_CRED
  FROM PCPREST P
  JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                         AND CT.CODCLI = S.CODCLI
  LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE (P.DTPAG IS NULL 
       OR (P.CODCOB IN ('CRED', 'CARC')) 
       AND NVL(P.DTPAG, TO_DATE('01/01/2023', 'DD/MM/YYYY')) > TO_DATE('01/01/2024', 'DD/MM/YYYY'))
   AND P.CODCOB NOT IN ('PEND', 'JUR')
