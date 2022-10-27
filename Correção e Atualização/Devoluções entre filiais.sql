--RELACAO VENDA ECOMMERCE PARA DEVOLUCAO ENTRE EMPRESAS-----
SELECT M.DTMOV,
       S.NUMNOTA,
       S.NUMTRANSVENDA,
       COUNT(M.CODPROD) OVER(PARTITION BY M.NUMTRANSVENDA) QT_ITENS,
       S.CODCLI,
       S.CLIENTE,
       S.CODUSUR,
       S.CODFILIAL,
       M.CODFILIALRETIRA,
       M.CODPROD,
       M.DESCRICAO,
       M.QT,
       M.PUNIT,
       S.VLFRETE,
       (CASE WHEN S.VLFRETE > 0 THEN 'FRETE' ELSE NULL END) FRETE,
       S.VLTOTAL,
       (SELECT 'S'
          FROM PCMOV V
         WHERE V.NUMTRANSDEV = M.NUMTRANSVENDA
           AND V.CODPROD = M.CODPROD) DEVOLUCAO
  FROM PCMOV M
  JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSVENDA
 WHERE S.CODFILIAL = '9'
   AND S.NUMNOTA IN (4888,5106) ----VER SE TEM FRETE PARA LANCAR
 ORDER BY M.CODFILIALRETIRA, M.CODPROD;
 
 
--PARA PEGAR A NOTA DE VENDA PARA GERAR A DEVOLU��O OTIMIZADA
WITH PRODUTOS_DEV AS
 (SELECT M.CODFILIALRETIRA, M.CODPROD, M.DESCRICAO, SUM(M.QT) QTSOMA
    FROM PCMOV M
    JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSVENDA
   WHERE S.CODFILIAL = '9'
     AND S.NUMNOTA IN (4888, 5106)
   GROUP BY M.CODFILIALRETIRA, M.CODPROD, M.DESCRICAO
   ORDER BY M.CODFILIALRETIRA)
SELECT COUNT(M.CODPROD) OVER(PARTITION BY NUMNOTA) QTPRODUTOS,
       M.QTDEVOL,
       M.CODPROD,
       M.DESCRICAO,
       M.QT,
       M.NUMNOTA
  FROM PCMOV M, PRODUTOS_DEV D
 WHERE D.CODFILIALRETIRA = M.CODFILIAL
   AND D.CODPROD = M.CODPROD
   AND D.QTSOMA <= (M.QT - NVL(QTDEVOL,0))
   AND M.CODFILIAL = '2'
   AND M.CODOPER = 'S'
   AND STATUS = 'AB'
   AND CODCLI = 400430 --AND M.CODPROD IN (815972,816341)
 ORDER BY QTPRODUTOS DESC, NUMNOTA, CODPROD; 
