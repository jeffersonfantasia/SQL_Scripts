--DUPLICATAS ANAL�TICO
SELECT P.ROWID,
       NUMCHEQUE,
       C.CLIENTE,
       P.VALORESTORNO,
       P.PRESTTEF,
       P.NUMTRANSVENDA,
       P.NUMTRANS,
       P.OBSTITULO,
       P.DTPAG,
       P.NSUHOST, 
       P.NSUTEF,
       P.DTTRANSACAOCC,
       P.NUMRESUMO,
       P.PDV,
       P.CODBAIXACARTAOREDE,
       P.DTFECHA,
       P.*
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI --18/01/2023 - FALTA DEVOLU��O - FAVOR VERIFICAR / 16/01/2023 - DEVOLUCAO PELA MANDAE - PRAZO 27/01/2023
 WHERE P.NUMTRANSVENDA IN (11626206)
 ORDER BY DUPLIC, TO_NUMBER(PREST);

--CREDITOS_ABERTOS
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT)
SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
       C.VALOR AS VALOR_CREDITO,
       C.DTLANC DTLANC_CRED,
       D.NUMTRANSVENDA
  FROM PCCRECLI C
  JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI = D.NUMTRANSENT
 WHERE --C.DTDESCONTO IS NULL AND 
--AND T.CODCLIPRINC = 459050
 T.CODCLI = 307240;

--CORRE��O CLIENTES
SELECT C.ROWID, C.* FROM PCCLIENT C WHERE C.CLIENTE LIKE 'PAYMEE%';

--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '23/01/2023 - RIHAPPY FEZ ESTORNO TOTAL - 15/03/2023 REABERTO CHAMADO - NO AGUARDO' -- '10/02/2023 - FALTA DEVOLU��O - FAVOR VERIFICAR'
 WHERE DTPAG IS NULL
      --AND CODCLI = 25053 --AND codfilial = '9'
   AND NUMTRANSVENDA IN ( 11508814 ) ;
   
   
--UPDATE PRESTTEF
MERGE INTO PCPREST P
USING (SELECT NUMTRANSVENDA,
              DUPLIC,
              PREST,
              PRESTTEF,
              (TO_NUMBER(PREST) - 2) PRESTTEFCALC,
              VALOR,
              CODCOB,
              VPAGO
         FROM PCPREST P
        WHERE VPAGO IS NULL
          AND PRESTTEF IS NULL
          AND P.NUMTRANSVENDA IN (11614550)
        ORDER BY DUPLIC, TO_NUMBER(PREST)) X
ON (P.NUMTRANSVENDA = X.NUMTRANSVENDA AND P.PREST = X.PREST)
WHEN MATCHED THEN
  UPDATE SET P.PRESTTEF = X.PRESTTEFCALC;

--DUPLICATA A ESTORNAR EM LOTE
SELECT P.ROWID, P.NUMCHEQUE, P.*
  FROM PCPREST P
 WHERE P.NUMTRANS IS NULL
   AND P.CODCLI = 25047
   AND DTPAG IS NULL 
   AND P.NUMTRANSVENDA IN (11634497,
11635144,
11634242,
11633503,
11635064,
11635337
)
;

--UPDATE DUPLICATA A ESTORNAR EM LOTE
UPDATE PCPREST
   SET NUMCHEQUE = 3
 WHERE NUMTRANS IS NOT NULL
   AND NUMTRANSVENDA IN (11537290));

SELECT P.ROWID, P.NUMCHEQUE, P.* FROM PCPREST P WHERE P.NUMCHEQUE = 3;

--UPDATE LIMPAR NUMCHEQUE
UPDATE PCPREST SET NUMCHEQUE = NULL WHERE NUMCHEQUE = 3;
