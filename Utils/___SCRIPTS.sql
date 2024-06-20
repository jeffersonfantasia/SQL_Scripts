----BROKERCONTABIL
SELECT B.ROWID, B.* FROM BROKERCONTABIL B WHERE B.CODCONTAB IN (81429, 81322) ORDER BY CODCONTAB, CODFORNEC ; --10277
SELECT B.ROWID, B.* FROM BROKERCONTABIL B WHERE B.CODFORNEC IN( 9964 ) ;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 1 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODFORNEC, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 1 GROUP BY B.CODFORNEC HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 5 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 6 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 9 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT B.CODCONTAB, COUNT(*) FROM BROKERCONTABIL B WHERE CODFILIAL = 10 GROUP BY B.CODCONTAB HAVING COUNT(*) > 1;
SELECT F.FORNECEDOR, F.CGC, B.* FROM BROKERCONTABIL B JOIN PCFORNEC F ON B.CODFORNEC = F.CODFORNEC AND B.CODFILIAL = 1 AND B.CODCONTAB IN (81381, 81075) ORDER BY B.CODCONTAB, B.CODFORNEC;


----PCAPLICVERBAI
SELECT * FROM PCAPLICVERBAI V WHERE V.CODPROD = 815437 AND V.CODFILIAL = '2';


----PCBANCO
SELECT ROWID,B.CODBACEN, B.CODFILIAL, B.* FROM PCBANCO B ORDER BY B.CODBANCO;
SELECT ROWID,B.CODBACEN, B.CODFILIAL, B.* FROM PCBANCO B WHERE CODBACEN IS NOT NULL ORDER BY B.CODBANCO;


----PCBONUSI
SELECT * FROM PCBONUSI I WHERE I.NUMBONUS = 15581;


----PCCLIENT
SELECT ROWID, C.CALCULAST, C.CONTRIBUINTE, C.CONSUMIDORFINAL, C.IEENT, C.CGCENT, C.CODCLIPRINC, C.CODREDE, C.CODUSUR1, C.DTCADASTRO, C.ESTENT, C.ESTCOB, C.ESTCOM, C.* FROM PCCLIENT C WHERE C.CODCLI IN (561303);
SELECT ROWID, C.CODUSUR1, C.DTCADASTRO, C.TELENT, C.TELCOB, C.TELCOM, C.* FROM PCCLIENT C WHERE C.CODCLI IN (561303);
SELECT C.CODREDE, C.* FROM PCCLIENT C WHERE C.CLIENTE LIKE '%MADRIPEL%';
SELECT C.CODCLI, C.CLIENTE, C.CLIENTPROTESTO FROM PCCLIENT C WHERE C.CODREDE = 911;
SELECT C.* FROM PCCLIENT C WHERE C.CGCENT = '37409180000170';
SELECT C.TIPOTRATAMENTODESCFIN, C.* FROM PCCLIENT C WHERE C.PERDESCFIN > 0;


----PCCRECLI
SELECT ROWID, C.* FROM PCCRECLI C WHERE DTDESCONTO >= TRUNC(SYSDATE) - 0 AND CODFILIAL = '12' AND CODROTINA = 619 ORDER BY CODCLI;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMCRED IN (746176) ORDER BY C.NUMCRED;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMTRANSENTDEVCLI IN (561844) ORDER BY C.NUMCRED;
SELECT ROWID, C.CODIGO, C.* FROM PCCRECLI C WHERE C.CODCLI IN ( 519171 )  ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMNOTADESC = 14418 ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.CODIGO IN ( 251927 ) ORDER BY C.CODIGO;
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMTRANSVENDA = 21927556 OR (C.CODFILIAL = '13' AND DTDESCONTO IS NULL);
SELECT ROWID, C.* FROM PCCRECLI C WHERE C.NUMTRANS IN (319893,319861,419887) OR C.NUMTRANSBAIXA IN (319893,319861,419887);


----PCCOB
SELECT B.CODCLICC, B.PERCTXADMINCC, B.* FROM PCCOB B WHERE B.CODCLICC IS NOT NULL ORDER BY CODCOB;
SELECT ROWID, B.CODCLICC, B.PERCTXADMINCC, B.EXPORTARECF, B.* FROM PCCOB B WHERE B.EXPORTARECF = 'S' ORDER BY CODCOB;


