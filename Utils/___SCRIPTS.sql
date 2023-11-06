----BROKERCONTABIL
SELECT B.ROWID, B.* FROM BROKERCONTABIL B WHERE B.CODCONTAB IN (81410, 81461) ORDER BY CODCONTAB, CODFORNEC ;
SELECT B.ROWID, B.* FROM BROKERCONTABIL B WHERE B.CODFORNEC IN( 81382 ) ;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 1 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 5 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 6 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 9 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 10 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;


----PCAPLICVERBAI
SELECT * FROM PCAPLICVERBAI V WHERE V.CODPROD = 815437 AND V.CODFILIAL = '2';


----PCBANCO
SELECT ROWID,B.CODBACEN, B.CODFILIAL, B.* FROM PCBANCO B ORDER BY B.CODBANCO;
SELECT ROWID,B.CODBACEN, B.CODFILIAL, B.* FROM PCBANCO B WHERE CODBACEN IS NOT NULL ORDER BY B.CODBANCO;


----PCBONUSI
SELECT * FROM PCBONUSI I WHERE I.NUMBONUS = 15581;


----PCCLIENT
SELECT ROWID, C.CALCULAST, C.CONTRIBUINTE, C.CONSUMIDORFINAL, C.IEENT, C.CGCENT, C.CODCLIPRINC, C.* FROM PCCLIENT C WHERE C.CODCLI IN (1);
SELECT C.CODREDE, C.* FROM PCCLIENT C WHERE C.CLIENTE LIKE '%CLEONICE PEREIRA%';
SELECT C.CODCLI, C.CLIENTE, C.CLIENTPROTESTO FROM PCCLIENT C WHERE C.CODREDE = 911;
SELECT C.* FROM PCCLIENT C WHERE C.CGCENT = '42448336000161';
SELECT C.TIPOTRATAMENTODESCFIN, C.* FROM PCCLIENT C WHERE C.PERDESCFIN > 0;


----PCCRECLI
SELECT ROWID, C.* FROM PCCRECLI C WHERE DTDESCONTO >= TRUNC(SYSDATE) - 20 AND CODFILIAL = '7' AND CODROTINA = 619 ORDER BY CODCLI;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMCRED IN (746176) ORDER BY C.NUMCRED;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMTRANSENTDEVCLI IN (561844) ORDER BY C.NUMCRED;
SELECT ROWID, C.CODIGO, C.* FROM PCCRECLI C WHERE C.CODCLI IN ( 121579 )  ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMNOTADESC = 14418 ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.CODIGO IN ( 48858 ) ORDER BY C.CODIGO;

----PCCOB
SELECT B.CODCLICC, B.PERCTXADMINCC, B.* FROM PCCOB B WHERE B.CODCLICC IS NOT NULL ORDER BY CODCOB;
SELECT ROWID, B.CODCLICC, B.PERCTXADMINCC, B.EXPORTARECF, B.* FROM PCCOB B WHERE B.EXPORTARECF = 'S' ORDER BY CODCOB;


----PCCONTA
SELECT C.CONTACONTABIL, C.* FROM PCCONTA C WHERE C.TIPO <> 'I' AND C.GRUPOCONTA IN ( 210, 300, 530, 535, 540, 545, 550, 555, 560, 565, 610, 620, 650, 660, 820) ORDER BY C.GRUPOCONTA, CODCONTA;
SELECT C.CONTACONTABIL, C.* FROM PCCONTA C WHERE C.TIPO <> 'I' AND C.GRUPOCONTA IN ( 560 ) ORDER BY C.GRUPOCONTA, CODCONTA;


----PCCENTROCUSTO
SELECT * FROM PCCENTROCUSTO ORDER BY CODIGOCENTROCUSTO;


----PCEST
SELECT E.CODPROD, E.QTEST, E.QTESTGER, E.* FROM PCEST E WHERE E.CODFILIAL = '2' AND E.CODPROD = 162887;


----PCFILIAL
SELECT * FROM PCFILIAL F ORDER BY TO_NUMBER(F.CODIGO);

