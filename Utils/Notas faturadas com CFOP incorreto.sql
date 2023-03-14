/*Notas faturadas com CFOP incorreto*/
SELECT *
  FROM (SELECT M.CODFILIAL,
               R.DESCRICAO AS REDE,
               M.CODCLI,
               C.CLIENTE,
               C.CGCENT,
               C.IEENT,
               M.NUMNOTA,
               M.NUMTRANSVENDA,
               M.DTMOV,
               M.CODPROD,
               P.DESCRICAO,
               M.CODFISCAL AS CFOP_NF,
               (CASE
                 WHEN (C.CONSUMIDORFINAL = 'S' AND M.CODFISCAL = 6102) THEN
                  6108
                 WHEN (C.CONSUMIDORFINAL = 'N' AND M.CODFISCAL = 6108) THEN
                  6102
                 ELSE
                  0
               END) AS CFOP_CORRETO
          FROM PCMOV M
          JOIN PCCLIENT C ON M.CODCLI = C.CODCLI
          LEFT JOIN PCREDECLIENTE R ON C.CODREDE = R.CODREDE
          LEFT JOIN PCPRODUT P ON M.CODPROD = P.CODPROD
         WHERE M.DTCANCEL IS NULL
           AND M.DTMOV >= TRUNC(SYSDATE) - 30
           AND M.CODFILIAL IN ('2', '5', '6', '7', '9', '10')
           AND M.CODFISCAL IN (6102, 6108))
 WHERE CFOP_CORRETO <> CFOP_NF
   AND CFOP_CORRETO <> 0;