----PCCONTA
SELECT C.CONTACONTABIL, C.* FROM PCCONTA C WHERE C.TIPO <> 'I' AND C.GRUPOCONTA IN ( 210, 300, 530, 535, 540, 545, 550, 555, 560, 565, 610, 620, 650, 660, 820) ORDER BY C.GRUPOCONTA, CODCONTA;
SELECT rowid, C.CONTACONTABIL, C.* FROM PCCONTA C WHERE C.TIPO <> 'I' AND C.GRUPOCONTA IN ( 210 ) ORDER BY C.GRUPOCONTA, CODCONTA;
SELECT C.* FROM PCCONTA C WHERE C.CONTACONTABIL = 778; 
SELECT C.* FROM PCCONTA C WHERE C.CODCONTA = 101002; 


----PCCENTROCUSTO
SELECT ROWID, C. * FROM PCCENTROCUSTO C ORDER BY CODIGOCENTROCUSTO;


----PCEST
SELECT E.CODPROD, E.QTEST, E.QTESTGER, E.CODDEVOL, E.* FROM PCEST E WHERE E.CODFILIAL = '2' AND E.CODPROD = 3465;


----PCFILIAL
SELECT F.NOMEREMETENTE, F.FANTASIA, F.* FROM PCFILIAL F ORDER BY TO_NUMBER(F.CODIGO);

----PCFORNEC
SELECT F.ROWID, F.OBS2, F.REVENDA, F.TIPOFORNEC, F.* FROM PCFORNEC F WHERE F.FORNECEDOR LIKE '%TAOKI%'; 
SELECT F.ROWID, F.OBS2, F.* FROM PCFORNEC F WHERE REGEXP_REPLACE(F.CGC, '([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{4})', '\1.\2.\3/\4-') = '41.384.562/0001-63'; 
SELECT ROWID, F.OBS2, CODFORNECPRINC, F. * FROM PCFORNEC F WHERE F.CODFORNEC IN (10470); --48.824.508/0001-30
SELECT ROWID, F.REVENDA, F.SIMPLESNACIONAL, F.EMITENFE, F. * FROM PCFORNEC F WHERE F.CODFORNEC IN (10301, 10284);
SELECT ROWID, F.OBS2, F. * FROM PCFORNEC F WHERE F.CODFORNEC IN (9177) OR F.OBS2 = 'GOV' ;


----PCFORNECFILIAL
SELECT F.DEDUZIRICMSBASEPISCOFINS, F. * FROM PCFORNECFILIAL F JOIN PCFORNEC C ON F.CODFORNEC = C.CODFORNEC WHERE F.CODFILIAL IN ('1','2','3','4','7','8','11','12','13') AND C.REVENDA = 'T';
UPDATE PCFORNECFILIAL SET DEDUZIRICMSBASEPISCOFINS = NULL WHERE CODFILIAL IN ('1','2','3','4','7','8','11','12','13') AND CODFORNEC IN (SELECT CODFORNEC FROM PCFORNEC WHERE REVENDA = 'T');


----PCGERENTE
SELECT ROWID,  G.* FROM PCGERENTE G ORDER BY CODGERENTE;


----PCHISTEST
SELECT * FROM PCHISTEST H WHERE H.CODFILIAL IN ('2', '11') AND H.CODPROD IN (/*162887*/ 3465) AND H.DATA = TO_DATE ('31/07/2023', 'DD/MM/YYYY') ;


