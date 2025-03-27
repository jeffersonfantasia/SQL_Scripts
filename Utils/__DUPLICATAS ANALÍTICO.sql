--DUPLICATAS ANAL�TICO
SELECT P.ROTINAPAG,
       P.Codadmcartao,
       P.CODCOBORIG,
       P.CODBANCO,
       C.CLIENTE,
       P.DTESTORNO,
       P.VALORESTORNO, P.CODFUNCESTORNO,
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
       P.NUMTRANSVENDA,
       P.PRESTTEF,
       P.*,
       P.ROWID
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
 WHERE P.NUMTRANSVENDA IN (22286573,22281597 )
 ORDER BY DUPLIC,
          TO_NUMBER(PREST);

--CREDITOS_ABERTOS
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSENT, 0) <> 0
   GROUP BY NUMTRANSENT)
SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
       C.VALOR AS VALOR_CREDITO,
       C.DTLANC DTLANC_CRED,
       D.NUMTRANSVENDA
  FROM PCCRECLI C
  JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI = D.NUMTRANSENT
 WHERE T.CODCLIPRINC = 37484
 AND C.DTDESCONTO IS NULL;

--CORRE��O CLIENTES
SELECT C.ROWID, C.* FROM PCCLIENT C WHERE C.CLIENTE LIKE 'PAYMEE%';

--OBSERVA��O TITULOS POR MARKETPLACE
SELECT P.CODFILIAL,
       P.CODCLI,
       C.CLIENTE,
       CT.NUMPEDWEB,
       COALESCE(W.NUMPEDCLI, CT.NUMPEDCLI) NUMPEDCLI,
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
    LEFT JOIN PCPEDC W ON C.NUMTRANSVENDA = W.NUMTRANSVENDA
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = C.CODCLI
 WHERE P.DTPAG IS NULL
   AND P.OBSTITULO IS NOT NULL
   --AND W.NUMPEDCLI IN ('701-2429738-4044246', '702-1179081-1517031')
   AND P.CODCLI = 326041
 ORDER BY P.CODFILIAL, P.CODCLI;

--OBSERVA��O TITULOS
SELECT P.ROWID, P.NUMTRANSVENDA, C.CLIENTE, P.OBSTITULO, P.*
  FROM PCPREST P JOIN PCNFSAID C ON C.NUMTRANSVENDA = P.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL
 AND P.NUMTRANSVENDA IN (22189805);


--UPDATE OBSERVACAO TITULO
UPDATE PCPREST
   SET OBSTITULO = '26/03/2025 - FALTA DEVOLUCAO - FAVOR VERIFICAR' 
 WHERE DTPAG IS NULL
   AND NUMTRANSVENDA IN (22276228);
	 
--UPDATE PRESTTEF DESDOBRAR
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
          AND P.NUMTRANSVENDA IN (22218429)

        ORDER BY DUPLIC, TO_NUMBER(PREST)) X
ON (P.NUMTRANSVENDA = X.NUMTRANSVENDA AND P.PREST = X.PREST)
WHEN MATCHED THEN
  UPDATE SET P.PRESTTEF = X.PRESTTEFCALC;
	
--UPDATE PRESTTEF AGRUPAR
MERGE INTO PCPREST P
USING (SELECT NUMTRANSVENDA,
              DUPLIC,
              PREST,
              PRESTTEF,
              (TO_NUMBER(1)) PRESTTEFCALC,
              VALOR,
              CODCOB,
              VPAGO
         FROM PCPREST P
        WHERE VPAGO IS NULL
          AND PRESTTEF = 0
          AND P.NUMTRANSVENDA IN (22204559, 22238336)
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
   AND NUMTRANSVENDA IN (22163924);

SELECT P.ROWID, P.NUMCHEQUE, P.* FROM PCPREST P WHERE P.NUMCHEQUE = 3;

--UPDATE LIMPAR NUMCHEQUE
UPDATE PCPREST SET NUMCHEQUE = NULL WHERE NUMCHEQUE = 3;
