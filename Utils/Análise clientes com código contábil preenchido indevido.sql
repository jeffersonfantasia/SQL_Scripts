/*--Análise clientes com código contábil preenchido indevido--*/
SELECT C.CODCLI,
       C.CLIENTE,
       C.CODCLIPRINC,
       C.CODCONTAB,
       C.DTCADASTRO,
       C.DTPRIMCOMPRA
  FROM PCCLIENT C
  LEFT JOIN PCCOB B ON C.CODCLI = B.CODCLICC
 WHERE B.CODCLICC IS NULL
   AND C.CODCONTAB IS NOT NULL
   AND C.CODCLI NOT IN (
    9389
)
     /*ELAVON*/;
/
   
/*-------------------   */
UPDATE PCCLIENT
   SET CODCONTAB = NULL,
       CODCLIPRINC = NULL
 WHERE CODCONTAB = 8001;
/