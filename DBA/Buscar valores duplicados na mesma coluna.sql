SELECT PCNFENT.NUMTRANSENT,
       COUNT (*)
  FROM PCNFENT
 GROUP BY NUMTRANSENT
HAVING COUNT (*) > 1;