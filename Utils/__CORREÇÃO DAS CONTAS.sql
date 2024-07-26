/*CORRE��O DAS CONTAS */
/*BUSCAR O FORNECEDOR NA PCNFENT*/
SELECT ROWID,
       E.DTLANCTO,
       E.FUNCLANC FUNCULTALTER,
       E.CODCONT,
       E.CODFUNCLANC,
       E.FORNECEDOR,
			 E.CGC,
       E.CODFILIAL,
       E.CODFILIALNF,
       E.CODFORNEC,
       E.CODFORNECNF,
       E.NUMTRANSENT,
       E.VLST,
       E.VLOUTRAS,
       E.*
  FROM PCNFENT E
 WHERE --NUMTRANSENT IN (1752850) --10361
    NUMNOTA IN (6247884)
 --AND CODFORNEC = 10304
 AND E.DTENT >= '01/01/2022'
 ORDER BY DTENT DESC;
;
/*CONSULTAR NA PCLANC NUMNOTA*/
  SELECT L.ROWID, L.NOMEFUNC, L.CODCONTA,
         L.DTEMISSAO,
         L.DTESTORNOBAIXA,
         L.NUMTRANS,
         L.DTPAGTO,
         L.TIPOPARCEIRO,
         L.DTCOMPETENCIA, 
         L.FORNECEDOR,
         L.*
    FROM PCLANC L
    LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
   WHERE L.NUMNOTA  IN ( 6247884 )
   AND (CODFORNEC IN (10571 ) AND TIPOPARCEIRO = 'F') --10571
		 --AND L.DTDESD IS NULL
		 AND M.DTESTORNO IS NULL
		 AND L.DTLANC >= '01/01/2022'
   ORDER BY L.DTLANC DESC, L.NUMNOTA; --IDT BRASIL TELECOMUNICACAO LTDAQ
	 
	 SELECT * FROM PCLANCLOG WHERE CODFORNEC = 312;

/*CONSULTAR NA PCLANC RECNUM*/
SELECT DISTINCT L.ROWID,
                L.DTEMISSAO,
                L.DTESTORNOBAIXA,
                L.NUMTRANS,
                M.DTCOMPENSACAO,
                L.DTPAGTO,
                L.TIPOPARCEIRO,
                L.DTCOMPETENCIA,
                L.RECNUMPRINC,
								l.fornecedor,
                L.*
  FROM PCLANC L
  LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
 WHERE --L.RECNUM IN (6833694)
       L.NUMTRANS IN (547011, 545853)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.*
  FROM PCMOVCR M
 WHERE M.NUMTRANS IN (547011);
 
 SELECT * FROM PCLANC L WHERE L.NUMTRANS = 547011;


SELECT NUMNOTA, CODCONT, CODFORNEC, VLTOTAL, COUNT(NUMTRANSENT)
 FROM PCNFENT E
 WHERE ESPECIE <> 'OE' 
 AND CODCONT = 100002
 GROUP BY NUMNOTA, CODCONT, CODFORNEC, VLTOTAL
 HAVING COUNT(NUMTRANSENT) > 1;
 
 SELECT E.*
 FROM PCNFENT E
 WHERE ESPECIE <> 'OE'
 AND E.NUMNOTA = 69;
