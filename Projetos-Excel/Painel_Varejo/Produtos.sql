WITH CUSTO_COMPRA AS (
    SELECT F.CODPROD,
           ROUND ((NVL (F.CUSTOREP, 0) * ((100 - NVL (F.PERCDESC, 0)) / 100)), 2) AS CUSTO
      FROM PCPRODFILIAL F
     WHERE F.CODFILIAL = 7
), TABELA_VENDA AS (
    SELECT T.CODPROD,
           ROUND (NVL (T.PVENDA, 0), 2) AS PRECO
      FROM PCTABPR T
     WHERE T.NUMREGIAO = 100
), ESTOQUE_TOTAL AS (
    SELECT E.CODPROD,
           SUM (NVL (E.QTESTGER, 0)) AS QTGERENCIAL
      FROM PCEST E
     WHERE E.CODFILIAL IN (
        1, 2, 7
    )
     GROUP BY E.CODPROD
), ESTOQUE_COMPRA AS (
    SELECT E.CODPROD,
           NVL (E.QTPEDIDA, 0) AS QTCOMPRA
      FROM PCEST E
     WHERE E.CODFILIAL IN (
        7
    )
), ESTOQUE_GONDOLA AS (
    SELECT E.CODPROD,
           NVL (E.QTFRENTELOJA, 0) AS QTGONDOLA
      FROM PCEST E
     WHERE E.CODFILIAL IN (
        1
    )
), ESTOQUE_BLOQ AS (
    SELECT E.CODPROD,
           NVL (E.QTBLOQUEADA, 0) AS QTBLOQ2_ECOMMERCE
      FROM PCEST E
     WHERE E.CODFILIAL IN (
        2
    )
    AND E.CODDEVOL = 49
), ESTOQUE_VAREJO AS (
    SELECT E.CODPROD,
           SUM ((NVL (E.QTESTGER, 0) - NVL (E.QTBLOQUEADA, 0) - NVL (E.QTRESERV, 0))) AS QTVAREJO
      FROM PCEST E
     WHERE E.CODFILIAL IN (
        1, 7
    )
     GROUP BY E.CODPROD
), ESTOQUE_FILIAL AS (
    SELECT E.CODFILIAL,
           E.CODPROD,
           (NVL (E.QTESTGER, 0) - NVL (E.QTBLOQUEADA, 0) - NVL (E.QTRESERV, 0)) AS QTDISPONIVEL,
           NVL (E.QTINDENIZ, 0) AS QTAVARIA
      FROM PCEST E
     WHERE E.CODFILIAL IN (
        1, 2, 7, 8
    )
), PENDENTE_COMPRAS AS (
    SELECT CODPROD,
           QTPENDCOMPRA
      FROM (
        SELECT CODPROD,
               SUM (NVL (QTPEDIDA, 0)) - SUM (NVL (QTENTREGUE, 0)) QTPENDCOMPRA
          FROM (
            SELECT I.CODPROD,
                   I.QTPEDIDA,
                   (
                       CASE
                           WHEN I.QTENTREGUE > I.QTPEDIDA THEN I.QTPEDIDA
                           ELSE I.QTENTREGUE
                       END
                   ) AS QTENTREGUE
              FROM PCITEM I
             INNER JOIN PCPEDIDO P ON I.NUMPED = P.NUMPED
             WHERE P.CODCOMPRADOR NOT IN (14)
        ) I
         WHERE QTPEDIDA <> QTENTREGUE
         GROUP BY CODPROD
    )
     WHERE QTPENDCOMPRA > 0
)
SELECT *
  FROM (
    SELECT P.CODPROD,
           P.CODFAB,
           P.DESCRICAO AS PRODUTO,
           P.QTUNITCX AS QT,
           F.FORNECEDOR,
           D.DESCRICAO AS DEPARTAMENTO,
           S.DESCRICAO AS SECAO,
           M.MARCA,
           TRIM(TRANSLATE(WEB.GENERO,';7:', ' ')) AS GENERO,
           C.CUSTO,
           T.PRECO,
           (EV.QTVAREJO * C.CUSTO) AS CUSTO_TOTAL,
           (EV.QTVAREJO * T.PRECO) AS PRECO_TOTAL,
           EF.CODFILIAL,
           ET.QTGERENCIAL,
           EC.QTCOMPRA,
           EG.QTGONDOLA,
           EB.QTBLOQ2_ECOMMERCE,
           EV.QTVAREJO,
           EF.QTDISPONIVEL,
           EF.QTAVARIA,
           NVL(PC.QTPENDCOMPRA,0) AS QTPENDCOMPRA
      FROM PCPRODUT P
      LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
      LEFT JOIN PCDEPTO D ON P.CODEPTO = D.CODEPTO
      LEFT JOIN PCSECAO S ON P.CODSEC = S.CODSEC
      LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
      LEFT JOIN ESTPRODUTOWEB WEB ON P.CODPROD = WEB.CODPROD
      LEFT JOIN CUSTO_COMPRA C ON P.CODPROD = C.CODPROD
      LEFT JOIN TABELA_VENDA T ON P.CODPROD = T.CODPROD
      LEFT JOIN ESTOQUE_TOTAL ET ON P.CODPROD = ET.CODPROD
      LEFT JOIN ESTOQUE_COMPRA EC ON P.CODPROD = EC.CODPROD
      LEFT JOIN ESTOQUE_GONDOLA EG ON P.CODPROD = EG.CODPROD
      LEFT JOIN ESTOQUE_BLOQ EB ON P.CODPROD = EB.CODPROD
      LEFT JOIN ESTOQUE_VAREJO EV ON P.CODPROD = EV.CODPROD
      LEFT JOIN ESTOQUE_FILIAL EF ON P.CODPROD = EF.CODPROD
      LEFT JOIN PENDENTE_COMPRAS PC ON P.CODPROD = PC.CODPROD
     WHERE P.DTEXCLUSAO IS NULL
) PIVOT (
    AVG (QTDISPONIVEL)
QTDISP, AVG (QTAVARIA) QTAVARIA
    FOR CODFILIAL
    IN (1, 2, 7, 8)
);
/