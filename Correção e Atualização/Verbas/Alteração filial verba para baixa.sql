-------ANALISAR VERBAS QUE IREMOS ALTERAR A FILIAL---------------
SELECT * FROM PCVERBA WHERE NUMVERBA IN (1727);
SELECT * FROM PCMOVCRFOR WHERE NUMVERBA IN (1727);
SELECT * FROM PCAPLICVERBA WHERE NUMVERBA IN (1727);
SELECT * FROM PCAPLICVERBAI WHERE NUMVERBA IN (1727);
SELECT * FROM PCLOGVERBA WHERE NUMVERBA IN (1727);

-------ALTERAR O CODFILIAL NAS TABELAS PCVERBA, PCMOVCRFOR--------------
SELECT ROWID, V.*
  FROM PCVERBA V
 WHERE NUMVERBA IN (6958,
                    6959,
                    6960,
                    6970,
                    6971,
                    6972,
                    6996,
                    7005,
                    7009,
                    7010,
                    7011,
                    7012,
                    7013,
                    7014,
                    7015,
                    7017,
                    7018,
                    7019,
                    7020,
                    7021,
                    7035,
                    7036,
                    7050,
                    7052,
                    7053,
                    7054,
                    7059,
                    7077,
                    6982,
                    6980);
SELECT ROWID, V.*
  FROM PCMOVCRFOR V
 WHERE DTPAGO IS NULL
   AND NUMVERBA IN (6958,
                    6959,
                    6960,
                    6970,
                    6971,
                    6972,
                    6996,
                    7005,
                    7009,
                    7010,
                    7011,
                    7012,
                    7013,
                    7014,
                    7015,
                    7017,
                    7018,
                    7019,
                    7020,
                    7021,
                    7035,
                    7036,
                    7050,
                    7052,
                    7053,
                    7054,
                    7059,
                    7077,
                    6982,
                    6980);

----------rodar o recálculo da movimentação da verba------   
