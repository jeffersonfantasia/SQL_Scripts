SELECT DTEMISSAO,
       CODFILIAL,
       SUM (VALOR) VALOR
  FROM PCPREST
 WHERE CODCOB = 'CONV'
 GROUP BY DTEMISSAO,
          CODFILIAL;
/