----PCFORNEC
SELECT F.ROWID, F.OBS2, F.REVENDA, F.* FROM PCFORNEC F WHERE F.FORNECEDOR LIKE '%JAMEF%'; 
SELECT F.ROWID, F.OBS2, F.* FROM PCFORNEC F WHERE REGEXP_REPLACE(F.CGC, '([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{4})', '\1.\2.\3/\4-') = '41.384.562/0001-63'; 
SELECT ROWID, F.OBS2, CODFORNECPRINC, F. * FROM PCFORNEC F WHERE F.CODFORNEC IN (10351);
SELECT ROWID, F.REVENDA, F.SIMPLESNACIONAL, F.EMITENFE, F. * FROM PCFORNEC F WHERE F.CODFORNEC IN (10301, 10284);
SELECT ROWID, F.OBS2, F. * FROM PCFORNEC F WHERE F.CODFORNEC IN (9177) OR F.OBS2 = 'GOV' ;


----PCFORNECFILIAL
SELECT F.DEDUZIRICMSBASEPISCOFINS, F. * FROM PCFORNECFILIAL F JOIN PCFORNEC C ON F.CODFORNEC = C.CODFORNEC WHERE F.CODFILIAL IN ('1','2','3','4','7','8','11','12','13') AND C.REVENDA = 'T';
UPDATE PCFORNECFILIAL SET DEDUZIRICMSBASEPISCOFINS = NULL WHERE CODFILIAL IN ('1','2','3','4','7','8','11','12','13') AND CODFORNEC IN (SELECT CODFORNEC FROM PCFORNEC WHERE REVENDA = 'T');


----PCGERENTE
SELECT * FROM PCGERENTE ORDER BY CODGERENTE;


----PCHISTEST
SELECT * FROM PCHISTEST H WHERE H.CODFILIAL IN ('2', '11') AND H.CODPROD IN (/*162887*/ 3465) AND H.DATA = TO_DATE ('31/07/2023', 'DD/MM/YYYY') ;


----PCLANC
SELECT ROWID, L.DTCOMPETENCIA, L. * FROM PCLANC L WHERE L.CODFILIAL IN ('7', '9', '10' ) AND L.CODCONTA IN ( 420102, 670103) AND HISTORICO LIKE '%FRETE%' AND NUMBANCO IN (36,69,74) ORDER BY DTLANC DESC, CODFILIAL;
SELECT ROWID, L.DTCOMPETENCIA, L.RECNUMPRINC, L. * FROM PCLANC L WHERE L.RECNUM IN (2447907, 2439402);
SELECT ROWID, L.DTCOMPETENCIA, L.FORNECEDOR, L.RECNUMPRINC, L.* FROM PCLANC L WHERE L.RECNUMPRINC IN ( 2447907 ) ORDER BY CODFORNEC, NUMNOTA;
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.NUMTRANS IN ( 317468 ); 
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.NUMBORDERO IN ( 12818 ); 
SELECT ROWID, L.DTCOMPETENCIA, L.DTESTORNOBAIXA, L.NUMTRANS, L.RECNUMPRINC, L.* FROM PCLANC L WHERE L.NUMNOTA IN (3) AND L.CODFORNEC = 10260;
SELECT ROWID, L.* FROM PCLANC L WHERE L.CODFILIAL IN ('8','12', '13') AND L.CODFORNEC = 10260 AND L.DTLANC = TRUNC(SYSDATE) - 0 AND L.CODCONTA = 100003;
SELECT ROWID, L.DTCOMPETENCIA, L.DTESTORNOBAIXA, L.NUMTRANS, L.NUMBANCO, L.* FROM PCLANC L WHERE L.NUMNOTA IN ( 603839312 ) AND L.CODFILIAL = '1'; 
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.CODFORNEC IN ( 10282 ) AND TIPOPARCEIRO = 'F' ORDER BY L.DTPAGTO DESC;
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.NUMBANCO = 1 AND CODCONTA IN (650107) ORDER BY L.DTLANC DESC;
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.HISTORICO LIKE '%CAMERAS%' ORDER BY L.DTLANC DESC;
SELECT ROWID, L.NUMBANCO, L.RECNUM, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.CODCONTA = 300104 ORDER BY DTVENC;


----PCLOGLANCAMENTO
SELECT * FROM PCLANCLOG L WHERE L.RECNUM  = 2575223;


----PCRATEIOCENTROCUSTO
SELECT R.ROWID, R.* FROM PCRATEIOCENTROCUSTO R WHERE R.RECNUM = 2575223;


----PCMARCA
SELECT * FROM PCMARCA M ORDER BY MARCA;


