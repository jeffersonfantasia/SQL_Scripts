--CLIENTE
SELECT ROWID, C.CODCONTAB, C.*
  FROM PCCLIENT C
 WHERE C.CODCLI IN (25037, --PAGAR.ME PAGAMENTOS SA  10384
                    148198, --PAYMEE BRASIL SERVICOS DE PAGAMENTOS S/A  10392
                    326041, --RI HAPPY BRINQUEDOS S.A.  201
                    96092, --CARREFOUR COMERCIO E INDUSTRIA LTDA 10391
                    25041, --WMB COM DE ELETRONICO   10386
                    25046, --CNOVA COM ELETRONICO SA 10387
                    25047, --EBAZAR.COM.BR. LTDA   10388
                    25053, --B2W COMPANHIA DIGITAL   10385
                    47730, --MAGAZINE LUIZA S/A  10389
                    63722, --AMAZON SERVIÇOS DE VAREJO DO BRASIL LTDA. 10390
                    8998, --REDE
                    4786, --CIELO
                    473516, --GIMBA - SUPRICORP SUPRIMENTOS LTDA 10403
                    477615, --CASA & VIDEO BRASIL S.A
                    477468, --SHOPEE - SHPS TECNOLOGIA E SERVICOS LTDA
                    37484, --FESTALAB FESTAS E EVENTOS LTDA ­ ME
                    42853, --DAFITI - GFG COMERCIO DIGITAL LTDA
                    560317,--IUPP S.A. (ITAUSHOP)
                    563376, --LIVELO S.A.
                    564395, --SENFF SHOPPING LTDA
                    566992, --BRADESCOSHOP 
										593053 --IFOOD
                    );

--TROCAR O CODCLIPRINC DO CLIENTE DEVOLUCAO 
SELECT ROWID, C.CODCLIPRINC, C.* FROM PCCLIENT C WHERE CODCLI = 401893;
SELECT ROWID, C.CODCLIPRINC, C.* FROM PCCLIENT C WHERE CODCONTAB = 202;

--FORNECEDOR
SELECT ROWID, F.CODCONTAB, F.*
  FROM PCFORNEC F
 WHERE CODFORNEC IN (4786, --CIELO
                     9393, --REDECARD
                     9437, --AMAZON SERVIÇOS DE VAREJO DO BRASIL LTDA. 15.436.940/0001-03
                     54, --AMERICANAS .COM S.A- COMERCIO ELETRONICO  02.866.535/0002-56
                     9199, --AMERICANAS S.A. 00.776.574/0001-56
                     9578, --CARREFOUR COMERCIO E INDUSTRIA LTDA 45.543.915/0592-32
                     9542, --CARREFOUR COMERCIO E INDUSTRIA LTDA 45.543.915/0001-81
                     9815, --CARREFOUR COMERCIO E INDUSTRIA LTDA 45.543.915/0054-93
                     9375, --CNOVA COM ELETRONICO SA 07.170.938/0001-07
                     9459, --CNOVA COMERCIO ELETRONICO S/A 07.170.938/0016-85
                     9812, --EBAZAR.COM.BR. LTDA 03.007.331/0008-18
                     9382, --EBAZAR.COM.BR. LTDA   03.007.331/0001-41
                     10170, --EBAZAR.COM.BR. LTDA   03.007.331/0049-96
                     9762, --MAGALU PAGAMENTOS LTDA  17.948.578/0001-77
                     9411, --MAGAZINE LUIZA S/A  47.960.950/0449-27
                     9466, --MAGAZINE LUIZA S/A  47.960.950/0001-21
                     9123, --MAGAZINE LUIZA S A  47.960.950/0897-85
                     9969, --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0032-51
                     9861, --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0031-70
                     9745, --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA 20.121.850/0008-21
                     9890, --MERCADO ENVIOS SERVICOS DE LOGISTICA LTDA.  20.121.850/0001-55
                     9258, --MERCADO PAGO COM REPRESENTAÇÕES LTDA  10.573.521/0001-91
                     10323, --EBAZAR.COM.BR. LTDA 03.007.331/0122-39
                     10325, --EBAZAR.COM.BR. LTDA 03.007.331/0015-47
                     9286, --PAGAR.ME PAGAMENTOS SA  18.727.053/0001-74
                     9624, --PAYMEE BRASIL SERVICOS DE PAGAMENTOS S/A  28.683.892/0001-91
                     9868, --RI HAPPY BRINQUEDOS S.A 58.731.662/0001-11
                     10086, --RI HAPPY BRINQUEDOS SA 58.731.662/0231-62
                     10042, --VIA S.A.  33.041.260/1201-43
                     10066, --VIA S.A.  33.041.260/1995-72
                     9632, --VIA VAREJO S/A  33.041.260/0652-90
                     9515, --WALMART BRASIL LTDA 00.063.960/0001-09
                     9197, --WMB COM DE ELETRONICO   14.314.050/0001-58
                     10248, --CASA & VIDEO BRASIL S.A
                     10247, --SHOPEE - SHPS TECNOLOGIA E SERVICOS LTDA
                     10246, -- FESTALAB FESTAS E EVENTOS LTDA
                     10253, --GIMBA - SUPRICORP SUPRIMENTOS LTDA 10403
                     10530, --IUPP S.A.
                     10558, --LIVELO S.A.
                     10560, --SENFF SHOPPING LTDA
                     10572, --BRADSESCOSHOP
										 10673 --IFOOD
                     );
