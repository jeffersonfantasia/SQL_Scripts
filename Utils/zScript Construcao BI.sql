/*CORRE��O DAS CONTAS */
/*BUSCAR O FORNECEDOR NA PCNFENT*/
SELECT ROWID,
       E.CODCONT,
       E.CODFILIAL,
       E.CODFILIALNF,
       E.CODFORNEC,
       E.CODFORNECNF,
       E.*
  FROM PCNFENT E
 WHERE NUMTRANSENT = 287319;
/
/*CONSULTAR NA PCLANC*/
SELECT L.ROWID,
       L.DTCOMPETENCIA,
       L.*
  FROM PCLANC L
  LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
 WHERE L.NUMNOTA = 9424
   /*AND L.CODFORNEC = 9284*/
   AND L.VALOR > 0
   AND L.DTESTORNOBAIXA IS NULL;
/

/*CONTA--*/
SELECT ROWID,
       C.CONTACONTABIL,
       C.*
  FROM PCCONTA C
 WHERE C.GRUPOCONTA = 660
       -- C.CONTACONTABIL = 775
   AND TIPO <> 'I'
 ORDER BY C.CODCONTA;
/

/*BANCO*/
SELECT ROWID,
       B.CODCONTABIL,
       B.CODFILIAL,
       B.CODBACEN,
       B.*
  FROM PCBANCO B
 ORDER BY B.CODBANCO;
/

/*VENDEDORES*/
SELECT ROWID,
       U.USURDIRFV,
       U.*
  FROM PCUSUARI U
 ORDER BY CODUSUR;
/
SELECT U.*
  FROM PCUSUARI U
 WHERE U.CODSUPERVISOR IN (
    12
)
 ORDER BY CODUSUR;
/

/*CLIENTE*/
SELECT ROWID,
       C.CODCLI,
       C.CLIENTE,
       C.CODCONTAB
  FROM PCCLIENT C
 WHERE EXISTS (
    SELECT B.CODCLICC
      FROM PCCOB B
     WHERE B.CODCLICC = C.CODCLI
);
/

/*codcontab B2W � 10385*/
SELECT ROWID,
       C.CODCONTAB,
       C.DTULTALTER,
       C.CODFUNCULTALTER,
       C.*
  FROM PCCLIENT C
 WHERE CODCLI IN (
    25053, 25037
);
/
SELECT T.CODCLIPRINC,
       T.*
  FROM PCCLIENT T
 WHERE CODREDE = 249;
/
SELECT T.CODCLIPRINC,
       T.CODUSUR1,
       T.*
  FROM PCCLIENT T
 WHERE CLIENTE LIKE '%EZUN%';
/
SELECT T.DTEXCLUSAO,
       T.CODCLIPRINC,
       T.CODREDE,
       T.*
  FROM PCCLIENT T
 WHERE T.CODCLI = 277603;
/

/*COBRAN�A*/
SELECT C.CODCLICC,
       C.*
  FROM PCCOB C
 WHERE CODCOB IN (
    'CABW', 'BKPG', 'CARP'
);
SELECT C.CODCLICC,
       C.*
  FROM PCCOB C
 WHERE C.CODCLICC IS NOT NULL
 ORDER BY CODCOB;
/

/*A RECEBER*/
SELECT ROWID,
       T.DTESTORNO,
       T.VALORESTORNO,
       T.*
  FROM PCPREST T
 WHERE T.NUMTRANS IN (
    188023
);
/
SELECT T.NUMTRANS,
       T.DTESTORNO,
       T.VALORESTORNO,
       T.*
  FROM PCPREST T
 WHERE (T.DUPLIC = 56448
   AND CODFILIAL = 2)
    OR T.NUMTRANS = 178728
 ORDER BY TO_NUMBER (T.PREST);
/
SELECT T.NUMTRANS,
       T.DTESTORNO,
       T.VALORESTORNO,
       T.*
  FROM PCPREST T
 WHERE T.DUPLIC = 58038
   AND CODFILIAL = 2
 ORDER BY TO_NUMBER (T.PREST);
/
SELECT T.NUMTRANS,
       T.DTESTORNO,
       T.VALORESTORNO,
       T.*
  FROM PCPREST T
 WHERE T.CODCLI = 275655
   /*AND CODFILIAL = 2*/
 ORDER BY TO_NUMBER (T.PREST);
/

/*FORNECEDOR*/
SELECT ROWID,
       F.CGC,
       F.*
  FROM PCFORNEC F
 WHERE CODFORNEC = 9286;
/
SELECT F.CGC,
       F.*
  FROM PCFORNEC F
 WHERE CODFORNECPRINC = 2;