----PCMOV
SELECT M.NUMTRANSENT, M.DESCRICAO, M.* FROM PCMOV M WHERE M.NUMTRANSDEV IN (146779);
SELECT ROWID, M.NUMTRANSENT, M.NUMTRANSVENDA, M.DESCRICAO, M.CODFISCAL, M.CODFILIALRETIRA, M.* FROM PCMOV M WHERE M.CODPROD IN (811963) AND ((CODFILIAL = '6' AND CODOPER = 'SD') OR (CODFILIAL = '2' AND CODOPER = 'ED'));
SELECT M.CODST, M.NUMTRANSITEM, M.NUMTRANSENT, M.NUMTRANSVENDA, M.NUMTRANSDEV, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMNOTA IN (23) AND CODFILIAL = '11';
SELECT M.DTCANCEL, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMTRANSVENDA = 11678287;
SELECT M.ROWID, M.DTCANCEL, M.NUMTRANSDEV, M.DESCRICAO, M.CODFISCAL, M.PERCICMRED, M.* FROM PCMOV M WHERE M.NUMTRANSENT IN (561601);
SELECT M.NUMTRANSENT, M.* FROM PCMOV M WHERE M.CODOPER= 'ET' AND M.STATUS = 'AB' ORDER BY DTMOV DESC;
SELECT ROWID, M.MOVESTOQUECONTABIL, M.NUMTRANSENT, M.NUMTRANSVENDA, M.DESCRICAO, M.CODFISCAL, M.CODFILIALRETIRA, M.DTCANCEL,  M.* FROM PCMOV M WHERE M.CODPROD IN (3465) AND M.CODFILIAL = '11' AND DTMOV BETWEEN '26/07/2023' AND '31/07/2023' ORDER BY M.NUMTRANSITEM;
SELECT * FROM PCMOV M WHERE M.NUMBONUS = 15581;


----PCMOVCOMPLE
SELECT M.VLICMS, M.* FROM PCMOVCOMPLE M WHERE M.NUMTRANSITEM IN ( 3289535, 3289532);


----PCMOVCR
SELECT ROWID, M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.NUMTRANS IN ( 319929, 419807);
SELECT ROWID, M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.CODBANCO = 41 AND M.DATA >= TRUNC(SYSDATE) - 30 ORDER BY M.DTCOMPENSACAO DESC;
SELECT * FROM PCMOVCR M WHERE M.CODCOB = 'D' AND M.DTCOMPENSACAO BETWEEN '01/07/2023' AND '31/07/2023' AND M.CODBANCO = 65 ORDER BY M.DATACOMPLETA;
SELECT * FROM PCMOVCR M WHERE DATA BETWEEN TO_DATE('17/10/2023', 'DD/MM/YYYY') AND  TO_DATE('18/10/2023', 'DD/MM/YYYY') AND CODBANCO = 12;


----PCMOVCRFOR
SELECT ROWID,  M.CODFORNECPRINC, M.* FROM PCMOVCRFOR M WHERE M.NUMVERBA = 6082;
SELECT ROWID,  M.CODFORNECPRINC, M.* FROM PCMOVCRFOR M WHERE M.CODFORNECPRINC = 2 AND M.DTCONCIL >= '31/07/2023' AND M.CODFILIAL = '2';


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 14010155;


----PCNFENT
SELECT ROWID, E.VLFRETE, E.FORNECEDOR, E.CHAVENFE, E.TIPODESCARGA, E.* FROM PCNFENT E WHERE E.NUMTRANSENT IN (642722);
SELECT E.CHAVENFE, E.NUMTRANSENT, E.FORNECEDOR, E.* FROM PCNFENT E WHERE E.NUMNOTA IN (235608) ;
SELECT E.DTCANCEL, e.fornecedor, E.* FROM PCNFENT E WHERE E.DTENT BETWEEN '01/07/2023' AND '31/07/2023' AND E.CODFILIAL = '2' AND E.ESPECIE = 'CT';
SELECT E.DTCANCEL, E.NUMTRANSENT, E.* FROM PCNFENT E WHERE E.CODFORNEC = 474395 AND E.TIPODESCARGA = '6';
SELECT E.DTCANCEL, e.fornecedor, E.* FROM PCNFENT E WHERE E.DTENT BETWEEN '01/07/2023' AND '31/08/2023' AND E.CODFORNEC IN ( 9085, 9557, 9625 );