/
--COBRANÇAS
  SELECT *
    FROM PCCOB
   WHERE CODCOB IN ('PYME', --PAYMEE DEPOSITO BANCARIO
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
                    'RIHP', --CARTAO RIHAPPY
                    'CGBA', --CARTAO GIMBA
                    'SHPE', --CARTAO SHOPEE
                    'CSVD', --CARTAO CASAVIDEO
                    'FTLB', --CARTAO FESTALAB
                    'ISHP', --CARTAO ITAUSHOP
                    'LIVL', --CARTAO LIVELO
                    'SENF', --CARTAO SENFF
										'IFOD' --CARTAO IFOOD
                    );
/
--VENDEDORES
  SELECT *
    FROM PCUSUARI
   WHERE CODUSUR IN (37, --ECOMMERCE SITE
                     38, --AMAZON
                     41, --VIA VAREJO
                     42, --MERCADO LIVRE
                     43, --MAGAZINE LUIZA
                     44, --WALMART
                     45, --B2W
                     47, --CARREFOUR
                     55, --RIHAPPY,
                     70, --GIMBA
                     75, --SHOPEE
                     74, --FESTALAB 
                     76,  --CASAVIDEO
                     112,  --ITAUSHOP
                     119,  --LIVELO
                     120,  --SENFF
										 138,139,140,141,142 --IFOOD
                     );
/
--CAIXAS
  SELECT ROWID, B.*
    FROM PCBANCO B
   WHERE B.CODBANCO IN (11, --CAIXA PAGAR.ME
                        24, --CAIXA B2W
                        25, --CAIXA WALMART
                        26, --CAIXA CNOVA
                        36, --CAIXA MERCADO LIVRE JC
                        69, --CAIXA MERCADO LIVRE CFF
                        74, --CAIXA MERCADO LIVRE FFJ
                        37, --CAIXA DAFITI
                        38, --CAIXA MAGAZINE LUIZA
                        39, --CAIXA AMAZON
                        51, --CAIXA CARREFOUR
                        56, --CAIXA PAYMEE
                        62, --CAIXA RIHAPPY
                        64, --CAIXA GIMBA
                        79, --CAIXA CASA E VIDEO
                        77, --CAIXA FESTA LAB
                        78, --CAIXA SHOPEE
                        95,  --ITAUSHOP
                        96,  --LIVELO
                        97,  --SENFF
												21 --IFOOD
                        ) ORDER BY CODBANCO;
