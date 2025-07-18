--TRAZER TODAS AS COMPRAS DO CORPORATIVO--
WITH COMPRAS AS
 (SELECT I.NUMPED,
         I.CODPROD,
         NVL(I.QTPEDIDA, 0) QTPEDIDA,
         NVL(I.QTENTREGUE, 0) QTENTREGUE,
         (CASE
           WHEN NVL(I.QTENTREGUE, 0) > I.QTPEDIDA THEN
            I.QTPEDIDA
           ELSE
            NVL(I.QTENTREGUE, 0)
         END) QTENTREGUE_CORRETO
    FROM PCPEDIDO P
   INNER JOIN PCITEM I ON P.NUMPED = I.NUMPED
   WHERE P.CODCOMPRADOR = 47
   GROUP BY I.NUMPED,
            I.CODPROD,
            I.QTPEDIDA,
            I.QTENTREGUE),

--AGRUPAR COMPRAS POR PRODUTO, TRAZENDO O PENDENTE--
COMPRA_PENDENTE AS
 (SELECT CODPROD,
         SUM(QTPEDIDA - NVL(QTENTREGUE_CORRETO, 0)) AS QT_PENDENTE
    FROM COMPRAS
  HAVING SUM(QTPEDIDA - NVL(QTENTREGUE_CORRETO, 0)) > 0
   GROUP BY CODPROD),

--AGRUPAR VENDAS POR PRODUTO--
PEDIDO_VENDA AS
 (SELECT I.CODPROD,
         P.CODFAB,
         P.TIPOMERC,
         SUM(NVL(I.QT, 0)) AS QT_VENDIDA
    FROM PCPEDI I
   INNER JOIN PCPEDC C ON I.NUMPED = C.NUMPED
    LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
   WHERE I.POSICAO IN ('B', 'P', 'L', 'M') --OLHAR PEDIDOS QUE N�O ESTEJAM FATURADOS OU CANCELADO
     AND I.CODUSUR = 14 --SOMENTE PUXAR VENDAS DO VENDEDOR CORPORATIVO
     AND C.CONDVENDA NOT IN (7) --N�O CONSIDERAR ESTOQUE DE VENDA TV 7
   GROUP BY I.CODPROD,
            P.CODFAB,
            P.TIPOMERC),

--INFORMA�OES DOS PRODUTOS KIT--
KIT AS
 (SELECT F.CODPRODACAB,
         F.CODPRODMP,
         NVL(F.QTPRODMP, 0) QTPRODMP
    FROM PCFORMPROD F),

--VERIFICACAO DOS KITS NO PEDIDO--
PEDIDOS_TRATADOS AS
 (SELECT CODPROD,
         CODFAB,
         SUM(QT_VENDIDA) QT_VENDIDA
    FROM (SELECT (CASE
                   WHEN P.TIPOMERC IN ('CB', 'KT') THEN
                    K.CODPRODMP
                   ELSE
                    P.CODPROD
                 END) AS CODPROD,
                 P.CODFAB,
                 (CASE
                   WHEN P.TIPOMERC IN ('CB', 'KT') THEN
                    (QT_VENDIDA * QTPRODMP)
                   ELSE
                    QT_VENDIDA
                 END) AS QT_VENDIDA
            FROM PEDIDO_VENDA P
            LEFT JOIN KIT K ON P.CODPROD = K.CODPRODACAB)
   GROUP BY CODPROD,
            CODFAB),

--ANALISE DO ESTOQUE ATUAL--
ESTOQUE_ATUAL AS
 (SELECT E.CODPROD,
         SUM(NVL(E.QTESTGER, 0)) QTESTGER,
         SUM(NVL(E.QTRESERV, 0)) AS QTRESERV,
         SUM((NVL(E.QTESTGER, 0) - NVL(E.QTRESERV, 0))) AS QTDISPONIVEL
    FROM PCEST E
   WHERE E.CODFILIAL IN (11)
   GROUP BY E.CODPROD),

--ANALISE DO ESTOQUE BLOQUEADO MOTIVO CORPORATIVO--
ESTOQUE_BLOQ_CORP AS
 (SELECT E.CODPROD,
         SUM(NVL(E.QTBLOQUEADA, 0)) QTBLOQCORP
    FROM PCEST E
   WHERE E.CODFILIAL IN (11)
     AND E.CODDEVOL = 38
   GROUP BY E.CODPROD)

--CONSOLIDAR INFORMA��ES--
SELECT T.*,
       (CASE
         WHEN (QTDISPONIVEL <> 0 AND QTRESERV <> 0) THEN
          QT_VENDIDA - QTESTGER - QT_PENDENTE
         WHEN QTDISPONIVEL <> 0 THEN
          QT_VENDIDA - QTDISPONIVEL - QT_PENDENTE
         ELSE
          QT_VENDIDA - QTRESERV - QT_PENDENTE
       END) QT_FALTA
  FROM (SELECT F.CODFORNEC,
               F.FORNECEDOR,
               I.CODPROD,
               I.CODFAB,
               P.DESCRICAO,
               I.QT_VENDIDA,
               NVL(C.QT_PENDENTE, 0) QT_PENDENTE,
               E.QTESTGER,
               NVL(B.QTBLOQCORP, 0) QTBLOQCORP,
               E.QTRESERV,
               E.QTDISPONIVEL
          FROM PEDIDOS_TRATADOS I
          JOIN ESTOQUE_ATUAL E ON I.CODPROD = E.CODPROD
          JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
          LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
          LEFT JOIN COMPRA_PENDENTE C ON I.CODPROD = C.CODPROD
          LEFT JOIN ESTOQUE_BLOQ_CORP B ON B.CODPROD = I.CODPROD
         ORDER BY F.FORNECEDOR,
                  P.DESCRICAO) T
