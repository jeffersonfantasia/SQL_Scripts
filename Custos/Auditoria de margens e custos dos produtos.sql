WITH PRODUTO_ESTOQUE AS (
    SELECT E.CODFILIAL,
           F.CODFORNECPRINC,
           P.CODPROD,
           P.IMPORTADO,
           P.CODMARCA,
           M.MARCA,
           P.CODLINHAPROD AS CODLINHA,
           L.DESCRICAO AS LINHA_PROD,
           E.QTESTGER AS QTESTOQUE,
           E.CUSTOPROXIMACOMPRA
      FROM PCPRODUT P
     INNER JOIN PCPRODFILIAL D ON P.CODPROD = D.CODPROD
      LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
      LEFT JOIN PCEST E ON P.CODPROD = E.CODPROD
       AND D.CODFILIAL = E.CODFILIAL
      LEFT JOIN PCLINHAPROD L ON P.CODLINHAPROD = L.CODLINHA
      LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
     WHERE D.ENVIARFORCAVENDAS = 'S'
       AND NVL (P.OBS2, '0') NOT IN (
        'FL'
    )
)
SELECT *
  FROM (
    SELECT P.CODFILIAL,
           P.CODPROD,
           P.DESCRICAO,
           E.IMPORTADO,
           E.CODLINHA,
           E.LINHA_PROD,
           E.CODMARCA,
           E.MARCA,
           P.NUMREGIAO,
           P.REGIAO,
           E.QTESTOQUE,
           P.MARGEM AS MIDEAL,
           ROUND (P.MARGEMPRECIFICACAO, 2) AS MPRECO,
           ROUND (E.CUSTOPROXIMACOMPRA, 4) CUSTOPROXIMACOMPRA,
           ROUND (P.CUSTOSELECIONADO, 4) AS CUSTOLIQAPLIC,
           ROUND (P.CUSTOSELECIONADO / (1 - ((P.CODICMTAB + P.MARGEM) / 100)), 4) AS PSUGERIDO,
           ROUND (P.PVENDA, 4) AS PVENDA
      FROM VW_PRECIFICACAO P
      LEFT JOIN PRODUTO_ESTOQUE E ON P.CODPROD = E.CODPROD
       AND P.CODFILIAL = E.CODFILIAL
     WHERE P.CODFILIAL = 2
       AND P.NUMREGIAO IN (1, 3, 4)
       AND E.CODFORNECPRINC = 2
     ORDER BY P.CODPROD,
              P.NUMREGIAO
)
 WHERE MIDEAL <> MPRECO
    OR CUSTOPROXIMACOMPRA <> CUSTOLIQAPLIC
    OR PSUGERIDO <> PVENDA
    OR (DESCRICAO LIKE '%LIVRO%' AND MIDEAL <> 35.39)
    OR (DESCRICAO NOT LIKE '%LIVRO%' AND NUMREGIAO = 1 AND MIDEAL <> 31.47)
    OR (DESCRICAO NOT LIKE '%LIVRO%' AND IMPORTADO = 'N' AND NUMREGIAO = 3 AND MIDEAL <> 35.69)
    OR (DESCRICAO NOT LIKE '%LIVRO%' AND IMPORTADO = 'N' AND NUMREGIAO = 4 AND MIDEAL <> 33.77)
    OR (DESCRICAO NOT LIKE '%LIVRO%' AND IMPORTADO = 'S' AND NUMREGIAO IN (3, 4) AND MIDEAL <> 36.84);
/