/
--TODOS MOVIMENTACOES NO CAIXA
  SELECT *
    FROM PCMOVCR M
   WHERE M.CODBANCO = 38
     AND CODCOB = 'D'
     AND M.CODROTINALANC = 631
   ORDER BY DATA DESC;
/
--LANCAMENTOS 631 / 638
  WITH MOV_BANCO AS
   (SELECT DISTINCT M.NUMTRANS
      FROM PCMOVCR M
     WHERE M.CODBANCO = 36
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
     AND L.CODCONTA IN (420102, 650104)
     AND L.NUMNOTA = 0
   ORDER BY L.DTLANC;

/
/******************************************/
/*       DUPLICATAS REDE B2B FILIAL 2/11     */
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
				 P.CODCOBORIG,
         P.*
    FROM PCPREST P
   WHERE CODCOB = 'CARC'
     AND CODFILIAL = '11'
   ORDER BY DTEMISSAO DESC, DUPLIC, TO_NUMBER(PREST);

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
SELECT P.ROWID,
 A.CLIENTE,
 A.VALOR_CREDITO,
 P.NSUHOST,
 P.NSUTEF,
 (P.VALOR - P.VALORDESC) VLLIQ,
 P.*
  FROM PCPREST P
  LEFT JOIN CREDITOS_ABERTOS A ON P.NUMTRANSVENDA = A.NUMTRANSVENDA
 WHERE P.CODCLI = 8998 --AND P.DUPLIC = 3702
   AND P.CODFILIAL IN ('1', '2', '8', '12', '13')
   AND A.DTDESCONTO IS NULL
   AND P.DTPAG IS NULL
   --AND P.DTVENC < TRUNC(SYSDATE)
 ORDER BY P.DUPLIC, TO_NUMBER(P.PREST);
/
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.DTEMISSAO,
         W.NUMPEDWEB,
         T.NSUTEF,
         T.CODAUTTEF,
         P.PRESTTEF,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
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
         P.DTPAG,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED
  --,P.ROWID, P.*
    FROM PCPREST P
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPRESTTEMP T ON W.NUMPEDWEB = T.NUMPEDWEB
                           AND P.PRESTTEF = T.PRESTTEF
                           AND T.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE P.DTPAG IS NULL
        --AND P.NUMTRANSVENDA = 11499419
        --(P.DTPAG IS NULL OR P.CODCOB = 'CRED')
     AND (P.CODCLI = 25037 OR P.CODCOB IN ('CARP', 'BKPG'))
     AND P.DTVENC < TRUNC(SYSDATE) - 1
   ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);

--INSERCAO DO NSU NO CAMPO NUMPEDWEB PARA PEDIDOS DIGITADOS---
SELECT C.ROWID, C.NUMPEDWEB, C.NUMPEDRCA, T.CLIENTE, C.CODCOB, C.VLTOTAL
  FROM PCPEDC C
  JOIN PCCLIENT T ON T.CODCLI = C.CODCLI
 WHERE C.NUMTRANSVENDA IN (11389578, 11397826, 11397831);
-------------------------------------------------------------
/
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.DTEMISSAO,
         W.NUMPEDWEB,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
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
         P.DTPAG,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED
    FROM PCPREST P
    JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
     JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE P.DTPAG IS NULL
     AND (P.CODCLI = 148198 OR P.CODCOB IN ('PYME', 'PIX'))
     --AND P.DTVENC < TRUNC(SYSDATE) ---1
   ORDER BY DTVENC, DUPLIC, TO_NUMBER(PREST);
/
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT DISTINCT P.CODFILIAL, P.DTEMISSAO,
         W.NUMPEDWEB,
         W.NUMPED,
         W.NUMPEDCLI,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED
    FROM PCPREST P
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
    LEFT JOIN PCPRESTTEMP TP ON W.NUMPEDWEB = TP.NUMPEDWEB
   WHERE P.DTPAG IS NULL 
     --AND P.DTVENC < TRUNC(SYSDATE) - 1
    AND (P.CODCLI = 25047 OR P.CODCOB IN ('MERC') OR P.CODUSUR = 42)
   --AND P.CODFILIAL IN ('7', '9', '10')
	 AND P.CODFILIAL = '10'
	 --AND P.NUMTRANSVENDA = 11829167
   ORDER BY P.DTVENC, DUPLICATA ;
