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
 WHERE NUMTRANSENT IN ( 547166)
 --NUMNOTA IN (2374912, 2375491)
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
   WHERE L.NUMNOTA IN (40333,199,154,470)
     AND (CODFORNEC IN (7454,9470,8046,9015) AND TIPOPARCEIRO = 'F')
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
 WHERE --L.RECNUM IN (2396715, 2396716)
       L.NUMTRANS IN (308481)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID, M.DTESTORNOLANC, M.DTESTORNO, M.DTCOMPENSACAO, M.*
  FROM PCMOVCR M
 WHERE M.NUMTRANS IN (308481);