----PCNFSAID
SELECT S.VLFRETE, S.NUMTRANSVENDA, S.CLIENTE, S.CHAVENFE, S.DTCANCEL, S.* FROM PCNFSAID S WHERE S.NUMTRANSVENDA IN (11839191); 
SELECT S.NUMTRANSVENDA, S.NUMPED, S.* FROM PCNFSAID S WHERE S.CODCLI = 401409 ORDER BY DTSAIDA DESC;
SELECT S.NUMTRANSVENDA, S.CLIENTE, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '11' AND S.NUMNOTA IN (23);
SELECT S.NUMTRANSVENDA, S.CLIENTE, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '2' AND S.CODCLI = 17427 AND S.DTSAIDA = '17/10/2023';
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL IN ('11','2') AND S.CODCOB LIKE 'F%';
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '8' AND S.DTSAIDA = TRUNC(SYSDATE) -2 AND S.VLTOTAL = 56.99;


----PCPEDC
SELECT C.NUMPED, C.NUMPEDRCA, C.NUMPEDCLI, C.NUMNOTA, C.ORIGEMPED, C.CODEMITENTE, C.NUMTRANSVENDA,  C.* FROM PCPEDC C WHERE C.NUMTRANSVENDA IN ( 11752856 );
SELECT C.GERACP, C.NUMNOTA, C.* FROM PCPEDC C WHERE C.CONDVENDA = 10 AND C.GERACP = 'N' ORDER BY C.DATA DESC;
SELECT ROWID, C.CODCOB,C.NUMTRANSVENDA,  C.NUMPEDCLI, C.* FROM PCPEDC C WHERE C.CODFILIAL = '7' AND C.NUMNOTA IN (348663  ,349703 );
SELECT ROWID, C.NUMTRANSVENDA, C.NUMPEDCLI, C.* FROM PCPEDC C WHERE C.NUMPEDCLI = '702-4896488-6732268' ;
SELECT ROWID, c.numviasmapasep, C.VLFRETE, C.GERACP,  C.CONDVENDA, C.POSICAO, C.NUMTRANSVENDA, C.NUMNOTA, C.NUMPEDCLI, C.CODCOB, C.* FROM PCPEDC C WHERE C.NUMPED IN ( 14211046 )  ORDER BY DATA DESC; 
SELECT * FROM PCPEDC C WHERE C.NUMPEDRCA = 129641833;
SELECT ROWID, C.VLFRETE, C.* FROM PCPEDC C WHERE C.CODCOB = 'SHPE'  ORDER BY DATA DESC;
SELECT C.* FROM PCPEDC C WHERE C.CODFILIAL = '2' AND C.CODCOB LIKE 'F%' AND C.POSICAO  NOT IN ('C', 'F');
SELECT C.CONTAORDEM, C.* FROM PCPEDC C WHERE C.CONDVENDA = 8;
SELECT C.CONTAORDEM, C.CONDVENDA, C.* FROM PCPEDC C WHERE C.NUMPEDENTFUT = 14211046;


----PCPEDCTEMP
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDWEB LIKE '%702-4896488-6732268%';
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDCLI LIKE '%702-4896488-6732268%';
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDWEB IN (120528513 , 122927974);


----PCPEDI
SELECT I.ROWID, I.CODFILIALRETIRA, I.* FROM PCPEDI I WHERE I.NUMPED = 14010175;


----PCPEDIDO
SELECT * FROM PCPEDIDO P WHERE P.NUMPED IN( 16760, 16763);
SELECT * FROM PCPEDIDO P WHERE P.DATALANC = '18/10/2023';


---PCITEM
SELECT * FROM PCITEM I WHERE I.NUMPED = 26760;


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 4300040763;


----PCPEDCTEMP
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDCLI = '572183';
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDWEB IN ( 572183, 572240);


