-------ANALISAR VERBAS QUE IREMOS ALTERAR A FILIAL---------------
SELECT * FROM PCVERBA WHERE NUMVERBA IN (1727);
SELECT * FROM PCMOVCRFOR WHERE NUMVERBA IN (1727);
SELECT * FROM PCAPLICVERBA WHERE NUMVERBA IN (1727);
SELECT * FROM PCAPLICVERBAI WHERE NUMVERBA IN (1727);
SELECT * FROM PCLOGVERBA WHERE NUMVERBA IN (1727);

-------ALTERAR O CODFILIAL NAS TABELAS PCVERBA, PCMOVCRFOR--------------
SELECT ROWID, V.* FROM PCVERBA V WHERE NUMVERBA IN (7051);
SELECT ROWID, V.*
  FROM PCMOVCRFOR V
 WHERE DTPAGO IS NULL
   AND NUMVERBA IN (7051);

----------rodar o recálculo da movimentação da verba------   
