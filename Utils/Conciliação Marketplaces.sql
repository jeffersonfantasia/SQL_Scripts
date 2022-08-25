--CLIENTE
SELECT ROWID, C.CODCONTAB, C.* FROM PCCLIENT C WHERE C.CODCLI IN (
    25037, --PAGAR.ME PAGAMENTOS SA  10384
    148198, --PAYMEE BRASIL SERVICOS DE PAGAMENTOS S/A  10392
    326041, --RI HAPPY BRINQUEDOS S.A.  201
    96092, --CARREFOUR COMERCIO E INDUSTRIA LTDA 10391
    25041, --WMB COM DE ELETRONICO   10386
    25046, --CNOVA COM ELETRONICO SA 10387
    25047, --EBAZAR.COM.BR. LTDA   10388
    25053, --B2W COMPANHIA DIGITAL   10385
    47730, --MAGAZINE LUIZA S/A  10389
    63722, --AMAZON SERVI�OS DE VAREJO DO BRASIL LTDA. 10390
    8998, --REDE
    4786  --CLIELO
    
);

--TROCAR O CODCLIPRINC DO CLIENTE DEVOLUCAO 
SELECT ROWID, C.CODCLIPRINC, C.* FROM PCCLIENT C WHERE CODCLI = 401893;
SELECT ROWID, C.CODCLIPRINC, C.* FROM PCCLIENT C WHERE CODCONTAB = 202;

--FORNECEDOR
SELECT ROWID, F.CODCONTAB, F.* FROM PCFORNEC F WHERE CODFORNEC IN (
    4786,  --CIELO
    9393,  --REDECARD
    9437,  --AMAZON SERVI�OS DE VAREJO DO BRASIL LTDA. 15.436.940/0001-03
    54,    --AMERICANAS .COM S.A- COMERCIO ELETRONICO  02.866.535/0002-56
    9199,  --AMERICANAS S.A. 00.776.574/0001-56
    9578,  --CARREFOUR COMERCIO E INDUSTRIA LTDA 45.543.915/0592-32
    9542,  --CARREFOUR COMERCIO E INDUSTRIA LTDA 45.543.915/0001-81
    9815,  --CARREFOUR COMERCIO E INDUSTRIA LTDA 45.543.915/0054-93
    9375,  --CNOVA COM ELETRONICO SA 07.170.938/0001-07
    9459,  --CNOVA COMERCIO ELETRONICO S/A 07.170.938/0016-85
    9812,  --EBAZAR.COM.BR. LTDA 03.007.331/0008-18
    9382,  --EBAZAR.COM.BR. LTDA   03.007.331/0001-41
    9762,  --MAGALU PAGAMENTOS LTDA  17.948.578/0001-77
    9411,  --MAGAZINE LUIZA S/A  47.960.950/0449-27
    9466,  --MAGAZINE LUIZA S/A  47.960.950/0001-21
    9123,  --MAGAZINE LUIZA S A  47.960.950/0897-85
    9969,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0032-51
    9861,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0031-70
    9745,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0008-21
    9890,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA.  20.121.850/0001-55
    9258,  --MERCADO PAGO COM REPRESENTA��ES LTDA  10.573.521/0001-91
    9286,  --PAGAR.ME PAGAMENTOS SA  18.727.053/0001-74
    9624,  --PAYMEE BRASIL SERVICOS DE PAGAMENTOS S/A  28.683.892/0001-91
    9868,  --RI HAPPY BRINQUEDOS S.A 58.731.662/0001-11
    10042, --VIA S.A.  33.041.260/1201-43
    10066, --VIA S.A.  33.041.260/1995-72
    9632,  --VIA VAREJO S/A  33.041.260/0652-90
    9515,  --WALMART BRASIL LTDA 00.063.960/0001-09
    9197  --WMB COM DE ELETRONICO   14.314.050/0001-58
);
 
--COBRAN�AS
SELECT * FROM PCCOB WHERE CODCOB IN (
    'PYME', --PAYMEE DEPOSITO BANCARIO
    'PIX', --PAYMEE TRANSFERENCIA BANCARIA
    'BKPG', --BOLETO PAGAR.ME
    'CARP', --CARTAO PAGAR.ME
    'WALT', --CARTAO WALMART
    'CNOV', --CARTAO CREDITO CNOVA
    'MERC', --CARTAO MERCADO LIVRE
    'CABW', --CARTAO B2W
    'AMAZ', --CARTAO AMAZON 
    'CAFR', --CARTAO CARREFOUR
    'BMGL', --BOLETO MAGAZINE LUIZA
    'CMGL', --CARTAO MAGAZINE LUIZA
    'RIHP'  --CARTAO RIHAPPY
); 

