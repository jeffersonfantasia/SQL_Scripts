CREATE MATERIALIZED VIEW MV_JF_ESTOQUE_CONSOLIDADO
REFRESH FORCE ON DEMAND
START WITH SYSDATE NEXT SYSDATE + 1/1152
AS
WITH PRODUTOS_ESTRELA AS --PRODUTOS ESTRELA
 (SELECT DISTINCT P.CODPRODMASTER AS CODPROD,
                  P.CODFAB,
                  P.DESCRICAO PRODUTO,
                  P.CODAUXILIAR EAN,
                  L.DESCRICAO AS LINHA,
                  P.QTUNITCX UNITCX
    FROM PCPRODUT P
    LEFT JOIN PCLINHAPROD L ON P.CODLINHAPROD = L.CODLINHA
    LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
   WHERE F.CODFORNECPRINC = 2
     AND P.DTEXCLUSAO IS NULL
     AND NVL(P.OBS, '00') NOT IN ('FL')
     AND P.CODPROD = P.CODPRODMASTER),
COMPRA_FATURADO_SP AS --COMPRAS QUE FORAM FATURADAS PELA ESTRELA MAS NAO ENTREGUES
 (SELECT SUM(T.QT * T.PUNIT) VLCOMPRAFAT_SP
    FROM PCMOVPREENT T
    JOIN PRODUTOS_ESTRELA P ON P.CODPROD = T.CODPROD
    LEFT JOIN PCMOV M ON M.NUMTRANSENT = T.NUMTRANSENT
   WHERE M.NUMTRANSENT IS NULL
     AND T.CODFILIAL IN ('2')),
COMPRA_FATURADO_ES AS --COMPRAS QUE FORAM FATURADAS PELA ESTRELA MAS NAO ENTREGUES
 (SELECT SUM(T.QT * T.PUNIT) VLCOMPRAFAT_ES
    FROM PCMOVPREENT T
    JOIN PRODUTOS_ESTRELA P ON P.CODPROD = T.CODPROD
    LEFT JOIN PCMOV M ON M.NUMTRANSENT = T.NUMTRANSENT
   WHERE M.NUMTRANSENT IS NULL
     AND T.CODFILIAL IN ('11')),

ITENS_COMPRADOS AS --ITEM COMPRADOS PARA GERAR QT DE COMPRA
 (SELECT D.CODFILIAL,
         I.CODPROD,
         I.QTPEDIDA,
         I.PLIQUIDO,
         (CASE
           WHEN I.QTENTREGUE > I.QTPEDIDA THEN
            I.QTPEDIDA
           ELSE
            I.QTENTREGUE
         END) AS QTENTREGUE
    FROM PCITEM I
    JOIN PCPEDIDO D ON I.NUMPED = D.NUMPED
    JOIN PRODUTOS_ESTRELA P ON P.CODPROD = I.CODPROD
   WHERE D.CODFILIAL IN ('2', '11')),
PRODUTOS_COMPRADOS_PENDENTES_SP AS --ITENS COMPRADOS QUE AINDA N�O FORAM FATURADOS
 (SELECT ROUND(SUM((NVL(C.QTPEDIDA, 0) - NVL(C.QTENTREGUE, 0)) * C.PLIQUIDO),
               2) VLCOMPRA_SP
    FROM ITENS_COMPRADOS C
   WHERE C.QTPEDIDA <> C.QTENTREGUE
     AND C.CODFILIAL = '2'),
PRODUTOS_COMPRADOS_PENDENTES_ES AS --ITENS COMPRADOS QUE AINDA N�O FORAM FATURADOS
 (SELECT ROUND(SUM((NVL(C.QTPEDIDA, 0) - NVL(C.QTENTREGUE, 0)) * C.PLIQUIDO),
               2) VLCOMPRA_ES
    FROM ITENS_COMPRADOS C
   WHERE C.QTPEDIDA <> C.QTENTREGUE
     AND C.CODFILIAL = '11'),

TRANSFERENCIA_PARA_SP AS
 (SELECT NVL(ROUND(SUM(M.QT * M.PUNIT), 2), 0) VLTRANSF_SP
    FROM PCMOV M
    LEFT JOIN PCNFENT E ON M.NUMTRANSVENDA = E.NUMTRANSVENDAORIG
   WHERE M.DTCANCEL IS NULL
     AND M.CODOPER = 'ST'
     AND M.STATUS = 'AB'
     AND M.CODFILIAL IN ('11')
     AND M.CODCLI IN (7543)
     AND M.DTMOV >= '01/01/2023'
     AND E.NUMTRANSVENDAORIG IS NULL),
