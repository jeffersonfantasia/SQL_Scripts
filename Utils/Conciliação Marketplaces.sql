--CLIENTE
SELECT * FROM PCCLIENT WHERE CODCLI IN (
    25037, --PAGAR.ME PAGAMENTOS SA  10384
    148198, --PAYMEE BRASIL SERVICOS DE PAGAMENTOS S/A  10392
    326041, --RI HAPPY BRINQUEDOS S.A.  201
    96092, --CARREFOUR COMERCIO E INDUSTRIA LTDA 10391
    25041, --WMB COM DE ELETRONICO   10386
    25046, --CNOVA COM ELETRONICO SA 10387
    25047, --EBAZAR.COM.BR. LTDA   10388
    25053, --B2W COMPANHIA DIGITAL   10385
    47730, --MAGAZINE LUIZA S/A  10389
    63722 --AMAZON SERVIÇOS DE VAREJO DO BRASIL LTDA. 10390
);

--FORNECEDOR
SELECT F.* FROM PCFORNEC F WHERE CODFORNEC IN (
    9437,  --AMAZON SERVIÇOS DE VAREJO DO BRASIL LTDA. 15.436.940/0001-03
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
    9969,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0032-51
    9861,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0031-70
    9745,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0008-21
    9890,  --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA.  20.121.850/0001-55
    9258,  --MERCADO PAGO COM REPRESENTAÇÕES LTDA  10.573.521/0001-91
    9286,  --PAGAR.ME PAGAMENTOS SA  18.727.053/0001-74
    9624,  --PAYMEE BRASIL SERVICOS DE PAGAMENTOS S/A  28.683.892/0001-91
    9868,  --RI HAPPY BRINQUEDOS S.A 58.731.662/0001-11
    10042, --VIA S.A.  33.041.260/1201-43
    10066, --VIA S.A.  33.041.260/1995-72
    9632,  --VIA VAREJO S/A  33.041.260/0652-90
    9515,  --WALMART BRASIL LTDA 00.063.960/0001-09
    9197  --WMB COM DE ELETRONICO   14.314.050/0001-58
);
 
--COBRANÇAS
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
SELECT * FROM PCMOVCR M WHERE M.CODBANCO = 36 AND CODCOB = 'D' AND M.CODROTINALANC = 631 ORDER BY DATA DESC;

--LANCAMENTOS 631 / 638
SELECT --L.ROWID,
       L.DTESTORNOBAIXA,
       L.DTLANC,
       L.RECNUM,
       L.CODCONTA,
       L.CODFORNEC,
       L.TIPOPARCEIRO,
       L.NUMNOTA,
       L.VPAGO
  FROM PCLANC L
 WHERE EXISTS (SELECT M.NUMTRANS
          FROM PCMOVCR M
         WHERE M.CODBANCO = 62
           AND M.CODCOB = 'D'
           AND M.NUMTRANS = L.NUMTRANS)
   AND L.CODROTINABAIXA IN (631, 638)
 ORDER BY L.DTLANC;

--EXCEL
--="UPDATE PCLANC SET CODFORNEC = 148198, TIPOPARCEIRO = 'C' WHERE RECNUM = "&A1&";"

--ENCONTRAR O CLIENTE DA DUPLICATA EM ABERTO
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE DUPLIC IN ( 258691 ) ORDER BY DUPLIC, TO_NUMBER(PREST);
SELECT T.IDPONTOVENDA, T.* FROM PCPRESTTEMP T WHERE T.IDPONTOVENDA IN ( '5025774693', '5060198784');
SELECT T.IDPONTOVENDA, T.* FROM PCPRESTTEMP T WHERE T.NUMPEDWEB IN ( 37475577 );
SELECT C.NUMPEDWEB, C.NUMNOTA, C.* FROM PCPEDC C WHERE C.NUMPEDWEB = 37475577; --C.NUMPED IN ( 4200006223,4200006738);
SELECT M.DESCRICAO, M.CODCLI, M.* FROM PCMOV M WHERE M.CODFILIAL = 7 AND M.NUMNOTA IN ( 258691 );
SELECT * FROM PCCRECLI WHERE CODCLI = 372918;
SELECT CODCLIPRINC, C.* FROM PCCLIENT C WHERE C.CODCLI = 366553;
--5025774693 (252358) CANCELADO ML E ATIVO NO SISTEMA
--5060198784 ATIVO NO ML E MATADO COM CREDITO NO SISTEMA
--DUPLICATAS ESTORNADA ANALÍTICO
SELECT C.CLIENTE, P.*
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
 WHERE P.NUMTRANSVENDA = 11343187
 ORDER BY DUPLIC, TO_NUMBER(PREST);

