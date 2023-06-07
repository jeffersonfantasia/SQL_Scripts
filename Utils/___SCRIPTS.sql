----BROKERCONTABIL
SELECT B.ROWID, B.* FROM BROKERCONTABIL B WHERE B.CODCONTAB IN (1445,1207) ;
SELECT B.ROWID, B.* FROM BROKERCONTABIL B WHERE B.CODCONTAB IN (9512) ;
SELECT * FROM BROKERCONTABIL B WHERE B.CODFORNEC = 10168;


----PCBANCO
SELECT ROWID,B.CODBACEN, B.CODFILIAL, B.* FROM PCBANCO B ORDER BY B.CODBANCO;


----PCCLIENT
SELECT ROWID, C.CALCULAST, C.CONTRIBUINTE, C.CONSUMIDORFINAL, C.IEENT, C.CGCENT, C.CODCLIPRINC, C.* FROM PCCLIENT C WHERE C.CODCLI IN (132155, 483594);
SELECT C.CODREDE, C.* FROM PCCLIENT C WHERE C.CLIENTE LIKE '%ALINE ARIGA%';
SELECT C.CODCLI, C.CLIENTE, C.CLIENTPROTESTO FROM PCCLIENT C WHERE C.CODREDE = 911;
SELECT C.* FROM PCCLIENT C WHERE C.CGCENT = '36236198845';
SELECT C.TIPOTRATAMENTODESCFIN, C.* FROM PCCLIENT C WHERE C.PERDESCFIN > 0;


----PCCRECLI
SELECT ROWID, C.* FROM PCCRECLI C WHERE DTDESCONTO >= TRUNC(SYSDATE) - 20 AND CODFILIAL = '7' AND CODROTINA = 619 ORDER BY CODCLI;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMCRED IN (746176) ORDER BY C.NUMCRED;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMTRANSENTDEVCLI IN (561844) ORDER BY C.NUMCRED;
SELECT ROWID, C.CODIGO, C.* FROM PCCRECLI C WHERE C.CODCLI IN ( 460549, 473249, 476203)  ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMNOTADESC = 14418 ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.CODIGO IN ( 48138, 48284, 48340, 48342) ORDER BY C.CODIGO;

----PCCOB
SELECT B.CODCLICC, B.PERCTXADMINCC, B.* FROM PCCOB B WHERE B.CODCLICC IS NOT NULL ORDER BY CODCOB;


----PCCONTA
SELECT C.CONTACONTABIL, C.* FROM PCCONTA C WHERE C.TIPO <> 'I' AND C.GRUPOCONTA IN ( 210, 530, 535, 540, 545, 550, 555, 560, 565, 610, 620, 650, 660, 820) ORDER BY C.GRUPOCONTA, CODCONTA;


----PCFORNEC
SELECT * FROM PCFORNEC F WHERE F.FORNECEDOR LIKE '%RI HAPPY%'; --58.731.662/0012-74
SELECT ROWID, F. * FROM PCFORNEC F WHERE F.CODFORNEC = 7093;

----PCLANC
SELECT ROWID, L. * FROM PCLANC L WHERE L.CODFILIAL IN ('7', '9', '10' ) AND L.CODCONTA IN ( 420102, 670103) AND HISTORICO LIKE '%FRETE%' AND NUMBANCO IN (36,69,74) ORDER BY DTLANC DESC, CODFILIAL;
SELECT ROWID, L.DTCOMPETENCIA, L. * FROM PCLANC L WHERE L.RECNUM IN (2418983);
SELECT ROWID, L.* FROM PCLANC L WHERE L.NUMTRANS IN (309208);
SELECT ROWID, L.DTCOMPETENCIA, L.DTESTORNOBAIXA, L.NUMTRANS, L.* FROM PCLANC L WHERE L.NUMNOTA IN (3763014) AND L.CODFORNEC = 9199;
SELECT ROWID, L.DTCOMPETENCIA, L.DTESTORNOBAIXA, L.NUMTRANS, L.NUMBANCO, L.* FROM PCLANC L WHERE L.NUMNOTA IN (185) AND L.CODFILIAL = '9';
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.CODFORNEC IN (7170) AND L.CODCONTA = 530104 ORDER BY L.DTCOMPETENCIA DESC;
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.VALOR = 412.50 ORDER BY L.DTLANC DESC;


----PCMOVCR
SELECT ROWID, M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.NUMTRANS IN (309687, 309688);
SELECT M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.CODBANCO = 69 AND M.DATA >= TRUNC(SYSDATE) - 45 ORDER BY M.DTCOMPENSACAO DESC;


----PCMOV
SELECT M.NUMTRANSENT, M.DESCRICAO, M.* FROM PCMOV M WHERE M.NUMTRANSDEV IN (11637536);
SELECT ROWID, M.NUMTRANSENT, M.NUMTRANSVENDA, M.DESCRICAO, M.CODFISCAL, M.CODFILIALRETIRA, M.* FROM PCMOV M WHERE M.CODPROD IN (814764) AND ((CODFILIAL = '6' AND CODOPER = 'SD') OR (CODFILIAL = '2' AND CODOPER = 'ED'));
SELECT M.NUMTRANSENT, M.NUMTRANSVENDA, M.NUMTRANSDEV, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMNOTA IN (351460) AND CODFILIAL = '7';
SELECT M.DTCANCEL, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMTRANSVENDA = 11649080;
SELECT M.ROWID, M.DTCANCEL, M.NUMTRANSDEV, M.DESCRICAO, M.CODFISCAL, M.PERCICMRED, M.* FROM PCMOV M WHERE M.NUMTRANSENT IN (561601);
SELECT M.NUMTRANSENT, M.* FROM PCMOV M WHERE M.CODOPER= 'ER' ORDER BY DTMOV DESC;


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 14010155;


