----BROKERCONTABIL
SELECT B.ROWID, B.* FROM BROKERCONTABIL B WHERE B.CODCONTAB = 65932;
SELECT * FROM BROKERCONTABIL B WHERE B.CODFORNEC = 10068;


----PCBANCO
SELECT ROWID,B.CODBACEN, B.CODFILIAL, B.* FROM PCBANCO B ORDER BY B.CODBANCO;


----PCCLIENT
SELECT ROWID, C.CALCULAST, C.CONTRIBUINTE, C.CONSUMIDORFINAL, C.IEENT, C.* FROM PCCLIENT C WHERE C.CODCLI IN (476088);
SELECT * FROM PCCLIENT C WHERE C.CLIENTE LIKE '%ASTRA%';
SELECT C.CODCLI, C.CLIENTE, C.CLIENTPROTESTO FROM PCCLIENT C WHERE C.CODREDE = 471;
SELECT C.* FROM PCCLIENT C WHERE C.CGCENT = '36236198845';
SELECT C.TIPOTRATAMENTODESCFIN, C.* FROM PCCLIENT C WHERE C.PERDESCFIN > 0;


----PCCRECLI
SELECT ROWID, C.* FROM PCCRECLI C WHERE DTDESCONTO >= TRUNC(SYSDATE) - 20 AND CODFILIAL = '7' AND CODROTINA = 619 ORDER BY CODCLI;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMCRED IN (743211) ORDER BY C.NUMCRED;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMTRANSENTDEVCLI IN (553709) ORDER BY C.NUMCRED;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.CODCLI = 414359 OR NUMNOTA = 906 ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMNOTADESC = 14418 ORDER BY C.CODIGO;


----PCCONTA
SELECT C.CONTACONTABIL, C.* FROM PCCONTA C WHERE C.TIPO <> 'I' AND C.GRUPOCONTA IN ( 530, 535, 540, 545, 550, 555, 560, 565, 660, 820) ORDER BY C.GRUPOCONTA;


----PCLANC
SELECT ROWID, L. * FROM PCLANC L WHERE L.CODFILIAL IN ('7', '9', '10' ) AND L.CODCONTA IN ( 420102, 670103) AND HISTORICO LIKE '%FRETE%' AND NUMBANCO IN (36,69,74) ORDER BY DTLANC DESC, CODFILIAL;
SELECT ROWID, L. * FROM PCLANC L WHERE L.RECNUM IN (2245007);
SELECT ROWID, L.* FROM PCLANC L WHERE L.NUMTRANS IN (306484);


----PCMOVCR
SELECT ROWID, M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.NUMTRANS IN (306566);
SELECT M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.CODBANCO = 69 AND M.DATA >= TRUNC(SYSDATE) - 45 ORDER BY M.DTCOMPENSACAO DESC;


----PCMOV
SELECT M.NUMTRANSENT, M.DESCRICAO, M.* FROM PCMOV M WHERE M.NUMTRANSDEV IN (11580042);
SELECT ROWID, M.NUMTRANSENT, M.NUMTRANSVENDA, M.DESCRICAO, M.CODFISCAL, M.CODFILIALRETIRA, M.* FROM PCMOV M WHERE M.CODPROD IN (814764) AND ((CODFILIAL = '6' AND CODOPER = 'SD') OR (CODFILIAL = '2' AND CODOPER = 'ED'));
SELECT M.NUMTRANSENT, M.NUMTRANSVENDA, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMNOTA IN (317491) AND CODFILIAL = '7';
SELECT M.DTCANCEL, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMTRANSVENDA = 10027459;
SELECT M.DTCANCEL, M.NUMTRANSDEV, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMTRANSENT IN (554338);


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 14010155;


----PCNFENT
SELECT E.VLFRETE, E.FORNECEDOR, E.CHAVENFE, E.* FROM PCNFENT E WHERE E.NUMTRANSENT IN (553709);
SELECT E.NUMTRANSENT, E.FORNECEDOR, E.* FROM PCNFENT E WHERE E.NUMNOTA IN (35101) ;
SELECT E.DTCANCEL, E.* FROM PCNFENT E WHERE E.DTENT BETWEEN '01/01/2023' AND '31/01/2023' AND E.CODFILIAL = '9' AND E.ESPECIE = 'CT';


----PCNFSAID
SELECT S.VLFRETE, S.NUMTRANSVENDA, S.CLIENTE, S.CHAVENFE, S.DTCANCEL, S.* FROM PCNFSAID S WHERE S.NUMTRANSVENDA = 10027459; 
SELECT S.NUMTRANSVENDA, S.NUMPED, S.* FROM PCNFSAID S WHERE S.CODCLI = 414359 ORDER BY DTSAIDA DESC;
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '7' AND S.NUMNOTA IN (76151);
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '2' AND S.CODCOB LIKE 'F%';
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '8' AND S.DTSAIDA = TRUNC(SYSDATE) -2 AND S.VLTOTAL = 56.99;


----PCPEDC
SELECT C.NUMPED, C.NUMPEDCLI, C.NUMNOTA, C.ORIGEMPED, C.CODEMITENTE, C.NUMTRANSVENDA,  C.* FROM PCPEDC C WHERE C.NUMTRANSVENDA IN (11416457,11413021);
SELECT C.GERACP, C.NUMNOTA, C.* FROM PCPEDC C WHERE C.CONDVENDA = 10 AND C.GERACP = 'N' ORDER BY C.DATA DESC;
SELECT C.CODCOB, C.* FROM PCPEDC C WHERE C.CODFILIAL = '2' AND C.NUMNOTA IN (77116);
SELECT ROWID, C.NUMTRANSVENDA, C.NUMPEDCLI, C.* FROM PCPEDC C WHERE C.NUMPEDCLI = '701-2756905-0653820' ;
SELECT ROWID, C.NUMTRANSVENDA, C.NUMNOTA, C.NUMPEDCLI, C.CODCOB, C.* FROM PCPEDC C WHERE C.NUMPED IN ( 37082266);


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 14010155;


----PCPEDCTEMP
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDCLI = '572183';
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDWEB IN ( 572183, 572240);


----PCPREST
SELECT ROWID, P.CODBANCO, P. * FROM PCPREST P WHERE P.NUMTRANS IN (306575); 
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.CODCLI = 358595 AND P.CODFILIAL = '9';
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.CODFILIAL = '1' AND P.DUPLIC IN ( 104479, 104472); --104479/ 104472
SELECT P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE  P.NUMTRANSVENDA IN (11413021,11420013,11416457);


----PCPRODUT
SELECT * FROM PCPRODUT P WHERE P.CODFAB ='1002003300008';
SELECT * FROM PCPRODUT P WHERE P.DESCRICAO LIKE 'OCULOS DE SOL%';
SELECT P.CODFAB, P. * FROM PCPRODUT P WHERE P.CODPROD IN (808791,811375,808793,811376,811377);


----PCAPLICVERBAI
SELECT * FROM PCAPLICVERBAI V WHERE V.CODPROD = 815437 AND V.CODFILIAL = '2';


----JCPAGAMENTOSML
SELECT * FROM JCPAGAMENTOSML M WHERE M.SHIPPING_ID_ML = &NUMPED OR M.PAYMENT_ID_ML = &NUMPED OR M.NUMPEDCLI = &NUMPED; --41984763121


----PCUSUARI
SELECT U.USURDIRFV, U.* FROM PCUSUARI U ORDER BY U.CODUSUR;


----PCREGIAO
SELECT * FROM PCREGIAO R;
