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
       (CASE
         WHEN S.VLFRETE > 0 THEN
          'FRETE'
         ELSE
          NULL
       END) FRETE,
       S.VLTOTAL,
       (SELECT COUNT(1)
          FROM PCMOV V
         WHERE V.NUMTRANSDEV = M.NUMTRANSVENDA
           AND V.CODPROD = M.CODPROD
           AND V.DTCANCEL IS NULL) DEVOLUCAO --VER SE POSSUI MAIS DO QUE 1 DEVOLU��O PARA MESMA NOTA
  FROM PCMOV M
  JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSVENDA
 WHERE S.CODFILIAL = &codfilial
   AND S.NUMNOTA IN (&numnota)
----VER SE TEM FRETE PARA LANCAR
 ORDER BY M.CODFILIALRETIRA, S.CLIENTE, M.CODPROD;

----CONSOLIDA PRODUTOS POR FILIAL
SELECT M.CODFILIALRETIRA, M.CODPROD, M.DESCRICAO, SUM(M.QT) QTSOMA
  FROM PCMOV M
  JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSVENDA
 WHERE S.CODFILIAL = &codfilial
   AND S.NUMNOTA IN (&numnota) 
	 AND M.CODPROD IN (&codprod)
 GROUP BY M.CODFILIALRETIRA, M.CODPROD, M.DESCRICAO
 ORDER BY M.CODFILIALRETIRA;

--PARA PEGAR A NOTA DE VENDA PARA GERAR A DEVOLU��O OTIMIZADA
WITH PRODUTOS_DEV AS
 (SELECT M.CODFILIALRETIRA, M.CODPROD, M.DESCRICAO, SUM(M.QT) QTSOMA
    FROM PCMOV M
    JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSVENDA
   WHERE S.CODFILIAL = &codfilial
     AND S.NUMNOTA IN (&numnota)
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
   AND D.QTSOMA <= (M.QT - NVL(QTDEVOL, 0))
   AND M.CODFILIAL = &codfilialretira
   AND M.CODOPER = 'S'
   AND STATUS = 'AB'
   AND CODCLI = &codcli
   AND M.CODPROD IN ( &codprod )
 ORDER BY QTPRODUTOS DESC, NUMNOTA, CODPROD;

----CREDITOS E VERBAS
SELECT *
  FROM (SELECT C.CODFILIAL,
               'CREDITO' TIPO,
               (SELECT E.NUMNOTA
                  FROM PCNFENT E
                 WHERE E.NUMTRANSENT = C.NUMTRANSENTDEVCLI) NUMNOTADEV,
               C.CODIGO NUMERO,
               C.DTLANC,
               C.CODCLI CODIGO,
               T.CLIENTE EMPRESA,
               C.VALOR
          FROM PCCRECLI C
          JOIN PCCLIENT T ON T.CODCLI = C.CODCLI
         WHERE C.CODCLI = &codcli
           AND C.DTLANC = TRUNC(SYSDATE)
           AND C.DTDESCONTO IS NULL
        UNION
        SELECT V.CODFILIAL,
               'VERBA' TIPO,
               V.NUMNOTA NUMNOTADEV,
               V.NUMVERBA NUMERO,
               V.DTEMISSAO DTLANC,
               V.CODFORNEC CODIGO,
               F.FORNECEDOR EMPRESA,
               V.VALOR
          FROM PCVERBA V
          LEFT JOIN PCMOVCRFOR M ON M.NUMVERBA = V.NUMVERBA
                                AND M.TIPO = 'C'
          JOIN PCFORNEC F ON F.CODFORNEC = V.CODFORNEC
         WHERE V.CODFILIAL = &codfilial
           AND V.CODFORNEC IN (7543, 9505)
           AND V.DTEMISSAO = TRUNC(SYSDATE)
           AND M.NUMVERBA IS NULL)
 ORDER BY VALOR, CODFILIAL;

SELECT * FROM PCMOVCRFOR M WHERE M.NUMVERBA = 6480;
SELECT * FROM PCCRECLI C WHERE C.CODIGO = 46965;
