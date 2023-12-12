--DUPLICATAS ANAL�TICO
SELECT P.ROTINAPAG, P.VLROUTROSACRESC,
       P.CODBANCO,
       C.CLIENTE,
			 P.DTESTORNO,
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
       P.*,P.ROWID
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
 WHERE P.NUMTRANSVENDA IN (11844858)
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
 WHERE T.CODCLI = 522478;

--CORRE��O CLIENTES
SELECT C.ROWID, C.* FROM PCCLIENT C WHERE C.CLIENTE LIKE 'PAYMEE%';

--OBSERVA��O TITULOS POR MARKETPLACE
SELECT P.CODFILIAL,
       P.CODCLI,
       C.CLIENTE,
       P.NUMTRANSVENDA,
       P.OBSTITULO,
       P.CODCOB,
       P.VALOR,
       P.DUPLIC,
       P.PREST,
       P.DTVENC, 
       P.ROWID
  FROM PCPREST P
  JOIN PCNFSAID C ON C.NUMTRANSVENDA = P.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL
   AND P.OBSTITULO IS NOT NULL
   AND P.CODFILIAL IN ('7', '9', '10')
	 --AND P.CODFILIAL = '9'
   AND P.CODCLI = 25053
 ORDER BY P.CODFILIAL, P.CODCLI;

--OBSERVA��O TITULOS
SELECT P.ROWID, P.NUMTRANSVENDA, C.CLIENTE, P.OBSTITULO, P.*
  FROM PCPREST P JOIN PCNFSAID C ON C.NUMTRANSVENDA = P.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL
 AND P.NUMTRANSVENDA IN (11839353); --18/07/2023 - REPASSE BLOQUEADO - FAVOR VERIFICAR

--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '30/08/2023 - DEVOLUCAO A REVISAR - FAVOR VERIFICAR' 
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (11750547);

--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '30/08/2023 - MEDIACAO FINALIZADA COM REEMBOLSO PARA COMPRADOR - FAVOR VERIFICAR' 
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (11700617);
	 
--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '21/08/2023 - DEV A CAMINHO - PRAZO ATE 29/08' 
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (11738209);

--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '21/08/2023 - DEVOLUCAO PARA RETIRAR NA AGENCIA - FAVOR VERIFICAR' 
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (11738104);
	 
--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '13/11/2023 - CANCELADO PELO COMPRADOR - FAVOR VERIFICAR' 
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (11819197);

--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '06/12/2023 - FALTA DEVOLUCAO - FAVOR VERIFICAR' 
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (11847838,11847845);
	 
--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '12/07/2023 - REEMBOLSO SOB GARANTIA DE A-Z - FAVOR VERIFICAR' --ENTREGUE NO DIA 16/06/2023 - QUANDO RECEBEREMOS ESSE VALOR - FAVOR VERIFICAR
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (	11652200 );

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
          AND P.NUMTRANSVENDA IN (11846200)
        ORDER BY DUPLIC, TO_NUMBER(PREST)) X
ON (P.NUMTRANSVENDA = X.NUMTRANSVENDA AND P.PREST = X.PREST)
WHEN MATCHED THEN
  UPDATE SET P.PRESTTEF = X.PRESTTEFCALC;

--DUPLICATA A ESTORNAR EM LOTE
SELECT P.ROWID, P.NUMCHEQUE, P.NUMCUSTODIA, P.*
  FROM PCPREST P
 WHERE P.NUMTRANS IS NULL
   --AND P.CODCLI = 25047
   AND DTPAG IS NULL 
   AND P.NUMTRANSVENDA IN (11585050)
;

--UPDATE DUPLICATA A ESTORNAR EM LOTE
UPDATE PCPREST
   SET NUMCHEQUE = 3
 WHERE NUMTRANS IS NOT NULL
   AND NUMTRANSVENDA IN (11793511);

SELECT P.ROWID, P.NUMCHEQUE, P.* FROM PCPREST P WHERE P.NUMCHEQUE = 3;

--UPDATE LIMPAR NUMCHEQUE
UPDATE PCPREST SET NUMCHEQUE = NULL WHERE NUMCHEQUE = 3;