----PCLANC
SELECT ROWID, L.DTCOMPETENCIA, L.DTLANC, L.DTEMISSAO, L.DTVENC, L.DTPAGTO, L. * FROM PCLANC L WHERE L.CODFILIAL IN ('7', '9', '10' ) AND L.CODCONTA IN ( 420102, 670103) AND HISTORICO LIKE '%FRETE%' AND NUMBANCO IN (36,69,74) ORDER BY L.DTLANC DESC, L.CODFILIAL;
SELECT ROWID, L.DTCOMPETENCIA, L.RECNUMPRINC, l.fornecedor, L. * FROM PCLANC L WHERE L.RECNUM IN (6871792);
SELECT ROWID, L.DTCOMPETENCIA, L.FORNECEDOR, L.RECNUMPRINC, L.* FROM PCLANC L WHERE L.RECNUMPRINC IN ( 2577476 ) ORDER BY CODFORNEC, NUMNOTA;
SELECT ROWID, L.DTCOMPETENCIA, L.DTLANC, L.DTEMISSAO, L.DTVENC, L.DTPAGTO, l.dtestornobaixa, L.* FROM PCLANC L WHERE L.NUMTRANS IN ( 549796); 
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.NUMBORDERO IN ( 12818 ); 
SELECT ROWID, L.DTCOMPETENCIA, L.DTESTORNOBAIXA, L.NUMTRANS, L.RECNUMPRINC, L.* FROM PCLANC L WHERE L.NUMNOTA IN (34062) AND L.CODFORNEC = 137;
SELECT ROWID, L.* FROM PCLANC L WHERE L.CODFILIAL IN ('8','12', '13') AND L.CODFORNEC IN ( 10260, 10282) AND L.DTLANC >= TRUNC(SYSDATE) - 2 AND L.CODCONTA IN (100001, 100003, 560113) ORDER BY NUMNOTA;
SELECT ROWID, L.DTCOMPETENCIA, L.DTESTORNOBAIXA, L.NUMTRANS, L.NUMBANCO, L.* FROM PCLANC L WHERE L.NUMNOTA IN ( 117181 ) AND L.CODFILIAL = '7'; 
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.CODFORNEC IN ( 9272 ) AND TIPOPARCEIRO = 'F' ORDER BY L.DTPAGTO DESC;
SELECT ROWID, L.DTCOMPETENCIA, L.DTEMISSAO, L.* FROM PCLANC L WHERE L.NUMBANCO = 80 AND CODCONTA IN (300108,300109, 300110, 300111) /*AND L.DTLANC = '21/02/2024'*/ ORDER BY L.DTLANC DESC;
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.NUMBANCO = 77 ORDER BY L.DTLANC DESC;
SELECT ROWID, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.HISTORICO LIKE '%CAMERAS%' ORDER BY L.DTLANC DESC;
SELECT ROWID, L.NUMBANCO, L.RECNUM, L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.CODCONTA = 590101 AND DTLANC = TRUNC(SYSDATE) - 1;
SELECT L.DTCOMPETENCIA, L.* FROM PCLANC L WHERE L.VPAGO = 476.33 AND L.DTPAGTO BETWEEN '01/09/2023' AND '31/10/2023'; 
SELECT ROWID, L.DTCOMPETENCIA, L.FORNECEDOR, L.* FROM PCLANC L WHERE L.CODCONTA IN (545109) ORDER BY L.DTPAGTO DESC;


----PCLOGLANCAMENTO
SELECT * FROM PCLANCLOG L WHERE L.RECNUM  IN (2574469, 2574478);
SELECT L.CODROTINACAD, L.* FROM PCLANC L WHERE L.RECNUM  IN (2574469, 2574478, 2579004, 2579006);


----PCRATEIOCENTROCUSTO
SELECT R.ROWID, R.* FROM PCRATEIOCENTROCUSTO R WHERE R.RECNUM IN (6804301, 6804300);


----PCMARCA
SELECT * FROM PCMARCA M ORDER BY MARCA;


----PCMOV
SELECT M.MOVESTOQUECONTABIL, M.NUMTRANSENT, M.DESCRICAO, M.* FROM PCMOV M WHERE M.NUMTRANSDEV IN (12841067);
SELECT ROWID, M.NUMTRANSENT, M.NUMTRANSVENDA, M.DESCRICAO, M.CODFISCAL, M.CODFILIALRETIRA, M.* FROM PCMOV M WHERE M.CODPROD IN (811963) AND ((CODFILIAL = '6' AND CODOPER = 'SD') OR (CODFILIAL = '2' AND CODOPER = 'ED'));
SELECT M.CODST, M.NUMTRANSITEM, M.NUMTRANSENT, M.NUMTRANSVENDA, M.NUMTRANSDEV, M.DESCRICAO, M.CODFISCAL, M.* FROM PCMOV M WHERE M.NUMNOTA IN (62628) AND CODFILIAL = '10';
SELECT M.DTCANCEL, M.DESCRICAO, M.CODFISCAL, M.NUMPED, M.ROTINALANC, M.* FROM PCMOV M WHERE M.NUMTRANSVENDA = 21951420 ;
SELECT M.ROWID, M.DTCANCEL, M.NUMTRANSDEV, M.DESCRICAO, M.CODFISCAL, M.PERCICMRED, M.NUMPED, M.* FROM PCMOV M WHERE M.NUMTRANSENT IN (1726349);
SELECT M.NUMTRANSENT, M.* FROM PCMOV M WHERE M.CODOPER= 'ET' AND M.STATUS = 'AB' ORDER BY DTMOV DESC;
SELECT ROWID, M.MOVESTOQUECONTABIL, M.NUMTRANSENT, M.NUMTRANSVENDA, M.DESCRICAO, M.CODFISCAL, M.CODFILIALRETIRA, M.DTCANCEL, M.QTCONT,  M.* FROM PCMOV M WHERE M.CODPROD IN (818527) AND M.CODFILIAL = '8' AND DTMOV BETWEEN '26/02/2023' AND '31/12/2023' ORDER BY M.NUMTRANSITEM;
SELECT * FROM PCMOV M WHERE M.NUMBONUS = 15581;