--VENDEDORES
SELECT * FROM PCUSUARI WHERE CODUSUR IN (
    37,  --ECOMMERCE SITE
    38,  --AMAZON
    41,  --VIA VAREJO
    42,  --MERCADO LIVRE
    43,  --MAGAZINE LUIZA
    44,  --WALMART
    45,  --B2W
    47,  --CARREFOUR
    55   --RIHAPPY
);

--CAIXAS
SELECT * FROM PCBANCO B WHERE B.CODBANCO IN (
    11,  --CAIXA PAGAR.ME
    24,  --CAIXA B2W
    25,  --CAIXA WALMART
    26,  --CAIXA CNOVA
    36,  --CAIXA MERCADO LIVRE
    37,  --CAIXA DAFITI
    38,  --CAIXA MAGAZINE LUIZA
    39,  --CAIXA AMAZON
    51,  --CAIXA CARREFOUR
    56,  --CAIXA PAYMEE
    62   --CAIXA RIHAPPY
);

--TODOS MOVIMENTACOES NO CAIXA
SELECT * FROM PCMOVCR M WHERE M.CODBANCO = 38 AND CODCOB = 'D' AND M.CODROTINALANC = 631 ORDER BY DATA DESC;

--LANCAMENTOS 631 / 638
WITH MOV_BANCO AS (
SELECT DISTINCT M.NUMTRANS
          FROM PCMOVCR M
         WHERE M.CODBANCO = 38
           AND M.CODCOB = 'D')
SELECT L.ROWID,
       L.DTESTORNOBAIXA,
       L.DTLANC,
       L.RECNUM,
       L.CODCONTA,
       C.CONTA,
       L.HISTORICO,
       L.HISTORICO2,
       L.CODFORNEC,
       L.TIPOPARCEIRO,
       L.NUMNOTA,
       L.VPAGO
  FROM PCLANC L
  JOIN MOV_BANCO M ON M.NUMTRANS = L.NUMTRANS
  JOIN PCCONTA C ON C.CODCONTA = L.CODCONTA
 WHERE L.CODROTINABAIXA IN (631, 638, 749)
   AND L.NUMNOTA = 0
 ORDER BY L.DTLANC;

--EXCEL
--="UPDATE PCLANC SET CODFORNEC = 148198, TIPOPARCEIRO = 'C' WHERE RECNUM = "&A1&";"

--ENCONTRAR O CLIENTE DA DUPLICATA EM ABERTO
SELECT ROWID, P.NUMTRANSVENDA, P.PRESTTEF, P.* FROM PCPREST P WHERE DUPLIC IN ( 284954 ) ORDER BY DUPLIC, TO_NUMBER(PREST);
SELECT ROWID,P.NUMTRANSVENDA, P.PRESTTEF, P.* FROM PCPREST P WHERE P.NUMTRANSVENDA = 11382506
 ORDER BY DUPLIC, TO_NUMBER(PREST);
;
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.NSUTEF IN ( 878962789 ) ORDER BY DUPLIC, TO_NUMBER(PREST);
SELECT T.IDPONTOVENDA, T.* FROM PCPRESTTEMP T WHERE T.IDPONTOVENDA IN ( '5025774693', '5060198784');
SELECT ROWID, T.IDPONTOVENDA, T.NSUTEF, T.CODAUTTEF, T.PRESTTEF, T.* FROM PCPRESTTEMP T WHERE T.NSUTEF IN (659920878) OR T.IDTITULO = 494740 ;
SELECT ROWID, T.* FROM PCPEDCTEMP T WHERE T.NUMPEDCLI = '5074064845' ;
SELECT C.ROWID,  C.NUMPEDWEB, C.NUMNOTA, C.NUMTRANSVENDA, C.* FROM PCPEDC C WHERE C.NUMTRANSVENDA = 11389578 ;--C.NUMPEDWEB = 558923; --C.NUMPED IN ( 4200006223,4200006738);
SELECT M.DESCRICAO, M.CODCLI, M.* FROM PCMOV M WHERE M.CODFILIAL = 7 AND M.NUMNOTA IN ( 258691 );
SELECT * FROM PCCRECLI WHERE CODCLI = 372918;
SELECT * FROM PCCRECLI C WHERE C.NUMTRANSVENDA = 11202213;
SELECT CODCLIPRINC, C.* FROM PCCLIENT C WHERE C.CODCLI = 366553;

