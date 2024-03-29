SELECT E.CODFILIALNF,
       E.DTENTRADA,
       E.DTEMISSAO,
       E.NUMTRANSENT,
       E.VLICMS AS VLICMS_ENT,
       B.VLICMS AS VLICMS_BASE,
       B.GERAICMSLIVROFISCAL
  FROM PCNFBASE B
 INNER JOIN PCNFBASEENT E ON B.NUMTRANSENT = E.NUMTRANSENT
 WHERE E.ESPECIE = 'CT'
   AND E.CODFILIALNF IN ('5', '6', '9', '10')
   AND E.DTEMISSAO >= '01-JAN-2022'
   AND (B.GERAICMSLIVROFISCAL IS NULL OR B.GERAICMSLIVROFISCAL = 'S');
/
/*UPDATE PARA ATUALIZAÇÃO*/
UPDATE PCNFBASE SET GERAICMSLIVROFISCAL = 'N' WHERE EXISTS(
  SELECT E.CODFILIALNF,
         E.DTENTRADA,
         E.DTEMISSAO,
         E.NUMTRANSENT,
         E.VLICMS AS VLICMS_ENT,
         B.VLICMS AS VLICMS_BASE,
         B.GERAICMSLIVROFISCAL
    FROM PCNFBASE B
   INNER JOIN PCNFBASEENT E ON B.NUMTRANSENT = E.NUMTRANSENT
   WHERE E.ESPECIE = 'CT'
     AND E.CODFILIALNF IN ('5', '6', '9', '10')
     AND E.DTEMISSAO >= '01-JAN-2022'
     AND (B.GERAICMSLIVROFISCAL IS NULL OR B.GERAICMSLIVROFISCAL = 'S')
     AND E.NUMTRANSENT = PCNFBASE.NUMTRANSENT);
/
  SELECT E.CODFILIALNF,
         E.DTSAIDA,
         E.NUMTRANSVENDA,
         B.GERAICMSLIVROFISCAL,
         E.VLICMS AS VLICMS_SAID,
         B.VLICMS AS VLICMS_BASE
    FROM PCNFBASE B
   INNER JOIN PCNFBASESAID E ON B.NUMTRANSVENDA = E.NUMTRANSVENDA
   WHERE E.CODFILIALNF IN ('5', '6', '9', '10')
     AND (E.DTSAIDA <= '31-12-2018' OR E.DTSAIDA >= '01-01-2020')
     AND E.VLICMS > 0
     AND (B.GERAICMSLIVROFISCAL IS NULL OR B.GERAICMSLIVROFISCAL = 'S');
/

SELECT E.CODFILIALNF,
       E.DTENTRADA,
       E.DTEMISSAO,
       E.NUMTRANSENT,
       E.VLICMS AS VLICMS_ENT,
       B.VLICMS AS VLICMS_BASE,
       B.GERAICMSLIVROFISCAL
  FROM PCNFBASE B
 INNER JOIN PCNFBASEENT E ON B.NUMTRANSENT = E.NUMTRANSENT
 WHERE E.ESPECIE = 'CT'
   AND E.CODFILIALNF IN ('1', '2', '7', '8', '11', '12', '13')
   AND E.DTEMISSAO >= '01-JAN-2023'
   AND B.GERAICMSLIVROFISCAL = 'N';
	 
/*UPDATE PARA ATUALIZAÇÃO*/
MERGE INTO PCNFBASE B 
USING (
  SELECT E.CODFILIALNF,
       E.DTENTRADA,
       E.DTEMISSAO,
       E.NUMTRANSENT,
       E.VLICMS AS VLICMS_ENT,
       B.VLICMS AS VLICMS_BASE,
       B.GERAICMSLIVROFISCAL
  FROM PCNFBASE B
 INNER JOIN PCNFBASEENT E ON B.NUMTRANSENT = E.NUMTRANSENT
 WHERE E.ESPECIE = 'CT'
   AND E.CODFILIALNF IN ('1', '2', '7', '8', '11', '12', '13')
   AND E.DTEMISSAO >= '01-JAN-2023'
   AND B.GERAICMSLIVROFISCAL = 'N') X
	 ON (B.NUMTRANSENT = X.NUMTRANSENT)
	 WHEN MATCHED THEN
		 UPDATE SET B.GERAICMSLIVROFISCAL = 'S';
