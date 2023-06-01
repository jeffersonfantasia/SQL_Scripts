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
 WHERE NUMTRANSENT IN (523259,542536)
       --NUMNOTA IN (20981, 29248 )
       --AND CODFORNEC = 10094
 ORDER BY DTENT;
;
/*CONSULTAR NA PCLANC NUMNOTA*/
  SELECT L.ROWID,
         L.DTEMISSAO,
         L.NUMTRANS,
				 L.DTDESD,
         L.DTPAGTO,
         L.TIPOPARCEIRO,
         L.DTCOMPETENCIA, M.DTCOMPENSACAO,
         L.RECNUMPRINC,
				 l.historico2,
         L.*
    FROM PCLANC L
    LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
   WHERE L.NUMNOTA IN (1188743) 
     --AND (CODFORNEC IN (9868, 10086) AND TIPOPARCEIRO = 'F')
		 AND L.DTDESD IS NULL
   ORDER BY L.NUMNOTA;

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
 WHERE L.RECNUM IN (2332388)
       --=L.NUMTRANS IN (308659)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.*
  FROM PCMOVCR M
 WHERE M.NUMTRANS IN (307851,307852);