--ATUALIZAR NSUTEF / CODAUTTEF PAGAR.ME
SELECT ROWID, T.IDPONTOVENDA, T.NSUTEF, T.CODAUTTEF, T.PRESTTEF, T.*
  FROM PCPRESTTEMP T
 WHERE T.NUMPEDWEB = 558923 ;

--DUPLICATAS ESTORNADA ANAL�TICO
SELECT C.CLIENTE, P.PRESTTEF, P.ROWID, P.NUMTRANSVENDA, P.OBSTITULO, P.*
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
 WHERE P.NUMTRANSVENDA IN (11408054) --627427757
 ORDER BY DUPLIC, TO_NUMBER(PREST);

--VERIFICAR SE POSSUI CREDITOS EM ABERTO
SELECT * FROM PCCRECLI WHERE CODCLI = 251579;

--VERIFICAR SE POSSUI CREDITO LANCADO DDE EXTRAVIO MANDAE
SELECT * FROM PCPREST P WHERE P.DTPAG IS NULL AND P.CODCLI = 94901; 

--VERIFICAR SE A TAXA FOI BAIXADO EM OUTRA CONTA
SELECT L.CODFILIAL, L.CODROTINABAIXA, L.RECNUM, L.DTLANC, L.TIPOPARCEIRO, L.CODFORNEC, C.CLIENTE, L.HISTORICO, L.NUMNOTA, L.VPAGO, L.NOMEFUNC
FROM PCLANC L 
LEFT JOIN PCCLIENT C ON L.CODFORNEC = C.CODCLI
WHERE L.CODROTINABAIXA IN (1207, 9876) AND L.CODCONTA = 620103 AND CODFILIAL IN (1,7,9) AND L.DTLANC >= TRUNC(SYSDATE) - 30;

--UPDATE DE CORRE��O
UPDATE PCLANC L SET L.CODCONTA = 620108
WHERE L.CODROTINABAIXA IN (1207, 9876) AND L.CODCONTA = 620103 AND L.CODFILIAL IN (1,7,9) AND L.DTLANC >= TRUNC(SYSDATE) - 30;

SELECT * FROM PCLANC L WHERE L.DTLANC = '23-06-2022';

/******************************************/
/*       DUPLICATAS REDE B2B FILIAL 2     */
/******************************************/
--VERIFICAR NSU / PRESTTEF / NUMRESUMO / PDV / DTTRANSACAOCC NA DUPLICATA DESDOBRADA
SELECT ROWID,
       P.ROTINAPAG,
       P.NSUTEF,
       P.NSUHOST,
       P.PRESTTEF,
       P.NUMRESUMO,
       P.PDV,
       P.CODBAIXACARTAOREDE,
       P.DTTRANSACAOCC,
       P.*
  FROM PCPREST P
 WHERE CODCOB = 'CARC'
   AND CODFILIAL = 2
 ORDER BY DUPLIC, TO_NUMBER(PREST);

/***********************************************/
/* DUPLICATAS REDE LOJAS COM CREDITO EM ABERTO */
/***********************************************/
--VERIFICAR NSU / PRESTTEF / NUMRESUMO / PDV / DTTRANSACAOCC NA DUPLICATA DESDOBRADA
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),
CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
         C.VALOR AS VALOR_CREDITO,
         C.DTDESCONTO,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)
SELECT --P.ROWID,
       A.CLIENTE,
       A.VALOR_CREDITO,
       P.NSUHOST,
       P.NSUTEF,
       (P.VALOR - P.VALORDESC) VLLIQ
       ,P.*
  FROM PCPREST P
  LEFT JOIN CREDITOS_ABERTOS A ON P.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE P.CODCLI = 8998 --AND P.DUPLIC = 3702
   AND P.CODFILIAL IN ('1','2','8')
   AND A.DTDESCONTO IS NULL
   AND P.DTPAG IS NULL
   AND P.DTVENC < TRUNC(SYSDATE)
 ORDER BY P.DUPLIC, TO_NUMBER(P.PREST);


/******************************************/
/*       DUPLICATAS PAGAR ME              */
/******************************************/

WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),
CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
         C.VALOR AS VALOR_CREDITO,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)
