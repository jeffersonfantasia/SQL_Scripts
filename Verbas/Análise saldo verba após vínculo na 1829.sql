SELECT ROTINALANC, PCMOVCRFOR.*
  FROM PCMOVCRFOR
 WHERE NUMVERBA = 1485
 ORDER BY NUMTRANSCRFOR;/
 
SELECT NUMTRANSENT, PCNFENT.* FROM PCNFENT WHERE NUMNOTA = 94007;/

SELECT DTMOVLOG, PUNITCONT, PLIQPED, QT
  FROM PCMOV
 WHERE NUMTRANSENT = 44462;/

SELECT PCOMPRA + VLIPI, QTPEDIDA FROM PCITEM WHERE NUMPED = 3730;/

SELECT * FROM PCITEMLOG WHERE NUMPED = 3730;/

SELECT ROTINALANC, NUMVERBA, PCMOVCRFOR.*
  FROM PCMOVCRFOR
 WHERE VALOR = '0.10'
   AND NUMVERBA = 0;/