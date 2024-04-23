/*CORRE��O DAS CONTAS */
/*BUSCAR O FORNECEDOR NA PCNFENT*/
SELECT ROWID,
        E.DTLANCTO, E.CODFUNCLANC,
       E.FUNCLANC FUNCULTALTER,
       E.CODCONT,
       E.CODFUNCLANC, e.fornecedor,
       E.CODFILIAL,
       E.CODFILIALNF,
       E.CODFORNEC,
       E.CODFORNECNF,
       E.NUMTRANSENT,
       E.VLST,
       E.VLOUTRAS,
       E.*
  FROM PCNFENT E
 WHERE --NUMTRANSENT IN (1718336)
       NUMNOTA IN ( 1132,1133,1134, 37212427, 213263  )
  -- AND CODFORNEC = 10323
 ORDER BY DTENT DESC;
;
/*CONSULTAR NA PCLANC NUMNOTA*/
  SELECT L.ROWID, L.NOMEFUNC, L.CODCONTA,
         L.DTEMISSAO,
				 --L.DTCANCEL, 
				 L.DTESTORNOBAIXA,
         L.NUMTRANS,
				 --L.DTDESD,
         L.DTPAGTO,
         L.TIPOPARCEIRO,
         L.DTCOMPETENCIA, 
				 --M.DTCOMPENSACAO,
         --L.RECNUMPRINC,
				 --l.HISTORICO2,
				  L.FORNECEDOR,
         L.*
    FROM PCLANC L
    LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
   WHERE L.NUMNOTA  IN ( 30684 )  --10325 
  AND (CODFORNEC IN (10480 ) AND TIPOPARCEIRO = 'F') --26329366
		 --AND L.DTDESD IS NULL
		 AND M.DTESTORNO IS NULL
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
 WHERE L.RECNUM IN (6833694)
       --=L.NUMTRANS IN (308659)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.*
  FROM PCMOVCR M
 WHERE M.NUMTRANS IN (545081,545080, 545079, 545074, 545078);
