/*MUDAR PARA 9185 PACER*/
SELECT ROWID,
       L.CODFORNEC,L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 9712
   AND DTPAGTO >= '01-JAN-2023' ;

/*MUDAR PARA 9298 PAULINERES*/ 
SELECT ROWID,
       L.CODFORNEC, L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC IN ( 7902, 9803)
   AND DTPAGTO >= '01-JAN-2023';

/*MUDAR PARA 7607 RODONAVES*/ 
SELECT ROWID,
       L.CODFORNEC,L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 8166
   AND DTPAGTO >= '01-JAN-2023';
	 
/*MUDAR PARA 8210 JAMEF*/ 
SELECT ROWID,
       L.CODFORNEC,L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 358
   AND DTPAGTO >= '01-JAN-2023';
 
 /*MUDAR PARA 10118 NPJ*/
SELECT ROWID,
       L.CODFORNEC,L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 7353
   AND DTPAGTO >= '01-JAN-2023';
 
/*MUDAR PARA 8965 PAULISTA*/ 
SELECT ROWID,
       E.CODCONT, E.CODFUNCLANC,
       E.CODFILIAL,
       E.CODFILIALNF,
       E.CODFORNEC,
       E.CODFORNECNF,
       E.NUMTRANSENT,
       E.VLST,
       E.VLOUTRAS,
       E.*
  FROM PCNFENT E
 WHERE CODFORNEC = 129
       ORDER BY DTENT;
			 
/*MUDAR PARA 10375 MANHATTAN
SELECT ROWID,
       L.CODFORNEC,L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 10303
   AND DTPAGTO >= '01-JAN-2023'; */  
	 
/*MUDAR PARA 9735 PAJUCARA*/  	 
SELECT ROWID,
       L.CODFORNEC,L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 9035 AND CODROTINABAIXA NOT IN (1206)
   AND DTPAGTO >= '01-JAN-2024';

/*MUDAR PARA 10512 TTJB TRANSPORTES E LOGISTICA LTDA*/  	 
SELECT ROWID,
       L.CODFORNEC,L.FORNECEDOR,
       L.*
  FROM PCLANC L
 WHERE CODFORNEC = 10517 AND CODROTINABAIXA NOT IN (1206)
   AND DTPAGTO >= '01-JAN-2024';

--UPDATE
/*UPDATE PCNFENT
   SET CODFORNEC = 8965, CODFORNECNF = 8965
 WHERE CODFORNEC = 129;*/
