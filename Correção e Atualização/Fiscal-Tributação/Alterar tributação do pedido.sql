SELECT B.ROWID,
       B.CODST CODST_CORRETO,
       I.CODST CODST_PEDIDO,
       I.NUMPED,
       I.CODPROD,
       I.DATA,
       I.CODCLI,
       I.CODUSUR,
       I.QT,
       I.PVENDA,
       I.ST,
       I.NUMSEQ
  FROM PCPEDI I,
       PCTABTRIB B
 WHERE I.CODPROD = B.CODPROD
   AND B.CODFILIALNF = '6'
   AND B.UFDESTINO = 'SP'
   AND I.NUMPED = 14004242;