--CORRE��O CLIENTES
SELECT C.ROWID,
       C.CONSUMIDORFINAL,
       C.CONTRIBUINTE,
       C.CALCULAST,
       C.CGCENT,
       C.IEENT,
       C.CODCLIPRINC,
       C.*
  FROM PCCLIENT C
 WHERE C.CODCLI = 459656  
       --C.CGCENT = '052718148-07'
       --C.CLIENTE LIKE 'PAYMEE%'
       ;