----PCMOVCOMPLE
SELECT M.VLICMS, M.* FROM PCMOVCOMPLE M WHERE M.NUMTRANSITEM IN ( 3289535, 3289532);


----PCMOVCR
SELECT ROWID, M.DTCOMPENSACAO, M.ESTORNO,  M.* FROM PCMOVCR M WHERE M.NUMTRANS IN ( 549796 ) ORDER BY NUMSEQ;
SELECT ROWID, M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.CODBANCO = 41 AND M.DATA >= TRUNC(SYSDATE) - 30 ORDER BY M.DTCOMPENSACAO DESC;
SELECT * FROM PCMOVCR M WHERE M.CODCOB = 'D' AND M.DTCOMPENSACAO BETWEEN '01/07/2023' AND '31/07/2023' AND M.CODBANCO = 65 ORDER BY M.DATACOMPLETA;
SELECT * FROM PCMOVCR M WHERE DATA BETWEEN TO_DATE('17/10/2023', 'DD/MM/YYYY') AND  TO_DATE('18/10/2023', 'DD/MM/YYYY') AND CODBANCO = 12;


----PCMOVCRFOR
SELECT ROWID,  M.CODFORNECPRINC, M.* FROM PCMOVCRFOR M WHERE M.NUMVERBA = 9971;
SELECT ROWID,  M.CODFORNECPRINC, M.* FROM PCMOVCRFOR M WHERE M.CODFORNECPRINC = 2 AND M.DTCONCIL >= '31/07/2023' AND M.CODFILIAL = '2';


----PCNFBASE
SELECT B.ROWID, B.* FROM PCNFBASE B WHERE B.NUMTRANSENT = 1673578;


----PCNFBASEENT
SELECT * FROM PCNFBASEENT B WHERE B.NUMTRANSENT = 1673578;


----PCNFBASESAID
SELECT * FROM PCNFBASESAID B WHERE B.NUMTRANSENT = 1673578;


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 14010155;


----PCNFENT
SELECT ROWID, E.VLFRETE, E.FORNECEDOR, E.CHAVENFE, E.TIPODESCARGA, E.* FROM PCNFENT E WHERE E.NUMTRANSENT IN (1712732);
SELECT E.CHAVENFE, E.NUMTRANSENT, E.FORNECEDOR, E.* FROM PCNFENT E WHERE E.NUMNOTA IN (52685 ) ;
SELECT ROWID, E.CHAVENFE, E.NUMTRANSENT, E.FORNECEDOR, E.CODFORNECNF, E.* FROM PCNFENT E WHERE E.CODFORNEC IN (10399 ) ;
SELECT E.DTCANCEL, e.fornecedor, E.* FROM PCNFENT E WHERE E.DTENT BETWEEN '01/07/2023' AND '31/07/2023' AND E.CODFILIAL = '2' AND E.ESPECIE = 'CT';
SELECT E.DTCANCEL, E.NUMTRANSENT, E.* FROM PCNFENT E WHERE E.CODFORNEC = 519770 AND E.TIPODESCARGA = '6';
SELECT E.DTCANCEL, e.fornecedor, E.* FROM PCNFENT E WHERE E.DTENT BETWEEN '01/07/2023' AND '31/08/2023' AND E.CODFORNEC IN ( 9085, 9557, 9625 );