--VERIFICAR SE POSSUI CREDITOS EM ABERTO
SELECT * FROM PCCRECLI WHERE CODCLI = 338467;

--VERIFICAR SE POSSUI CREDITO LANCADO DDE EXTRAVIO MANDAE
SELECT * FROM PCPREST P WHERE P.DTPAG IS NULL AND P.CODCLI = 94901; 

--DUPLICATAS PAGAR ME
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
       P.DTVENC,
       P.OBSTITULO
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
 WHERE P.DTPAG IS NULL
   AND (P.CODCLI = 25037 OR P.CODCOB IN ('CARP', 'BKPG'))
   AND P.DTVENC < TRUNC(SYSDATE) - 1
 ORDER BY DTVENC, DUPLIC, TO_NUMBER(PREST);

--DUPLICATAS PAYMEE
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
       P.DTVENC,
       P.OBSTITULO
  FROM PCPREST P
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
 WHERE P.DTPAG IS NULL
   AND (P.CODCLI = 148198 OR P.CODCOB IN ('PYME', 'PIX'))
   AND P.DTVENC < TRUNC(SYSDATE) - 1
 ORDER BY DTVENC, DUPLIC, TO_NUMBER(PREST);

--DUPLICATAS MERCADO LIVRE
WITH CLIENTE_PRINCIPAL AS (
    SELECT CODCLI,
           CLIENTE AS CLIENTE_PRINCIPAL
      FROM PCCLIENT
     WHERE CODCLI = CODCLIPRINC
), TRANSACAO_VENDA_DEVOLVIDA AS (
    SELECT NUMTRANSENT,
           MAX (M.NUMTRANSDEV) AS NUMTRANSVENDA,
           SUM (M.QTCONT * M.PUNITCONT) VL_DEV
      FROM PCMOV M
     WHERE NVL (NUMTRANSDEV, 0) <> 0
       AND NVL (NUMTRANSDEV, 0) <> 0
     GROUP BY NUMTRANSENT
), CREDITOS AS
(SELECT (T.CODCLIPRINC||'-'||L.CLIENTE_PRINCIPAL) CLIENTE_PRINCIPAL,
       D.NUMTRANSVENDA,
       C.NUMNOTA AS NOTA_DEV,
       D.VL_DEV,
       C.VALOR AS VL_CREDITOS,
       S.NUMNOTA AS NOTA_VENDA,
       S.VLTOTGER AS VL_VENDA,    
       B.CODCLICC,
       (S.CODCOB ||'-'||T2.CLIENTE) AS CLIENTE_COBRANCA
  FROM PCCRECLI C
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  LEFT JOIN CLIENTE_PRINCIPAL L ON T.CODCLIPRINC = L.CODCLI
  LEFT JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI = D.NUMTRANSENT
  LEFT JOIN PCNFSAID S ON S.NUMTRANSVENDA = D.NUMTRANSVENDA
  LEFT JOIN PCUSUARI U ON T.CODUSUR1 = U.CODUSUR
  LEFT JOIN PCCOB B ON S.CODCOB = B.CODCOB
  LEFT JOIN PCCLIENT T2 ON B.CODCLICC = T2.CODCLI
 WHERE NVL (C.VALOR, 0) <> 0
   AND C.DTDESCONTO IS NULL
   AND C.DTESTORNO IS NULL
   AND U.CODSUPERVISOR IN (7,8)
)
SELECT P.DTEMISSAO,
       W.NUMPEDWEB,
       W.NUMPED,
       TP.IDPONTOVENDA,
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
       T.CLIENTE_PRINCIPAL,
       T.NOTA_DEV,
       T.NOTA_VENDA,
       T.VL_VENDA,  
       T.VL_DEV,
       T.VL_CREDITOS,
       T.CODCLICC,
       T.CLIENTE_COBRANCA
  FROM PCPREST P
  INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA 
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
  LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
  LEFT JOIN CREDITOS T ON P.NUMTRANSVENDA = T.NUMTRANSVENDA
  LEFT JOIN PCPRESTTEMP TP ON W.NUMPEDWEB = TP.NUMPEDWEB
 WHERE P.DTPAG IS NULL
   AND P.DTVENC < TRUNC(SYSDATE) - 1     AND TP.IDPONTOVENDA = '5079172204'
   AND (P.CODCLI = 25047 
    OR P.CODCOB IN ('MERC') 
    OR P.CODUSUR = 42)
 ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);