/
SELECT *
  FROM PCFORNEC
 WHERE CGC = '33.041.260/0652-90';
/
SELECT CODFORNEC,
       FORNECEDOR,
       CGC,
       ESTADO
  FROM PCFORNEC F
 WHERE CODFORNEC IN (
    9193, 9804
)
 ORDER BY FORNECEDOR;
/
SELECT *
  FROM PCFORNEC F
 WHERE FORNECEDOR LIKE '%CARREFOUR%';
/
SELECT *
  FROM PCFORNEC F
 WHERE FORNECEDOR LIKE '%BRASPRESS%';
/
SELECT CODFORNECPRINC,
       F.*
  FROM PCFORNEC F
 WHERE CODFORNEC IN (
    9720
);
/
SELECT ROWID, F.OBS2, F.*
  FROM PCFORNEC F
 WHERE 
       OBS2 = 'GOV'
       --OR CODFORNEC IN (1,7543,9505,9954,8598)
       ;
/

/*CONTA CONTABIL*/
SELECT COUNT (CODFORNEC),
       CODCONTAB
  FROM BROKERCONTABIL
 WHERE CODFILIAL = 1
 GROUP BY CODCONTAB
HAVING COUNT (CODFORNEC) > 1;
/

/*9185*/
SELECT *
  FROM BROKERCONTABIL
 WHERE CODFORNEC IN (
    9734
);
/
SELECT B.ROWID,
       B.CODFILIAL,
       B.CODFORNEC,
       F.FORNECEDOR,
       F.CGC,
       F.ESTADO,
       B.CODCONTAB
  FROM BROKERCONTABIL B
  LEFT JOIN PCFORNEC F ON B.CODFORNEC = F.CODFORNEC
 WHERE B.CODCONTAB IN (
    10204

)
 ORDER BY B.CODFORNEC,
          B.CODFILIAL;
/
 
 /*UPDATE BROKERCONTABIL SET CODCONTAB = */

/*LAN�AMENTOS*/
SELECT ROWID,
       L.*
  FROM PCLANC L
 WHERE CODCONTA = 820101
 ORDER BY DTPAGTO DESC;
/
SELECT ROWID,
       L.DTCOMPETENCIA,
       L.NUMTRANS,
       L.*
  FROM PCLANC L
 WHERE NUMNOTA IN (
    32
)
 ORDER BY DTLANC;
/
SELECT ROWID,
       L.TIPOPARCEIRO,
       L.CODFORNEC,
       L.*
  FROM PCLANC L
 WHERE VALOR = 8215.01
   AND CODFORNEC = 9745;
/
SELECT ROWID,
       L.TIPOPARCEIRO,
       L.DTCOMPETENCIA,
       L.DTEMISSAO,
       L.*
  FROM PCLANC L
 WHERE RECNUM = 1499634;
/
SELECT ROWID,
       L.TIPOPARCEIRO,
       L.DTCOMPETENCIA,
       L.DTEMISSAO,
       L.*
  FROM PCLANC L
 WHERE NUMTRANS = 199702;
/

SELECT ROWID,
       L.HISTORICO,
       L.DTCOMPENSACAO,
       L.*
  FROM PCMOVCR L
 WHERE NUMTRANS = 199787;
/
SELECT L.*
  FROM PCLANC L
 WHERE L.CODROTINABAIXA = 631
   AND L.DTLANC = TRUNC (SYSDATE) - 1;
/
SELECT L.*
  FROM PCLANC L
 WHERE CODCONTA = 100025
 ORDER BY DTPAGTO DESC;
/
SELECT ROWID,
       L.*
  FROM PCLANC L
 WHERE CODCONTA = 620103
 ORDER BY DTPAGTO DESC;
/
SELECT ROWID,
       L.*
  FROM PCLANC L
 WHERE HISTORICO = 'PROCESSO 0003410-42.2020.8.19.0202';

/*MUDAR PARA 9185 PACER*/
SELECT ROWID,
       L.CODFORNEC,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 9712
   AND DTEMISSAO >= '01-JUN-2020';
/
   
/*MUDAR PARA 9734 BRASPRESS*/
SELECT ROWID,
       L.CODFORNEC,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 349
   AND DTEMISSAO >= '01-JUN-2020';