----PCNFSAID
SELECT S.VLFRETE, S.NUMTRANSVENDA, S.CLIENTE, S.CGC, S.CHAVENFE, S.DTCANCEL, S.* FROM PCNFSAID S WHERE S.NUMTRANSVENDA IN (11840765); 
SELECT S.NUMTRANSVENDA, S.NUMPED, S.* FROM PCNFSAID S WHERE S.CODCLI = 539552 ORDER BY DTSAIDA DESC;
SELECT s.dtcancel, S.NUMTRANSVENDA, S.CLIENTE, S.CODCOB, S.SITUACAONFE,  S.* FROM PCNFSAID S WHERE S.NUMNOTA IN (83056  ) AND S.CODFILIAL = '2'  ;
SELECT S.NUMTRANSVENDA, S.CLIENTE, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '2' AND S.CODCLI = 460938 AND S.DTSAIDA = '17/10/2023';
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL IN ('11','2') AND S.CODCOB LIKE 'F%';
SELECT S.NUMTRANSVENDA, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '13' AND S.DTSAIDA = TO_DATE('03/03/2024', 'DD/MM/YYYY');
SELECT S.NUMTRANSVENDA, S.CLIENTE, S.CODCOB,  S.* FROM PCNFSAID S WHERE S.CODFILIAL = '13' AND S.CODUSUR = 93 AND S.DTSAIDA = '20/10/2023';


----PCPEDC
SELECT C.NUMPED, C.NUMPEDRCA, C.NUMPEDCLI, C.NUMNOTA, C.ORIGEMPED, C.CODEMITENTE, C.NUMTRANSVENDA, C.ROWID,  C.* FROM PCPEDC C WHERE C.NUMTRANSVENDA IN ( 11536055 ); --LU-1193570392354077
SELECT C.GERACP, C.NUMNOTA, C.* FROM PCPEDC C WHERE C.CONDVENDA = 10 AND C.GERACP = 'N' ORDER BY C.DATA DESC;
SELECT ROWID, C.CODCOB,C.NUMTRANSVENDA,  C.NUMPEDCLI, C.* FROM PCPEDC C WHERE C.CODFILIAL = '7' AND C.NUMNOTA IN (348663  ,349703 );
SELECT ROWID, C.NUMTRANSVENDA, C.NUMNOTA, C.NUMPEDCLI, C.* FROM PCPEDC C WHERE C.NUMPEDCLI = '1409130596764-01' ;
SELECT ROWID, C.CODEMITENTE, C.VLFRETE, C.GERACP,  C.CONDVENDA, C.POSICAO, C.NUMTRANSVENDA, C.NUMNOTA, C.NUMPEDCLI, C.CODCOB, C.CODUSUR, C.* FROM PCPEDC C WHERE C.NUMPED IN ( 27208337 )  ORDER BY DATA DESC; 
SELECT C.NUMPEDRCA, C.NUMPEDCLI,  C.*, C.ROWID FROM PCPEDC C WHERE C.NUMPEDRCA IN ( 145899428 );
SELECT ROWID, C.VLFRETE, C.* FROM PCPEDC C WHERE C.CODCOB = 'SHPE'  ORDER BY DATA DESC;
SELECT C.* FROM PCPEDC C WHERE C.CODFILIAL = '11' AND C.CODCOB LIKE 'F%' AND C.POSICAO  NOT IN ('C', 'F');
SELECT C.NUMTRANSVENDA, C.* FROM PCPEDC C WHERE C.CODFILIAL = '11' AND C.CODCOB LIKE 'F%' AND C.POSICAO = 'F' ORDER BY C.DATA DESC;
SELECT C.GERACP, C.*, ROWID FROM PCPEDC C WHERE C.CODCLI = 499420 ORDER BY C.DATA DESC;
SELECT C.CONTAORDEM, C.* FROM PCPEDC C WHERE C.CONDVENDA = 8;
SELECT C.CONTAORDEM, C.CONDVENDA, C.* FROM PCPEDC C WHERE C.NUMPEDENTFUT = 14211046;
SELECT C.GERACP, C.POSICAO, C.*, ROWID FROM PCPEDC C WHERE C.CONDVENDA = 10 AND C.POSICAO NOT IN ('C', 'F');