----PCPREST
SELECT ROWID, P.DTESTORNO,P.NUMTRANS,  P.CODBANCO, P. * FROM PCPREST P WHERE P.NUMTRANS IN (419793, 319849);
SELECT ROWID, P.DTESTORNO,P.NUMTRANS,  P.CODBANCO, P. * FROM PCPREST P WHERE P.NUMTRANS IN (419792, 319848);
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.CODCLI = 4786 AND P.CODFILIAL = '11' ORDER BY P.NUMTRANSVENDA, P.PREST;
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.CODFILIAL = '1' AND P.DUPLIC IN ( 18969 ); --104479/ 104472
SELECT P.ROWID, P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NUMTRANSVENDA IN (11731294) ORDER BY P.NUMTRANSVENDA, TO_NUMBER(PREST);
SELECT P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NSUHOST IN ( '36886250' );
SELECT ROWID, P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NSUHOST IN ( '15001' );
SELECT P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NUMRESUMO = '050829273';
SELECT P.NSUHOST, P.NSUTEF, P.NUMTRANSVENDA, P.*, P.ROWID FROM PCPREST P WHERE P.DTEMISSAO = TRUNC(SYSDATE) - 2 AND P.CODFILIAL = '12' AND P.NSUHOST IS NULL AND P.CODCOB NOT IN ('CRED', 'D', 'PIXL') ORDER BY P.NUMTRANSVENDA, P.PREST;


----PCPRODUT
SELECT * FROM PCPRODUT P WHERE P.CODFAB ='1002003300008';
SELECT * FROM PCPRODUT P WHERE P.CODAUXILIAR = 7897500555962;
SELECT P.CODAUXILIAR, P.CODPRODMASTER, P.CODPRODPRINC, P.* FROM PCPRODUT P WHERE P.DESCRICAO LIKE '%HOT WHEELS - PACOTE C/05 CARROS%';
SELECT ROWID, P.* FROM PCPRODUT P WHERE P.CODPRODMASTER = 809388;
SELECT P.CODNCMEX, P.CODFAB, P.CODFORNEC, P.OBS2, p.codauxiliar, P. * FROM PCPRODUT P WHERE P.CODPROD IN ( 809388, 811632 );
SELECT P.CODNCMEX, P.CODFAB, P.CODFORNEC, P.OBS2, P. * FROM PCPRODUT P ORDER BY P.CODPROD DESC;


----PCRATEIOCENTROCUSTO
SELECT R.ROWID, R. * FROM PCRATEIOCENTROCUSTO R WHERE R.RECNUM IN (6580253, 6580250);


----PCREGIAO
SELECT * FROM PCREGIAO R;


----PCRAMOATIVIDADE
SELECT * FROM PCATIVI ORDER BY CODATIV;

----PCSUPERV
SELECT * FROM PCSUPERV V ORDER BY V.CODSUPERVISOR;


----PCUSUARI
SELECT ROWID, U.USURDIRFV, U.* FROM PCUSUARI U ORDER BY U.CODUSUR;


----PCTABPR
SELECT NUMREGIAO, CODPROD, MARGEM, PTABELA, PVENDA, P.* FROM PCTABPR P WHERE P.CODPROD IN (809257, 816140, 812469) AND P.NUMREGIAO IN (1,3, 4) ORDER BY P.CODPROD;


----PCTABPRCLI
SELECT * FROM PCTABPRCLI C WHERE C.CODCLI = 98;


----PCTABTRIB
SELECT * FROM PCTABTRIB T WHERE T.CODFILIALNF = '12' AND T.CODPROD = 3465;


----PCTABDEV
SELECT * FROM PCTABDEV D WHERE D.TIPO = 'BO';


----PCVALECX (caixas lojas)
SELECT V.ROWID, V.* FROM PCVALECX V WHERE V.DTLANC = TO_DATE('01/11/2023', 'DD/MM/YYYY');


----PCVERBA
SELECT * FROM PCVERBA V WHERE V.NUMVERBA = 6719;


----JCPAGAMENTOSML
SELECT * FROM JCPAGAMENTOSML M WHERE M.SHIPPING_ID_ML = &NUMPED OR M.PAYMENT_ID_ML = &NUMPED OR M.NUMPEDCLI = &NUMPED; --41984763121


----JCCONGIF
    SELECT 'Bearer ' ||
           (SELECT VALOR JC FROM JCCONFIGC J WHERE J.CODCONFIG = 53) JC,
           'Bearer ' || (SELECT VALOR CFF
                           FROM JCCONFIGI J
                          WHERE J.CODCONFIG = 70
                            AND J.CHAVE = 'ACCESS_TOKEN') CFF,
           'Bearer ' || (SELECT VALOR FFJ
                           FROM JCCONFIGI J
                          WHERE J.CODCONFIG = 86
                            AND J.CHAVE = 'ACCESS_TOKEN') FFJ
      FROM DUAL;
