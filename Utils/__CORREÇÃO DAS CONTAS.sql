/*CORRE��O DAS CONTAS */
/*BUSCAR O FORNECEDOR NA PCNFENT*/
SELECT 
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
       E.VLOUTRAS,
			 E.*,ROWID
  FROM PCNFENT E
 WHERE 1 = 1
   --AND NUMTRANSENT IN (1807046, 1807044, 1807049) 
   AND NUMNOTA IN ( 87904 )
	 AND CODFORNEC = 10503    
 --AND E.DTENT >= '01/11/2024'
 --AND E.CODCONT = 3201
 ORDER BY E.DTENT DESC;
;
/*CONSULTAR NA PCLANC NUMNOTA*/
  SELECT  L.NOMEFUNC, L.CODCONTA, l.recnumprinc, L.DTCOMPETENCIA,
         L.DTEMISSAO, L.NUMNOTA,
         L.DTESTORNOBAIXA,
         L.NUMTRANS,
         L.DTPAGTO,
         L.TIPOPARCEIRO,
         L.DTCOMPETENCIA, 
         L.FORNECEDOR, L.NUMBANCO,
         L.*,L.ROWID
    FROM PCLANC L
    LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
   WHERE 1 = 1
	 AND L.NUMNOTA  IN (87904)
   AND (CODFORNEC IN (10503) AND TIPOPARCEIRO = 'F')
		 --AND L.DTDESD IS NULL
		 AND M.DTESTORNO IS NULL
		 --AND L.DTLANC >= '01/01/2024' 
		 --AND L.DTCOMPETENCIA >= '01/10/2024'
   ORDER BY L.DTLANC DESC, L.NUMNOTA;
	 
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
 WHERE L.RECNUM IN (6889642,6889655)
       --L.NUMTRANS IN (547011, 545853)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.*
  FROM PCMOVCR M
 WHERE M.NUMTRANS IN (419882);
 
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