SELECT P.ROWID, 
       P.DTEMISSAO,
       W.NUMPEDWEB,
       T.NSUTEF,
       T.CODAUTTEF,
       P.PRESTTEF,
       P.CODCLI||' - '||C.CLIENTE CLIENTE,
       P.NUMTRANSVENDA,
       P.CODCOB,
       P.CODUSUR,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       NVL(P.VALORDESC, 0) VALORDESC,
       (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
       P.DTEMISSAO,
       P.DTVENC,
       P.OBSTITULO,
       A.CLIENTE,
       A.VALOR_CREDITO
      -- , P.*
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN PCPRESTTEMP T ON W.NUMPEDWEB = T.NUMPEDWEB AND P.PRESTTEF = T.PRESTTEF
  LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL --AND P.NUMTRANSVENDA = 11337923
   AND (P.CODCLI = 25037 OR P.CODCOB IN ('CARP', 'BKPG'))
   AND P.DTVENC < TRUNC(SYSDATE) - 1
 ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);

--INSERCAO DO NSU NO CAMPO NUMPEDWEB PARA PEDIDOS DIGITADOS---
SELECT C.ROWID,
       C.NUMPEDWEB,
       C.NUMPEDRCA,
       T.CLIENTE,
       C.CODCOB,
       C.VLTOTAL
  FROM PCPEDC C
  JOIN PCCLIENT T ON T.CODCLI = C.CODCLI
 WHERE C.NUMTRANSVENDA IN ( 11389578, 11397826, 11397831);
 -------------------------------------------------------------

/******************************************/
/*       DUPLICATAS PAYMEE                */
/******************************************/

WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),
CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
         C.VALOR AS VALOR_CREDITO,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)
SELECT P.DTEMISSAO,
       W.NUMPEDWEB,
       P.CODCLI||' - '||C.CLIENTE CLIENTE,
       P.NUMTRANSVENDA,
       P.CODCOB,
       P.CODUSUR,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       NVL(P.VALORDESC, 0) VALORDESC,
       (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
       P.DTEMISSAO,
       P.DTVENC,
       P.OBSTITULO,
       A.CLIENTE,
       A.VALOR_CREDITO
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL
   AND (P.CODCLI = 148198 OR P.CODCOB IN ('PYME', 'PIX'))
   AND P.DTVENC < TRUNC(SYSDATE) ---1
 ORDER BY DTVENC, DUPLIC, TO_NUMBER(PREST);

/******************************************/
/*        DUPLICATAS MERCADO LIVRE        */
/******************************************/
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),
CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
         C.VALOR AS VALOR_CREDITO,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)
SELECT P.DTEMISSAO,
       W.NUMPEDWEB,
       W.NUMPED,
       TP.IDPONTOVENDA,
       COALESCE(CT.NUMPEDCLI,W.NUMPEDCLI) NUMPEDCLI,
       W.NUMPEDCLI,
       W.NUMPEDRCA,
       P.CODCLI||' - '||C.CLIENTE CLIENTE,
       P.NUMTRANSVENDA,
       P.CODCOB,
       P.CODUSUR,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       NVL(P.VALORDESC, 0) VALORDESC,
       (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
       P.DTVENC,
       P.OBSTITULO,
       A.CLIENTE,
       A.VALOR_CREDITO
  FROM PCPREST P
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
  LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
  LEFT JOIN PCPRESTTEMP TP ON W.NUMPEDWEB = TP.NUMPEDWEB
 WHERE (P.DTPAG IS NULL OR P.CODCOB = 'CRED')
       --CT.NUMPEDCLI = '2000003941822402'
       --P.CODCOB = 'CANC' AND P.DTEMISSAO >= '28/07/2022'
   AND P.DTVENC < TRUNC(SYSDATE) - 1
   AND (P.CODCLI = 25047 
    OR P.CODCOB IN ('MERC') 
    OR P.CODUSUR = 42) AND P.CODFILIAL = '9'
 ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);
 
 
/******************************************/
/*         DUPLICATAS RIHAPPY              */
/******************************************/
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),
CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
         C.VALOR AS VALOR_CREDITO,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)
SELECT P.DTEMISSAO,
       CT.ARQUIVO, 
       CT.NUMPEDMKTPLACE,
       W.NUMPEDCLI,
       CT.NUMPEDCLI,
       COALESCE( CT.ARQUIVO, CT.NUMPEDMKTPLACE, W.NUMPEDCLI, CT.NUMPEDCLI) IDPEDIDO,
       W.NUMPED,
       P.CODCLI||' - '||C.CLIENTE CLIENTE,
       P.NUMTRANSVENDA,
       P.CODCOB,
       P.CODUSUR,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       NVL(P.VALORDESC, 0) VALORDESC,
       (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
       P.DTVENC,
       P.OBSTITULO,
       A.CLIENTE,
       A.VALOR_CREDITO
  FROM PCPREST P
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
  LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL
   AND P.DTVENC < TRUNC(SYSDATE) - 1 
   AND (P.CODCLI = 326041 
    OR P.CODCOB IN ('RIHP') 
    OR P.CODUSUR = 55)
    --AND S.NUMPED IN (5500003728)
 ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);
 
 
 /******************************************/
