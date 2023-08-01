CREATE MATERIALIZED VIEW MV_JF_ESTOQUE_DIARIO
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
     
CUSTO_PRODUTO_SP AS
 (SELECT F.CODPROD,
         F.CODFILIAL,
         NVL(ROUND((F.CUSTOREP * (1-FN_JF_TRANSFORMA_EM_PERCENTUAL(F.PERCDESC))),
                   4),
             0) CUSTO
    FROM PCPRODFILIAL F
    JOIN PRODUTOS_ESTRELA P ON F.CODPROD = P.CODPROD
   WHERE F.CODFILIAL IN ('2')),
CUSTO_PRODUTO_ES AS
 (SELECT F.CODPROD,
         F.CODFILIAL,
         NVL(ROUND((F.CUSTOREP * (1-FN_JF_TRANSFORMA_EM_PERCENTUAL(F.PERCDESC))),
                   4),
             0) CUSTO
    FROM PCPRODFILIAL F
    JOIN PRODUTOS_ESTRELA P ON F.CODPROD = P.CODPROD
   WHERE F.CODFILIAL IN ('11')),
   
COMPRA_FATURADO_SP AS --COMPRAS QUE FORAM FATURADAS PELA ESTRELA MAS NAO ENTREGUES
 (SELECT T.CODFILIAL, P.CODPROD, SUM(T.QT) QTCOMPRAFAT
    FROM PCMOVPREENT T
    JOIN PRODUTOS_ESTRELA P ON P.CODPROD = T.CODPROD
    LEFT JOIN PCMOV M ON M.NUMTRANSENT = T.NUMTRANSENT
   WHERE M.NUMTRANSENT IS NULL
     AND T.CODFILIAL IN ('2')
   GROUP BY T.CODFILIAL, P.CODPROD, P.PRODUTO),
COMPRA_FATURADO_ES AS --COMPRAS QUE FORAM FATURADAS PELA ESTRELA MAS NAO ENTREGUES
 (SELECT T.CODFILIAL, P.CODPROD, SUM(T.QT) QTCOMPRAFAT
    FROM PCMOVPREENT T
    JOIN PRODUTOS_ESTRELA P ON P.CODPROD = T.CODPROD
    LEFT JOIN PCMOV M ON M.NUMTRANSENT = T.NUMTRANSENT
   WHERE M.NUMTRANSENT IS NULL
     AND T.CODFILIAL IN ('11')
   GROUP BY T.CODFILIAL, P.CODPROD, P.PRODUTO),
   