----PCNFENT
SELECT ROWID, E.VLFRETE, E.FORNECEDOR, E.CHAVENFE, E.TIPODESCARGA, E.* FROM PCNFENT E WHERE E.NUMTRANSENT IN (550995, 559291);
SELECT E.NUMTRANSENT, E.FORNECEDOR, E.* FROM PCNFENT E WHERE E.NUMNOTA IN (3763014) ;
SELECT E.DTCANCEL, E.* FROM PCNFENT E WHERE E.DTENT BETWEEN '01/01/2023' AND '31/01/2023' AND E.CODFILIAL = '9' AND E.ESPECIE = 'CT';
SELECT E.DTCANCEL, E.NUMTRANSENT, E.* FROM PCNFENT E WHERE E.CODFORNEC = 474395 AND E.TIPODESCARGA = '6';


----PCNFSAID
SELECT S.VLFRETE, S.NUMTRANSVENDA, S.CLIENTE, S.CHAVENFE, S.DTCANCEL, S.* FROM PCNFSAID S WHERE S.NUMTRANSVENDA IN (11668482, 11668393); 
SELECT S.NUMTRANSVENDA, S.NUMPED, S.* FROM PCNFSAID S WHERE S.CODCLI = 460938 ORDER BY DTSAIDA DESC;
SELECT S.NUMTRANSVENDA, S.CLIENTE, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '2' AND S.NUMNOTA IN (74179, 74149);
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '2' AND S.CODCOB LIKE 'F%';
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '8' AND S.DTSAIDA = TRUNC(SYSDATE) -2 AND S.VLTOTAL = 56.99;


----PCPEDC
SELECT C.NUMPED, C.NUMPEDCLI, C.NUMNOTA, C.ORIGEMPED, C.CODEMITENTE, C.NUMTRANSVENDA,  C.* FROM PCPEDC C WHERE C.NUMTRANSVENDA IN (11668482, 11668393 );
SELECT C.GERACP, C.NUMNOTA, C.* FROM PCPEDC C WHERE C.CONDVENDA = 10 AND C.GERACP = 'N' ORDER BY C.DATA DESC;
SELECT ROWID, C.CODCOB,C.NUMTRANSVENDA,  C.NUMPEDCLI, C.* FROM PCPEDC C WHERE C.CODFILIAL = '7' AND C.NUMNOTA IN (348663  ,349703 );
SELECT ROWID, C.NUMTRANSVENDA, C.NUMPEDCLI, C.* FROM PCPEDC C WHERE C.NUMPEDCLI = 'v25864985rihp' ;
SELECT ROWID, C.GERACP,  C.CONDVENDA, C.POSICAO, C.NUMTRANSVENDA, C.NUMNOTA, C.NUMPEDCLI, C.CODCOB, C.* FROM PCPEDC C WHERE C.NUMPED IN ( 14010170) OR CONDVENDA = 9 ORDER BY DATA DESC;


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 14010155;


----PCPEDCTEMP
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDCLI = '572183';
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDWEB IN ( 572183, 572240);


----PCPREST
SELECT ROWID, P.CODBANCO, P. * FROM PCPREST P WHERE P.NUMTRANS IN (306575); 
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.CODCLI = 18258 AND P.CODFILIAL = '2' ORDER BY P.NUMTRANSVENDA, P.PREST;
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.CODFILIAL = '1' AND P.DUPLIC IN ( 104479, 104472); --104479/ 104472
SELECT P.ROWID, P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NUMTRANSVENDA IN (11422672,11423273) ORDER BY P.NUMTRANSVENDA, TO_NUMBER(PREST);
SELECT P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NSUHOST = '4001';
SELECT P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NUMRESUMO = '050829273';
SELECT ROWID, P.NSUHOST, P.NSUTEF, P.* FROM PCPREST P WHERE P.DTEMISSAO = TRUNC(SYSDATE) - 1 AND P.CODFILIAL = '1' ORDER BY P.NUMTRANSVENDA, P.PREST;


----PCPRODUT
SELECT * FROM PCPRODUT P WHERE P.CODFAB ='1002003300008';
SELECT * FROM PCPRODUT P WHERE P.DESCRICAO LIKE 'OCULOS DE SOL%';
SELECT ROWID, P.* FROM PCPRODUT P WHERE P.CODPRODMASTER = 818240;
SELECT P.CODNCMEX, P.CODFAB, P.CODFORNEC, P. * FROM PCPRODUT P WHERE P.CODPROD IN (795488);


----PCAPLICVERBAI
SELECT * FROM PCAPLICVERBAI V WHERE V.CODPROD = 815437 AND V.CODFILIAL = '2';


----JCPAGAMENTOSML
SELECT * FROM JCPAGAMENTOSML M WHERE M.SHIPPING_ID_ML = &NUMPED OR M.PAYMENT_ID_ML = &NUMPED OR M.NUMPEDCLI = &NUMPED; --41984763121


----PCUSUARI
SELECT ROWID, U.USURDIRFV, U.* FROM PCUSUARI U ORDER BY U.CODUSUR;


----PCREGIAO
SELECT * FROM PCREGIAO R;


----PCTABPR
SELECT NUMREGIAO, CODPROD, MARGEM, PTABELA, PVENDA FROM PCTABPR P WHERE P.CODPROD IN (809257, 816140, 812469) AND P.NUMREGIAO IN (1,3, 4) ORDER BY P.CODPROD;
