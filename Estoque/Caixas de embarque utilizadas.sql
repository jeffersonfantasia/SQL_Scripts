SELECT M.CODPROD,
       P.DESCRICAO,
       SUM (QT) QT_TOTAL_USADA
  FROM PCMOV M,
       PCPRODUT P
 WHERE M.CODPROD = P.CODPROD
   AND M.CODEPTO = 97
   AND DTMOV > '01-JAN-2019'
   AND P.DESCRICAO LIKE 'CAIXA%'
   AND M.CODOPER = 'SM'
 GROUP BY M.CODPROD,
          P.DESCRICAO
 ORDER BY QT_TOTAL_USADA DESC;
/
SELECT M.DTMOV,
       M.CODPROD,
       P.DESCRICAO,
       QT
  FROM PCMOV M,
       PCPRODUT P
 WHERE M.CODPROD = P.CODPROD
   AND M.CODEPTO = 97
   AND DTMOV BETWEEN '01-JUL-2018' AND '31-DEC-2018'
   AND P.DESCRICAO LIKE 'CAIXA%'
   AND M.CODOPER = 'SM'
 ORDER BY QT DESC;
/