/*         DUPLICATAS MAGALU              */
/******************************************/
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),
CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
         C.VALOR AS VALOR_CREDITO,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)
SELECT P.DTEMISSAO,
       W.NUMPEDCLI NUMPEDCLI_C,
       CT.NUMPEDCLI NUMPEDCLI_CT,
       P.CODCLI||' - '||C.CLIENTE CLIENTE,
       P.NUMTRANSVENDA,
       P.CODCOB,
       P.CODUSUR,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       NVL(P.VALORDESC, 0) VALORDESC,
       (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
       P.DTVENC,
       P.OBSTITULO,
       A.CLIENTE,
       A.VALOR_CREDITO--, P.ROWID
  FROM PCPREST P
  JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
  LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL 
 --AND CT.NUMPEDCLI IN ('LU-1150470885548115')
   AND P.DTVENC < TRUNC(SYSDATE) - 1 
   AND (P.CODCLI = 47730 
    OR P.CODCOB IN ('CMGL', 'BMGL') 
    OR P.CODUSUR = 43)
     --AND P.OBSTITULO IS NOT NULL
 ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);


 /******************************************/
/*         DUPLICATAS B2W                 */
/******************************************/
WITH TRANSACAO_VENDA_DEVOLVIDA AS
 (SELECT NUMTRANSENT, MAX(M.NUMTRANSDEV) AS NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(NUMTRANSDEV, 0) <> 0
     AND NVL(NUMTRANSDEV, 0) <> 0
   GROUP BY NUMTRANSENT),
CREDITOS_ABERTOS AS
 (SELECT (C.CODCLI || '-' || T.CLIENTE) CLIENTE,
         C.VALOR AS VALOR_CREDITO,
         D.NUMTRANSVENDA
    FROM PCCRECLI C
   INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                             D.NUMTRANSENT
   INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
   WHERE C.DTDESCONTO IS NULL)
SELECT P.DTEMISSAO,
       W.NUMPEDCLI NUMPEDCLI_C,
       CT.NUMPEDCLI NUMPEDCLI_CT,
       P.CODCLI||' - '||C.CLIENTE CLIENTE,
       P.NUMTRANSVENDA,
       P.CODCOB,
       P.CODUSUR,
       (P.DUPLIC || '-' || P.PREST) DUPLICATA,
       P.VALOR,
       NVL(P.VALORDESC, 0) VALORDESC,
       (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
       P.DTVENC,
       P.OBSTITULO,
       A.CLIENTE, --p.dtpag,
       A.VALOR_CREDITO --, P.ROWID
  FROM PCPREST P
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
  LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE P.DTPAG IS NULL --AND P.NUMTRANSVENDA = 10171696
 --AND W.NUMPEDCLI IN ( '296056897101', '353796504801', '296384574501')
   AND P.DTVENC < TRUNC(SYSDATE) - 1 
   AND (P.CODCLI = 25053 
    OR P.CODCOB IN ('CABW') 
    OR P.CODUSUR = 45) --AND W.NUMPEDCLI IS NULL
 ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);
 
 ---------UPDATE B2W PCPEDC.NUMPEDCLI--------------
 MERGE INTO PCPEDC C
USING (SELECT P.DTEMISSAO,
              W.NUMPEDCLI NUMPEDCLI_C,
              CT.NUMPEDCLI NUMPEDCLI_CT,
              SUBSTR(CT.NUMPEDCLI, INSTR(CT.NUMPEDCLI, '-') + 1) NV_NUMPEDCLI,
              P.NUMTRANSVENDA
         FROM PCPREST P
         LEFT JOIN PCPEDC W ON W.NUMTRANSVENDA = P.NUMTRANSVENDA
         LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
        WHERE P.DTPAG IS NULL
          AND P.DTVENC < TRUNC(SYSDATE) - 1
          AND W.NUMPEDCLI IS NULL
          AND CT.NUMPEDCLI IS NOT NULL
          AND (P.CODCLI = 25053 OR P.CODCOB IN ('CABW') OR P.CODUSUR = 45)) X
ON (C.NUMTRANSVENDA = X.NUMTRANSVENDA)
WHEN MATCHED THEN
  UPDATE SET C.NUMPEDCLI = X.NV_NUMPEDCLI;
 ----------------------------------------------