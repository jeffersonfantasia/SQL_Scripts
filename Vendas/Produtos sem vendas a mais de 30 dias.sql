SELECT PCEST.CODFILIAL,
       PCPRODUT.CODPROD,
       PCPRODUT.DESCRICAO,
       PCPRODUT.CODAUXILIAR,
       PCEST.DTULTENT,
       TRUNC (PCEST.DTULTSAIDA) AS DTSAIDA,
       TRUNC (SYSDATE) - TRUNC (PCEST.DTULTSAIDA) DIASSEMVENDA,
       NVL (PCEST.QTESTGER, 0) AS QTESTOQUE,
       NVL (PCEST.QTINDENIZ, 0) AS AVARIA,
       NVL (PCEST.QTBLOQUEADA, 0) - NVL (PCEST.QTINDENIZ, 0) AS BLOQUEADA
  FROM PCPRODUT,
       PCEST,
       PCFORNEC,
       PCDEPTO,
       PCFILIAL,
       PCMARCA
 WHERE PCPRODUT.CODPROD = PCEST.CODPROD
   AND PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
   AND PCPRODUT.CODMARCA = PCMARCA.CODMARCA (+)
   AND PCPRODUT.CODEPTO = PCDEPTO.CODEPTO
   AND PCFILIAL.CODIGO = PCEST.CODFILIAL
   AND PCPRODUT.CODEPTO IS NOT NULL
   AND PCPRODUT.CODPROD = 3871
   AND NVL (PCEST.QTESTGER, 0) > 0
   AND PCEST.DTULTSAIDA < (SYSDATE) - 30
 ORDER BY 6
/