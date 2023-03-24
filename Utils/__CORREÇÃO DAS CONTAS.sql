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
 NUMNOTA IN (2374912, 2375491)
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
   WHERE L.NUMNOTA IN (390,52598)
     AND (CODFORNEC IN (8503, 8950) AND TIPOPARCEIRO = 'F')
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
 WHERE L.RECNUM IN (2374912, 2375491)
--L.NUMTRANS IN (302737)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.*
  FROM PCMOVCR M
 WHERE M.NUMTRANS IN (306601, 306669);