TRANSFERENCIA_PARA_ES AS
 (SELECT NVL(ROUND(SUM(M.QT * M.PUNIT), 2), 0) VLTRANSF_ES
    FROM PCMOV M
    LEFT JOIN PCNFENT E ON M.NUMTRANSVENDA = E.NUMTRANSVENDAORIG
   WHERE M.DTCANCEL IS NULL
     AND M.CODOPER = 'ST'
     AND M.STATUS = 'AB'
     AND M.CODFILIAL IN ('2')
     AND M.CODCLI IN (487414)
     AND M.DTMOV >= '01/01/2023'
     AND E.NUMTRANSVENDAORIG IS NULL),
PEDIDO_TRANSF_SP AS
 (SELECT NVL(ROUND(SUM(SUM(I.QT * I.PVENDA)),2),0) VLPEDTRANSF_SP
    FROM PCPEDI I
    LEFT JOIN PCPEDC C ON C.NUMPED = I.NUMPED
   WHERE C.POSICAO NOT IN ('C', 'F')
     AND C.CONDVENDA = 10
     AND C.CODFILIAL IN ('11')
     AND C.CODCLI IN (7543)
   GROUP BY I.CODPROD),
PEDIDO_TRANSF_ES AS
 (SELECT NVL(ROUND(SUM(SUM(I.QT * I.PVENDA)),2),0)  VLPEDTRANSF_ES
    FROM PCPEDI I
    LEFT JOIN PCPEDC C ON C.NUMPED = I.NUMPED
   WHERE C.POSICAO NOT IN ('C', 'F')
     AND C.CONDVENDA = 10
     AND C.CODFILIAL IN ('2')
     AND C.CODCLI IN (487414)
   GROUP BY I.CODPROD),

ESTOQUE_PRODUTO AS --ESTOQUES DISPONIVEL E BLOQUEADOS DAS FILIAIS
 (SELECT E.CODFILIAL,
         E.CODPROD,
         E.CUSTOREP,
         E.QTESTGER,
         (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA - E.QTPENDENTE) QTDISP
    FROM PCEST E
    JOIN PRODUTOS_ESTRELA P ON P.CODPROD = E.CODPROD
   WHERE E.CODFILIAL IN ('2', '11')),
ESTOQUE_DISP_SP AS
 (SELECT NVL(ROUND(SUM((E.QTDISP * E.CUSTOREP)), 2), 0) VLDISP_SP
    FROM ESTOQUE_PRODUTO E
   WHERE E.CODFILIAL = '2'
     AND E.QTDISP > 0),
ESTOQUE_DISP_ES AS
 (SELECT NVL(ROUND(SUM((E.QTDISP * E.CUSTOREP)), 2), 0) VLDISP_ES
    FROM ESTOQUE_PRODUTO E
   WHERE E.CODFILIAL = '11'
     AND E.QTDISP > 0),
ESTOQUE_TOTAL_SP AS
 (SELECT NVL(ROUND(SUM((E.QTESTGER * E.CUSTOREP)), 2), 0) VLTOTAL_SP
    FROM ESTOQUE_PRODUTO E
   WHERE E.CODFILIAL = '2'
     AND E.QTESTGER > 0),
ESTOQUE_TOTAL_ES AS
 (SELECT NVL(ROUND(SUM((E.QTESTGER * E.CUSTOREP)), 2), 0) VLTOTAL_ES
    FROM ESTOQUE_PRODUTO E
   WHERE E.CODFILIAL = '11'
     AND E.QTESTGER > 0)

SELECT SYSDATE AS LASTREFRESH,
       C.VLCOMPRAFAT_SP,
       C2.VLCOMPRAFAT_ES,
       (NVL(P.VLCOMPRA_SP,0) - NVL(C.VLCOMPRAFAT_SP,0)) VLCOMPRA_SP,
       (NVL(P2.VLCOMPRA_ES,0) - NVL(C2.VLCOMPRAFAT_ES,0)) VLCOMPRA_ES,
       T.VLTRANSF_SP,
       T2.VLTRANSF_ES,
       PT.VLPEDTRANSF_SP,
       PT2.VLPEDTRANSF_ES,
       D.VLDISP_SP,
       D2.VLDISP_ES,
       E.VLTOTAL_SP,
       E2.VLTOTAL_ES
  FROM COMPRA_FATURADO_SP C,
       COMPRA_FATURADO_ES C2,
       PRODUTOS_COMPRADOS_PENDENTES_SP P,
       PRODUTOS_COMPRADOS_PENDENTES_ES P2,
       TRANSFERENCIA_PARA_SP T,
       TRANSFERENCIA_PARA_ES T2,
       PEDIDO_TRANSF_SP PT,
       PEDIDO_TRANSF_ES PT2,
       ESTOQUE_DISP_SP D,
       ESTOQUE_DISP_ES D2,
       ESTOQUE_TOTAL_SP E,
       ESTOQUE_TOTAL_ES E2