ITENS_COMPRADOS AS --ITEM COMPRADOS PARA GERAR QT DE COMPRA
 (SELECT D.CODFILIAL,
         I.CODPROD,
         I.QTPEDIDA,
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
(SELECT C.CODFILIAL,
       C.CODPROD,
       SUM(NVL(C.QTPEDIDA, 0)) - SUM(NVL(C.QTENTREGUE, 0)) QTCOMPRAPEND
  FROM ITENS_COMPRADOS C
 WHERE C.QTPEDIDA <> C.QTENTREGUE
 AND C.CODFILIAL = '2'
 GROUP BY C.CODFILIAL, C.CODPROD),
PRODUTOS_COMPRADOS_PENDENTES_ES AS --ITENS COMPRADOS QUE AINDA N�O FORAM FATURADOS
(SELECT C.CODFILIAL,
       C.CODPROD,
       SUM(NVL(C.QTPEDIDA, 0)) - SUM(NVL(C.QTENTREGUE, 0)) QTCOMPRAPEND
  FROM ITENS_COMPRADOS C
 WHERE C.QTPEDIDA <> C.QTENTREGUE
 AND C.CODFILIAL = '11'
 GROUP BY C.CODFILIAL, C.CODPROD),
 
TRANSFERENCIA_PARA_SP AS
(SELECT M.CODPROD, M.QT
  FROM PCMOV M 
  LEFT JOIN PCNFENT E ON M.NUMTRANSVENDA = E.NUMTRANSVENDAORIG
 WHERE M.DTCANCEL IS NULL
 AND M.CODOPER = 'ST'
   AND M.STATUS = 'AB'
   AND M.CODFILIAL IN ('11')
   AND M.CODCLI IN (7543 )
   AND M.DTMOV >= '01/01/2023'
   AND E.NUMTRANSVENDAORIG IS NULL),
TRANSFERENCIA_PARA_ES AS
(SELECT M.CODPROD, M.QT
  FROM PCMOV M 
  LEFT JOIN PCNFENT E ON M.NUMTRANSVENDA = E.NUMTRANSVENDAORIG
 WHERE M.DTCANCEL IS NULL
 AND M.CODOPER = 'ST'
   AND M.STATUS = 'AB'
   AND M.CODFILIAL IN ('2')
   AND M.CODCLI IN (487414)
   AND M.DTMOV >= '01/01/2023'
   AND E.NUMTRANSVENDAORIG IS NULL),
   
ESTOQUE_PRODUTO AS --ESTOQUES DISPONIVEL E BLOQUEADOS DAS FILIAIS
 (SELECT E.CODFILIAL,
         E.CODPROD,
         E.QTESTGER,
         E.QTBLOQUEADA,
         E.QTINDENIZ,
         (E.QTBLOQUEADA - E.QTINDENIZ) QTBLOQ,
         E.QTRESERV,
         E.QTPENDENTE,
         E.CODDEVOL,
         (E.QTESTGER - E.QTRESERV - E.QTBLOQUEADA - E.QTPENDENTE) QTDISP
    FROM PCEST E
    JOIN PRODUTOS_ESTRELA P ON P.CODPROD = E.CODPROD
   WHERE E.CODFILIAL IN ('2', '7', '11')),
ESTOQUE_DISP_SP AS 
(SELECT E.CODPROD, E.QTDISP
   FROM ESTOQUE_PRODUTO E 
   WHERE E.CODFILIAL = '2'),
ESTOQUE_DISP_ES AS 
(SELECT E.CODPROD, E.QTDISP
   FROM ESTOQUE_PRODUTO E 
   WHERE E.CODFILIAL = '11'), 
ESTOQUE_DISP_ECOM AS 
(SELECT E.CODPROD, E.QTDISP
   FROM ESTOQUE_PRODUTO E 
   WHERE E.CODFILIAL = '7'),
ESTOQUE_BLOQ_SP AS 
(SELECT E.CODPROD, SUM(E.QTBLOQ) QTBLOQ
   FROM ESTOQUE_PRODUTO E 
   WHERE E.CODFILIAL = '2'
     AND NVL(E.CODDEVOL,9999) NOT IN (38,43,49)
     AND E.QTBLOQ > 0
GROUP BY E.CODPROD ),
ESTOQUE_BLOQ_ES AS 
(SELECT E.CODPROD, SUM(E.QTBLOQ) QTBLOQ
   FROM ESTOQUE_PRODUTO E 
   WHERE E.CODFILIAL = '11'
     AND NVL(E.CODDEVOL,9999) NOT IN (38,43,49)
     AND E.QTBLOQ > 0
GROUP BY E.CODPROD),
ESTOQUE_BLOQ_CORP AS 
(SELECT E.CODPROD, SUM(E.QTBLOQ) QTBLOQCORP
   FROM ESTOQUE_PRODUTO E 
   WHERE E.CODFILIAL IN ( '2', '11')
     AND E.CODDEVOL IN (38) 
GROUP BY E.CODPROD),
ESTOQUE_BLOQ_ECOM AS 
(SELECT E.CODPROD, SUM(E.QTBLOQ) QTBLOQECOM
   FROM ESTOQUE_PRODUTO E 
   WHERE E.CODFILIAL IN ( '2', '11')
     AND E.CODDEVOL IN (43,49) 
  GROUP BY E.CODPROD),
     
 ITENS_CATEIRA_VENDA AS --PRODUTOS VENDIDOS QUE NAO FORAM FATURADOS
 (SELECT I.CODFILIALRETIRA CODFILIAL,
        I.CODPROD,
        I.QT AS QTPENDENTE,
        (I.PVENDA * I.QT) AS VLPENDENTE
   FROM PCPEDI I
   JOIN PCPEDC C ON I.NUMPED = C.NUMPED
   JOIN PCSUPERV V ON C.CODSUPERVISOR = V.CODSUPERVISOR
  WHERE C.POSICAO NOT IN ('F', 'C')
    AND V.CODGERENTE IN (1, 8, 9, 10)
    AND I.CODFILIALRETIRA IN ('2', '11')),
CARTEIRA_VENDAS AS --CARTEIRA DE VENDAS POR PRODUTO
 (SELECT I.CODPROD,
       SUM(I.QTPENDENTE) QTVENDAPEND,
       SUM(I.QTPENDENTE) * ROUND(SUM(I.VLPENDENTE) / SUM(I.QTPENDENTE), 4) VLVENDAPEND
  FROM ITENS_CATEIRA_VENDA I
  WHERE I.CODFILIAL IN ('2', '11')
 GROUP BY I.CODPROD)

SELECT P.CODPROD,
       P.CODFAB,
       P.PRODUTO,
       P.EAN,
       P.LINHA,
       P.UNITCX,
       F.CUSTO CUSTO_SP,
       F2.CUSTO CUSTO_ES,
       C.QTCOMPRAFAT QTCOMPRAFAT_SP,
       C2.QTCOMPRAFAT QTCOMPRAFAT_ES,
       CP.QTCOMPRAPEND QTCOMPRAPEND_SP,
       CP2.QTCOMPRAPEND QTCOMPRAPEND_ES,
       T.QT QTTRANSF_SP,
       T2.QT QTTRANSF_ES,
       E1.QTDISP QTDISP_SP,
       E2.QTDISP QTDISP_ES,
       E4.QTBLOQ QTBLOQ_SP,
       E5.QTBLOQ QTBLOQ_ES,
       E3.QTDISP QTDISP_ECOM,
       E6.QTBLOQCORP QTBLOQ_CORP,
       E7.QTBLOQECOM QTBLOQ_ECOM,
       V.VLVENDAPEND
  FROM PRODUTOS_ESTRELA P
  LEFT JOIN CUSTO_PRODUTO_SP F ON F.CODPROD = P.CODPROD
  LEFT JOIN CUSTO_PRODUTO_ES F2 ON F2.CODPROD = P.CODPROD
  LEFT JOIN COMPRA_FATURADO_SP C ON C.CODPROD = P.CODPROD
  LEFT JOIN COMPRA_FATURADO_ES C2 ON C2.CODPROD = P.CODPROD
  LEFT JOIN PRODUTOS_COMPRADOS_PENDENTES_SP CP ON CP.CODPROD = P.CODPROD
  LEFT JOIN PRODUTOS_COMPRADOS_PENDENTES_ES CP2 ON CP2.CODPROD = P.CODPROD
  LEFT JOIN TRANSFERENCIA_PARA_SP T ON T.CODPROD = P.CODPROD
  LEFT JOIN TRANSFERENCIA_PARA_ES T2 ON T2.CODPROD = P.CODPROD
  LEFT JOIN ESTOQUE_DISP_SP E1 ON E1.CODPROD = P.CODPROD
  LEFT JOIN ESTOQUE_DISP_ES E2 ON E2.CODPROD = P.CODPROD
  LEFT JOIN ESTOQUE_DISP_ECOM E3 ON E3.CODPROD = P.CODPROD
  LEFT JOIN ESTOQUE_BLOQ_SP E4 ON E4.CODPROD = P.CODPROD
  LEFT JOIN ESTOQUE_BLOQ_ES E5 ON E5.CODPROD = P.CODPROD
  LEFT JOIN ESTOQUE_BLOQ_CORP E6 ON E6.CODPROD = P.CODPROD
  LEFT JOIN ESTOQUE_BLOQ_ECOM E7 ON E7.CODPROD = P.CODPROD
  LEFT JOIN CARTEIRA_VENDAS V ON V.CODPROD = P.CODPROD
