/************************************************************************************************************************************
    ESTRUTURA DO CÓDIGO

1. HIST_ESTOQUE: Traz a informação dos produtos com estoque maior do que zero na data informada
2. NOTAS_ENTRADA: Traz a informação das notas de compra, entrada de transferencia, entrada de devolução, entrada de bonificação e simples remessa
3. NOTAS_COM_ACUMULADO: 
   3.1 Faz o JOIN entre estoque e notas
   3.2 Adiciona função analítica SUM() OVER() para calcular soma acumulada das quantidades
   3.3 Ordenação DECRESCENTE por DTENT DESC, NUMTRANSACAO DESC (da mais recente para a mais antiga)
4. SELECT FINAL: 
   4.1 Filtra apenas as notas onde a soma acumulada é ≤ ao estoque final Ou onde a nota atual "estoura" o estoque (pegando a última nota necessária)
   4.2 Mantém ordenação decrescente
   4.3 Assim pegamos todas as notas até completar o estoque e incluímos a última nota que "completa" o estoque, mesmo que parcialmente

************************************************************************************************************************************/

WITH HIST_ESTOQUE AS
 (SELECT H.CODFILIAL,
         H.DATA,
         H.CODPROD,
         H.CUSTOCONT,
         NVL(H.QTEST, 0) QTEST,
         ROUND(H.QTEST, 3) * ROUND(H.CUSTOCONT, 3) VLESTOQUE
    FROM PCHISTEST H
    LEFT JOIN PCFILIAL F ON F.CODIGO = H.CODFILIAL
   WHERE 0 = 0
     AND NVL(H.TIPOMERCDEPTO, 'X') <> 'IM'
     AND NVL(H.TIPOMERCDEPTO, 'X') <> 'CI'
     AND NVL(H.TIPOMERC, 'X') NOT IN ('MC', 'ME', 'PB')
     AND ROUND(H.QTEST, 3) > 0
     AND ROUND(H.CUSTOCONT, 3) > 0
        ----PARAMETROS
     AND H.DATA = TO_DATE('31/12/2025', 'DD/MM/YYYY')
     AND H.CODFILIAL = '1'),
NOTAS_ENTRADA AS
 (SELECT N.CODFILIAL,
         N.NUMTRANSACAO,
         E.DTEMISSAO,
         E.DTENT,
         E.NUMNOTA,
         E.FORNECEDOR,
         E.CHAVENFE,
         N.CODPROD,
         N.QTCONT QT_COMPRA,
         N.PUNITCONT PUNIT,
         N.VLCONTABIL VLNF_COMPRA,
         N.CODFISCAL,
         N.VLBASEICMS,
         N.PERCICM,
         N.VLICMS,
         N.VLBASEICMSST,
         N.VLST,
         N.VLSTGUIA,
         M.BASEBCR
    FROM V_ITEM_NOTAFISCAL N
    JOIN PCNFENT E ON E.NUMTRANSENT = N.NUMTRANSACAO
    JOIN PCMOV M ON M.NUMTRANSENT = N.NUMTRANSACAO
                AND M.CODPROD = N.CODPROD
   WHERE 1 = 1
     AND N.CODOPER IN ('E', 'ET', 'ED', 'EB', 'ER')
     AND N.CODFILIAL = '1'
     AND N.NUMTRANSACAO IS NOT NULL),
NOTAS_COM_ACUMULADO AS
 (SELECT H.CODFILIAL,
         H.CODPROD,
         H.QTEST QT_ESTOQUE_FINAL,
         H.CUSTOCONT,
         H.VLESTOQUE,
         P.DESCRICAO PRODUTO,
         P.NBM NCM,
         A.CODFIGURA,
         A.DESCRICAO DESC_FIGURA,
         A.PERIPI,
         A.CALCCREDIPI,
         A.PERCICM,
         A.PERCREDICMS,
         A.PERCICMRED,
         A.PERCBASEREDENT,
         A.PERCIVA,
         A.REDBASEIVA,
         A.PERCALIQINT,
         A.PERCALIQEXT,
         A.SITTRIBUT,
         N.NUMTRANSACAO,
         N.DTEMISSAO,
         N.DTENT,
         N.NUMNOTA,
         N.FORNECEDOR,
         N.CHAVENFE,
         N.QT_COMPRA,
         N.PUNIT,
         N.VLNF_COMPRA,
         N.CODFISCAL,
         N.VLBASEICMS,
         N.PERCICM PERCICM_NOTA,
         N.VLICMS,
         N.VLBASEICMSST,
         N.VLST,
         N.VLSTGUIA,
         ROUND(N.BASEBCR * N.QT_COMPRA, 2) BASEBCR,
         SUM(N.QT_COMPRA) OVER (PARTITION BY H.CODPROD, H.CODFILIAL ORDER BY N.DTENT DESC, N.NUMTRANSACAO DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS QT_ACUMULADA
    FROM HIST_ESTOQUE H
    JOIN PCPRODUT P ON P.CODPROD = H.CODPROD
    LEFT JOIN PCFORNEC F ON F.CODFORNEC = P.CODFORNEC
    LEFT JOIN PCTRIBENTRADA E ON E.NCM = P.CODNCMEX
                             AND E.CODFILIAL = H.CODFILIAL
                             AND E.UFORIGEM = F.ESTADO
                             AND E.TIPOFORNEC = F.TIPOFORNEC
    LEFT JOIN PCTRIBFIGURA A ON A.CODFIGURA = E.CODFIGURA
   INNER JOIN NOTAS_ENTRADA N ON N.CODPROD = H.CODPROD
                             AND N.CODFILIAL = H.CODFILIAL)
SELECT CODFILIAL,
       CODPROD,
       PRODUTO,
       NCM,
       QT_ESTOQUE_FINAL,
       CUSTOCONT,
       VLESTOQUE,
       CODFIGURA,
       DESC_FIGURA,
       PERIPI,
       CALCCREDIPI,
       PERCICM,
       PERCREDICMS,
       PERCICMRED,
       PERCBASEREDENT,
       PERCIVA,
       REDBASEIVA,
       PERCALIQINT,
       PERCALIQEXT,
       SITTRIBUT,
       NUMTRANSACAO,
       DTEMISSAO,
       DTENT,
       NUMNOTA,
       FORNECEDOR,
       CHAVENFE,
       QT_COMPRA,
       PUNIT,
       VLNF_COMPRA,
       CODFISCAL,
       VLBASEICMS,
       PERCICM_NOTA,
       VLICMS,
       (CASE
         WHEN NVL(VLBASEICMSST, 0) = 0 THEN
          BASEBCR
         ELSE
          VLBASEICMSST
       END) VLBASEICMSST,
       VLST,
       VLSTGUIA,
       QT_ACUMULADA
  FROM NOTAS_COM_ACUMULADO
 WHERE QT_ACUMULADA <= QT_ESTOQUE_FINAL
    OR (QT_ACUMULADA - QT_COMPRA) < QT_ESTOQUE_FINAL
 ORDER BY CODPROD,
          DTENT DESC,
          NUMTRANSACAO DESC;
