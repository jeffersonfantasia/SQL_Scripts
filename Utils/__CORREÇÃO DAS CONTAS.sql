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
 WHERE --NUMTRANSENT IN (1696509)
       NUMNOTA IN (  506039496  )
  -- AND CODFORNEC = 10323
 ORDER BY DTENT;
;
/*CONSULTAR NA PCLANC NUMNOTA*/
  SELECT L.ROWID, L.NOMEFUNC, L.CODCONTA,
         L.DTEMISSAO,L.DTCANCEL, L.DTESTORNOBAIXA,
         L.NUMTRANS,
				 L.DTDESD,
         L.DTPAGTO,
         L.TIPOPARCEIRO,
         L.DTCOMPETENCIA, M.DTCOMPENSACAO,
         L.RECNUMPRINC,
				 l.HISTORICO2, L.FORNECEDOR,
         L.*
    FROM PCLANC L
    LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
   WHERE L.NUMNOTA  IN (506039496   )  --10325 
  --AND (CODFORNEC IN (9709) AND TIPOPARCEIRO = 'F')
		 --AND L.DTDESD IS NULL
   ORDER BY L.NUMNOTA, L.DTLANC DESC;
	 
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
                L.*
  FROM PCLANC L
  LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
 WHERE L.RECNUM IN (6660011)
       --=L.NUMTRANS IN (308659)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.*
  FROM PCMOVCR M
 WHERE M.NUMTRANS IN (528273,
532077
);
