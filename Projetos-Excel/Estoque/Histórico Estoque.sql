SELECT H.CODFILIAL,
       H.DATA,
       H.CODPROD,
       H.QTEST,
       H.QTESTGER
  FROM PCHISTEST H
  LEFT JOIN PCPRODUT P ON H.CODPROD = P.CODPROD
  LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
 WHERE H.CODFILIAL = 2
   AND H.DATA = TO_DATE ('31/12/2019', 'DD/MM/YYYY')
   AND F.CODFORNECPRINC = 2;
/