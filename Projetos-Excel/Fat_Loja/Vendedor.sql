SELECT U.CODUSUR,
       U.USURDIRFV AS VENDEDOR
  FROM PCUSUARI U
 WHERE U.CODSUPERVISOR IN (5,13)
 ORDER BY U.CODUSUR;
/