/
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
      JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                          D.NUMTRANSENT
      JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.DTEMISSAO,
         W.NUMPEDCLI,
         COALESCE( CT.ARQUIVO, CT.NUMPEDMKTPLACE) NV_NUMPEDCLI,
         W.NUMPEDWEB,
         W.NUMPED,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED --, p.rowid
    FROM PCPREST P
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE P.DTPAG IS NULL
     AND P.DTVENC < TRUNC(SYSDATE) - 1
     AND (P.CODCLI = 326041 OR P.CODCOB IN ('RIHP') OR P.CODUSUR = 55)
   ORDER BY W.NUMPEDCLI, P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST); --v27593745rihp
/
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.DTEMISSAO,
         W.NUMPEDCLI NUMPEDCLI_C,
         CT.NUMPEDCLI NUMPEDCLI_CT,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED --, P.ROWID
    FROM PCPREST P
    JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE P.DTPAG IS NULL
        --(P.DTPAG IS NULL OR (P.CODCOB IN ('CRED', 'CARC')) AND NVL(P.DTPAG, TO_DATE('01/01/2021','DD/MM/YYYY')) > TO_DATE('01/01/2022','DD/MM/YYYY'))
        --AND P.NUMTRANSVENDA IN (11536055)
     AND P.DTVENC < TRUNC(SYSDATE) - 1
     AND (P.CODCLI = 47730 OR P.CODCOB IN ('CMGL', 'BMGL') OR
         P.CODUSUR = 43)
  --AND P.OBSTITULO IS NOT NULL
   ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);
/
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.DTEMISSAO,
         W.NUMPEDCLI NUMPEDCLI,
         CT.NUMPEDCLI NUMPEDCLI_CT,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED , P.ROWID
    FROM PCPREST P
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE P.DTPAG IS NULL
        --(P.DTPAG IS NULL OR (P.CODCOB IN ('CRED', 'CARC')) AND NVL(P.DTPAG, TO_DATE('01/01/2021','DD/MM/YYYY')) > TO_DATE('01/01/2022','DD/MM/YYYY'))
        --AND P.NUMTRANSVENDA = 11406767
        --AND W.NUMPEDCLI IN ( '297582641701')
     AND P.DTVENC < TRUNC(SYSDATE)
     AND (P.CODCLI = 25053 OR P.CODCOB IN ('CABW') OR P.CODUSUR = 45) --AND W.NUMPEDCLI IS NULL
   ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);