----PCPEDCTEMP
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDWEB LIKE '%701-9031720-9352242%';
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDCLI LIKE '%1410040597413-01%';
SELECT rowid, p.* FROM PCPEDCTEMP P WHERE P.NUMPEDWEB IN (136271861);


----PCPEDI
SELECT I.ROWID, I.CODFILIALRETIRA, I.* FROM PCPEDI I WHERE I.NUMPED IN (17003129);


----PCPEDIDO
SELECT P.ROWID, P.CODCOMPRADOR, P.* FROM PCPEDIDO P WHERE P.NUMPED IN( 218882,219230,219522 );
SELECT * FROM PCPEDIDO P WHERE P.DATALANC = '18/10/2023';


----PCEMPR
SELECT * FROM PCEMPR E WHERE E.CODSETOR = 2;
SELECT ROWID, E.CODUSUR, E.* FROM PCEMPR E WHERE E.CODFILIAL = 8;


----PCITEM
SELECT * FROM PCITEM I WHERE I.NUMPED = 26760;


----PCNFCAN
SELECT * FROM PCNFCAN C WHERE C.NUMPED = 4300040763;


----PCPEDCTEMP
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDCLI = '572183';
SELECT * FROM PCPEDCTEMP P WHERE P.NUMPEDWEB IN ( 572183, 572240);


----PCPREST
SELECT ROWID, P.DTESTORNO,P.NUMTRANS,  P.CODBANCO, P. * FROM PCPREST P WHERE P.NUMTRANS IN (319271, 319272, 319273, 319274, 319409, 319410, 319411 );
SELECT ROWID, P.DTESTORNO,P.NUMTRANSVENDA, P.NUMTRANS,  P.CODBANCO, P. * FROM PCPREST P WHERE P.NUMTRANS IN (545197);
SELECT P.NUMTRANSVENDA, P.* FROM PCPREST P WHERE P.CODCLI = 4786 AND P.CODFILIAL = '11' ORDER BY P.NUMTRANSVENDA, P.PREST;
SELECT ROWID, P.NUMCHEQUE,  P.NUMTRANSVENDA, P.DTESTORNO, P.* FROM PCPREST P WHERE P.CODFILIAL = '12' AND P.DUPLIC IN ( 13250 ) ORDER BY P.NUMTRANSVENDA, TO_NUMBER(PREST); --104479/ 104472
SELECT ROWID, P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.NUMTRANS, P.* FROM PCPREST P WHERE P.NUMTRANSVENDA IN ( 22009607) ORDER BY P.NUMTRANSVENDA, TO_NUMBER(PREST);
SELECT P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NSUHOST IN ( '251824355' );
SELECT ROWID, P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NSUHOST IN ( '503763213' );
SELECT ROWID, P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NSUTEF IN ( '503763213' );
SELECT P.NUMTRANSVENDA, P.CODCOBORIG, P.OBSTITULO, P.* FROM PCPREST P WHERE P.NUMRESUMO = '059031101';
SELECT P.NSUHOST, P.NSUTEF, P.NUMTRANSVENDA, P.*, P.ROWID FROM PCPREST P WHERE P.DTEMISSAO = TRUNC(SYSDATE) - 3 AND P.CODFILIAL = '13' AND /*P.NSUHOST IS NULL AND*/ P.CODCOB NOT IN ('CRED', 'D', 'PIXL', 'CONV') ORDER BY P.NUMTRANSVENDA, P.PREST;
SELECT * FROM PCPREST P WHERE P.DTEMISSAO = '20/10/2023' AND P.CODCLI = 1 AND P.CODUSUR = 93;


----PCPRESTTEMP
SELECT * FROM PCPRESTTEMP WHERE NSUTEF = 574399;
SELECT * FROM PCPRESTTEMP P WHERE P.DTEMISSAO >= TRUNC(SYSDATE) - 15 AND CODCOB = 'CMGL' ORDER BY DTEMISSAO DESC;


