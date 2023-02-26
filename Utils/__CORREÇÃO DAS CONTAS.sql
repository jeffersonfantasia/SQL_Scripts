/*CORRE��O DAS CONTAS */
/*BUSCAR O FORNECEDOR NA PCNFENT*/
SELECT ROWID,
       E.CODCONT,
       E.CODFUNCLANC,
       E.CODFILIAL,
       E.CODFILIALNF,
       E.CODFORNEC,
       E.CODFORNECNF,
       E.NUMTRANSENT,
       E.VLST,
       E.VLOUTRAS,
       E.*
  FROM PCNFENT E
 WHERE --NUMTRANSENT IN ( 504213)
 NUMNOTA IN (341189006 )
--CODFORNEC = 9528
 ORDER BY DTENT;
;
/
/*CONSULTAR NA PCLANC NUMNOTA*/
  SELECT L.ROWID,
         L.DTEMISSAO,
         L.NUMTRANS,
         L.DTPAGTO,
         L.TIPOPARCEIRO,
         L.DTCOMPETENCIA,
         L.RECNUMPRINC,
         L.*
    FROM PCLANC L
    LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
   WHERE L.NUMNOTA IN (33)
     AND (CODFORNEC IN (9620) AND TIPOPARCEIRO = 'F');
     
/*CONSULTAR NA PCLANC RECNUM*/
SELECT DISTINCT L.ROWID,
                L.DTEMISSAO,
                L.DTESTORNOBAIXA,
                L.NUMTRANS,
                M.DTCOMPENSACAO,
                L.DTPAGTO,
                L.TIPOPARCEIRO,
                L.DTCOMPETENCIA,
                L.*
  FROM PCLANC L
  LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
 WHERE L.RECNUM IN (2354200, 2354203)
--L.NUMTRANS IN (302737)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.* FROM PCMOVCR M WHERE M.NUMTRANS IN (304463);

--LANCAMENTOS SEM CONTA INFORMADA
SELECT L.* FROM PCLANC L WHERE L.CODCONTA = 0 AND CODROTINACAD = 'ESJCB9876.exe' ORDER BY DTLANC DESC;
    --UPDATE CORRE�AO CODCONTA ZERADO
     UPDATE PCLANC SET CODCONTA = 620108 WHERE CODCONTA = 0 AND CODROTINACAD = 'ESJCB9876.exe';

--LANCAMENTO COM DESCONTO NA CONTA INCORRETA
SELECT L. * FROM PCLANC L WHERE L.CODCONTA = 620103 AND CODROTINABAIXA IN (1209, 1207) AND CODFILIAL IN ('7','9','10') ORDER BY DTLANC DESC;
       --UPDATE CORRE�AO CODCONTA ERRADA
       UPDATE PCLANC SET CODCONTA = 620108 WHERE CODCONTA = 620103 AND CODROTINABAIXA IN (1209, 1207) AND CODFILIAL IN ('7','9','10');