/******************************************/
/*         DUPLICATAS AMAZON              */
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.CODFILIAL, P.DTEMISSAO,
         W.NUMPEDCLI NUMPEDCLI,
         --CT.NUMPEDCLI NV_NUMPEDCLI,
         W.NUMPEDRCA,
         W.NUMPED, --W.origemped,
         -- (SELECT CLIENTE FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CLIENTE_ORIG,
         -- (SELECT CGCENT FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CPF,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED --, P.ROWID
    FROM PCPREST P
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE P.DTPAG IS NULL
    -- AND P.DTVENC < TRUNC(SYSDATE) - 1
     AND (P.CODCLI = 63722 OR P.CODCOB IN ('AMAZ') OR P.CODUSUR = 38)
		 AND P.CODFILIAL IN ( '7')
   ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);

	 
/******************************************/
/*         DUPLICATAS FESTALAB            */
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.DTEMISSAO,
         --W.NUMPEDCLI NUMPEDCLI,
         COALESCE(W.NUMPEDCLI, CT.NUMPEDCLI) NUMPEDCLI,
         W.NUMPEDRCA,
         W.NUMPED,
         (SELECT CLIENTE FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CLIENTE_ORIG,
         (SELECT CGCENT FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CPF,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         (S.VLTOTAL - NVL(S.VLFRETE,0)) VLPRODUTO,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.VPAGO,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED , P.ROWID
    FROM PCPREST P
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE (P.CODCLI = 37484 OR P.CODCOB IN ('FTLB') OR P.CODUSUR = 74) 
     --AND P.DTVENC < TRUNC(SYSDATE) - 1
     AND P.DTPAG IS NULL
		 AND P.CODFILIAL IN ( '9')
		 --AND CT.NUMPEDCLI = '1385110586081-01'
   ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);

	 
/******************************************/
/*         DUPLICATAS ITAUSHOP            */
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.DTEMISSAO,
         --W.NUMPEDCLI NUMPEDCLI,
         COALESCE(W.NUMPEDCLI, CT.NUMPEDCLI) NUMPEDCLI,
         W.NUMPEDRCA,
         W.NUMPED,
         (SELECT CLIENTE FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CLIENTE_ORIG,
         (SELECT CGCENT FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CPF,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         (S.VLTOTAL - NVL(S.VLFRETE,0)) VLPRODUTO,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.VPAGO,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED , P.ROWID
    FROM PCPREST P
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN PCPEDCTEMP CT ON W.NUMPEDWEB = CT.NUMPEDWEB
                           AND CT.CODCLI = S.CODCLI
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE (P.CODCLI = 560317 OR P.CODCOB IN ('ISHP') OR P.CODUSUR = 112) 
     --AND P.DTVENC < TRUNC(SYSDATE) - 1
     AND P.DTPAG IS NULL
		 AND P.CODFILIAL = '10'
   ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);
	 
	 
/******************************************/
/*         DUPLICATAS IFOOD               */
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
           C.DTLANC DTLANC_CRED,
           D.NUMTRANSVENDA
      FROM PCCRECLI C
     INNER JOIN TRANSACAO_VENDA_DEVOLVIDA D ON C.NUMTRANSENTDEVCLI =
                                               D.NUMTRANSENT
     INNER JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
     WHERE C.DTDESCONTO IS NULL)
  SELECT P.CODFILIAL,
	       P.DTEMISSAO,
         P.NSUTEF,
				 W.NUMPEDCLI,
         W.NUMPED,
         (SELECT CLIENTE FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CLIENTE_ORIG,
         (SELECT CGCENT FROM PCCLIENT C WHERE C.CODCLI = W.CODCLI) CPF,
         P.CODCLI || ' - ' || C.CLIENTE CLIENTE,
         P.NUMTRANSVENDA,
         P.CODCOB,
         P.CODUSUR,
         (P.DUPLIC || '-' || P.PREST) DUPLICATA,
         (S.VLTOTAL - NVL(S.VLFRETE,0)) VLPRODUTO,
         P.VALOR,
         NVL(P.VALORDESC, 0) VALORDESC,
         (P.VALOR - NVL(P.VALORDESC, 0)) VALORLIQ,
         P.DTVENC,
         P.DTPAG,
         P.VPAGO,
         P.OBSTITULO,
         A.CLIENTE,
         A.VALOR_CREDITO,
         A.DTLANC_CRED , P.ROWID
    FROM PCPREST P
   INNER JOIN PCNFSAID S ON P.NUMTRANSVENDA = S.NUMTRANSVENDA
    LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
    LEFT JOIN PCPEDC W ON S.NUMPED = W.NUMPED
    LEFT JOIN CREDITOS_ABERTOS A ON S.NUMTRANSVENDA = A.NUMTRANSVENDA
   WHERE (P.CODCLI = 593053 OR P.CODCOB IN ('IFOD') OR P.CODUSUR IN (138,139,140,141,142)) 
     --AND P.DTVENC < TRUNC(SYSDATE) - 1
     AND P.DTPAG IS NULL
   ORDER BY P.DTVENC, P.DUPLIC, TO_NUMBER(P.PREST);