----PCPRODUT
SELECT * FROM PCPRODUT P WHERE P.CODFAB ='1002003300008';
SELECT * FROM PCPRODUT P WHERE P.CODAUXILIAR = 7897500555962;
SELECT P.CODAUXILIAR, P.CODPRODMASTER, P.CODPRODPRINC, P.* FROM PCPRODUT P WHERE P.DESCRICAO LIKE '%CAI NAO CAI%';
SELECT ROWID, P.CODAUXILIAR, P.* FROM PCPRODUT P WHERE P.CODPRODMASTER = 821714;
SELECT ROWID, P.CODAUXILIAR, P.* FROM PCPRODUT P WHERE P.CODFORNEC = 7287;
SELECT P.CODNCMEX, P.CODFAB, P.CODFORNEC, P.OBS2, p.codauxiliar, P. * FROM PCPRODUT P WHERE P.CODPROD IN (3009 );
SELECT P.CODNCMEX, P.CODFAB, P.CODFORNEC, P.OBS2, P. * FROM PCPRODUT P ORDER BY P.CODPROD DESC;


----PCREGIAO
SELECT * FROM PCREGIAO R;


----PCRAMOATIVIDADE
SELECT * FROM PCATIVI ORDER BY CODATIV;


----PCSUPERV
SELECT * FROM PCSUPERV V ORDER BY V.CODSUPERVISOR;


----PCUSUARI
SELECT ROWID, U.USURDIRFV, U.* FROM PCUSUARI U ORDER BY U.CODUSUR;
SELECT ROWID, u.bloqueio, CODSUPERVISOR, U.USURDIRFV, U.* FROM PCUSUARI U WHERE U.CODSUPERVISOR IN (13) ORDER BY U.CODSUPERVISOR;


----PCTABPR
SELECT NUMREGIAO, CODPROD, MARGEM, PTABELA, PVENDA, P.* FROM PCTABPR P WHERE P.CODPROD IN (809257, 816140, 812469) AND P.NUMREGIAO IN (1,3, 4) ORDER BY P.CODPROD;
SELECT NUMREGIAO, CODPROD, MARGEM, PTABELA, PVENDA, P.* FROM PCTABPR P WHERE P.CODPROD IN (818334, 817518) AND P.NUMREGIAO IN (100) ORDER BY P.CODPROD;


----PCTABPRCLI
SELECT * FROM PCTABPRCLI C WHERE C.CODCLI = 98;


---PCTRIBUT
SELECT * FROM PCTRIBUT T;


----PCTABTRIB
SELECT T.* FROM PCTABTRIB T WHERE T.CODFILIALNF = '12' AND T.CODPROD = 3465;
SELECT T.* FROM PCTABTRIB T JOIN PCPRODUT P ON T.CODPROD = P.CODPROD WHERE P.CODNCMEX = '96082000.' ORDER BY T.CODFILIALNF;


----PCTABDEV
SELECT * FROM PCTABDEV D WHERE D.TIPO = 'BO';


----PCTRANSFDEP
SELECT * FROM PCTRANSFDEP WHERE CODFILIALORIGEM = '2' AND CODFILIALDESTINO = '7' ORDER BY DTTRANSF DESC;


----PCVALECX (caixas lojas)
SELECT V.ROWID, V.* FROM PCVALECX V WHERE V.DTLANC = TO_DATE('21/12/2023', 'DD/MM/YYYY');


----PCVERBA
SELECT * FROM PCVERBA V WHERE V.CODFORNEC = 7543 AND CODFILIAL = '10' AND CODCONTA = 680108;
SELECT ROWID, V.* FROM PCVERBA V WHERE V.NUMVERBA IN (9877);
SELECT ROWID, V.*  FROM PCAPLICVERBAI V WHERE V.NUMVERBA IN (9877);
SELECT ROWID, V.*  FROM PCAPLICVERBA V WHERE V.NUMVERBA IN (9877);
SELECT ROWID, V.*  FROM PCMOVCRFOR V WHERE V.NUMVERBA IN (9877);


----PCDESCONTO
SELECT D.CODDESCONTO,
       D.DESCRICAO,
       D.ORIGEMPED,
       D.NUMREGIAO,
       R.REGIAO,
       D.CODFILIAL,
       D.CODATIV,
       A.RAMO,
       D.CODPRACA,
       D.CODREDE,
       D.PERCOMMINT,
       D.PERCOMREP,
       D.PERCOMEXT
  FROM PCDESCONTO D
  LEFT JOIN PCATIVI A ON A.CODATIV = D.CODATIV
  LEFT JOIN PCREGIAO R ON R.NUMREGIAO = D.NUMREGIAO



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
