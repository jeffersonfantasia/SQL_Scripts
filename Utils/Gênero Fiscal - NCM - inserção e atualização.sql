/*-----INSER��O DO G�NERO FISCAL NCM NOS PRODUTOS NULOS------*/
SELECT * FROM PCPRODUT WHERE PCPRODUT.CODGENEROFISCAL IS NULL;
--UPDATE
UPDATE PCPRODUT
   SET PCPRODUT.CODGENEROFISCAL = SUBSTR(NBM, 1, 2)
 WHERE PCPRODUT.CODGENEROFISCAL IS NULL;

/*-----CORRE��O DO G�NERO FISCAL NCM------*/
SELECT * FROM PCPRODUT WHERE PCPRODUT.CODGENEROFISCAL <> SUBSTR(NBM, 1, 2);
--UPDATE
UPDATE PCPRODUT
   SET PCPRODUT.CODGENEROFISCAL = SUBSTR(NBM, 1, 2)
 WHERE PCPRODUT.CODGENEROFISCAL <> SUBSTR(NBM, 1, 2);