/
SELECT ROWID,
       L.DTPAGTO,
       L.*
  FROM PCLANC L
 WHERE L.NUMTRANS IN (
    188023
);
/
SELECT ROWID,
       L.CODFORNECPRINC,
       L.CODFORNEC,
       L.CODFILIAL,
       L.RECNUMPRINC,
       L.ADIANTAMENTO,
       L.*
  FROM PCLANC L
 WHERE L.RECNUM IN (
    1394820
);
/
SELECT ROWID,
       L.*
  FROM PCLANCADIANTFORNEC L
 WHERE L.RECNUMADIANTAMENTO IN (
    1394820
);
/

/*MOVIMENTA��O BANCOS E CAIXA*/
SELECT *
  FROM PCMOVCR
 WHERE NUMTRANS IN (
    176662
);
/
SELECT ROWID,
       M.DTCOMPENSACAO,
       M.*
  FROM PCMOVCR M
 WHERE NUMTRANS IN (
    166512
);
/


/*NOTAS DE VENDA*/
SELECT S.CODCOB,
       S.*
  FROM PCNFSAID S
 WHERE CODFILIAL = 7
   AND NUMNOTA IN (
    155142
);
/

/*NOTAS DE ENTRADA*/
SELECT *
  FROM PCNFENT
 WHERE NUMTRANSENT = 253542;
/
SELECT *
  FROM PCNFENT
 WHERE NUMNOTA = 32;
/

/*PEDIDOS DE COMPRA  */
SELECT ROWID,
       CODCOMPRADOR,
       P.*
  FROM PCPEDIDO P
 WHERE NUMPED = 8815;
/

/*PLANOS DE PAGAMENTO*/
SELECT *
  FROM PCPLPAG
 ORDER BY CODPLPAG;
/

/*PEDIDOS DE VENDA*/
SELECT ROWID,
       CONTAORDEM,
       P.*
  FROM PCPEDC P
 WHERE CONDVENDA = 7
   AND POSICAO NOT IN (
    'F', 'C'
)
   AND CONTAORDEM IS NULL;
/
SELECT NUMPEDRCA,
       POSICAO,
       P.*
  FROM PCPEDC P
 WHERE NUMPEDRCA = 31003764;
/
SELECT CODPLPAG,
       NUMPEDRCA,
       NUMPEDCLI,
       POSICAO,
       P.VLATEND,
       P.*
  FROM PCPEDC P
 WHERE NUMPED IN (
    31003864
);
/
SELECT P.CODAUXILIAR,
       I.*
  FROM PCPEDI I
  LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
 WHERE NUMPED = 18022674;
/
SELECT ROWID,
       P.GERACP,
       P.CONDVENDA,
       P.*
  FROM PCPEDC P
 WHERE NUMPED = 14005752;
/
SELECT ROWID,
       P.GERACP,
       P.NUMNOTA,
       P.*
  FROM PCPEDC P
 WHERE CODUSUR = 27
   AND CONDVENDA = 10
 ORDER BY DATA DESC;
/

/*CREDITO CLIENTE*/
SELECT *
  FROM PCCRECLI C
 WHERE C.NUMTRANS IN (
    152422, 152425
);
/
SELECT ROWID,
       C.*
  FROM PCCRECLI C
 WHERE C.CODCLI IN (
    602
);
/
SELECT *
  FROM PCREDECLIENTE
 WHERE CODREDE = 704;
/

/*CADASTRO DE PRODUTOS*/
SELECT ROWID,
       P.CODNCMEX,
       P.CODAUXILIAR,
       P.OBS,
       P.OBS2,
       P.REVENDA,
       P.TIPOMERC,
       P.CODFORNEC,
       P.*
  FROM PCPRODUT P
 WHERE CODPROD = 804085;
/
SELECT P.CODEPTO,
       P.OBS2,
       P.DTEXCLUSAO,
       P.*
  FROM PCPRODUT P
 WHERE CODPROD IN (
    800323
);
/
 
/*GERENTE*/
SELECT *
  FROM PCGERENTE;
/

/*KIT DE PRODUTOS-- */
SELECT DISTINCT (F.CODPRODACAB),
                P.DESCRICAO AS PRODUTO_KIT
  FROM PCFORMPROD F
  LEFT JOIN PCPRODUT P ON F.CODPRODACAB = P.CODPROD
 WHERE P.TIPOMERC IN (
    'CB', 'KT'
)
   AND P.CODNCMEX IS NULL
   AND P.DTEXCLUSAO IS NULL
 ORDER BY F.CODPRODACAB;
/

/*TRIBUTACAO SAIDA--*/
SELECT *
  FROM PCTABTRIB;
/


/*FIGURAS TRIBUTARIAS DE SAIDA--*/
SELECT CODST,
       MENSAGEM
  FROM PCTRIBUT
 WHERE SITTRIBUT = '10'
 ORDER BY CODST;