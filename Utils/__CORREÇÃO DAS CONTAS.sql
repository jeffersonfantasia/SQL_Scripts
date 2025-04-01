/*CORRE��O DAS CONTAS */
/*BUSCAR O FORNECEDOR NA PCNFENT*/
SELECT E.DTLANCTO,
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
       E.*,
       ROWID
  FROM PCNFENT E
 WHERE 1 = 1
   --AND NUMTRANSENT IN (1821647) 
   AND NUMNOTA IN (149043) 
 --AND CODFORNEC = 10362    
  --AND E.DTENT >= '01/12/2024'
--AND E.CODCONT = 3201
 ORDER BY E.DTENT DESC;
;
/*CONSULTAR NA PCLANC NUMNOTA*/
SELECT L.NOMEFUNC,
       L.CODCONTA,
       L.RECNUMPRINC, L.RECNUM, L.VLIRRF, L.VLISS, L.VLINSS, L.VALOR,
       L.DTCOMPETENCIA,
       L.DTEMISSAO,
       L.NUMNOTA,
       L.DTESTORNOBAIXA,
       L.NUMTRANS,
       L.DTPAGTO,
       L.TIPOPARCEIRO,
       L.DTCOMPETENCIA,
       L.FORNECEDOR,
       L.NUMBANCO,
       L.*,
       L.ROWID
  FROM PCLANC L
  LEFT JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
 WHERE 1 = 1
   AND L.NUMNOTA IN (9021770782 ,9021849232) 
     --AND (CODFORNEC IN (9203) AND TIPOPARCEIRO = 'F')
      --AND L.DTDESD IS NULL
   AND M.DTESTORNO IS NULL
      --AND L.DTLANC >= '01/10/2024' 
  --AND L.DTCOMPETENCIA >= '01/12/2024'
 ORDER BY L.DTLANC DESC,
          L.NUMNOTA;

SELECT * FROM PCLANCLOG L WHERE CODFORNEC = 10624 OR L.NUMNOTA = 2259 ORDER BY L.DATA_GRAVACAO DESC;
SELECT * FROM PCLANCLOG L  ORDER BY L.DATA_GRAVACAO DESC;

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
 WHERE L.RECNUM IN (7154299)
--L.NUMTRANS IN (547011, 545853)
;

/*CONSULTAR NA PCMOVCR NUMTRANS*/
SELECT M.ROWID,
       M.DTESTORNOLANC,
       M.DTESTORNO,
       M.DTCOMPENSACAO,
       M.*
  FROM PCMOVCR M
 WHERE 1 = 1
      --AND M.NUMTRANS IN (419882)
   AND NUMCARR = 6374195;

SELECT * FROM PCLANC L WHERE L.NUMTRANS = 547011;

SELECT * FROM PCRATEIOCENTROCUSTO C WHERE C.RECNUM = 7055475;

SELECT NUMNOTA,
       CODCONT,
       CODFORNEC,
       VLTOTAL,
       COUNT(NUMTRANSENT)
  FROM PCNFENT E
 WHERE ESPECIE <> 'OE'
   AND CODCONT = 100002
 GROUP BY NUMNOTA,
          CODCONT,
          CODFORNEC,
          VLTOTAL
HAVING COUNT(NUMTRANSENT) > 1;

SELECT E.*
  FROM PCNFENT E
 WHERE ESPECIE <> 'OE'
   AND E.NUMNOTA = 69;
