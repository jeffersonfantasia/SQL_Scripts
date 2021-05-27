/*Categorias de produtos com baixa estoque*/
WITH ESTOQUE_DISPONIVEL AS (
    SELECT E.CODFILIAL,
           E.CODPROD,
           (E.QTESTGER - E.QTBLOQUEADA - E.QTRESERV) AS QTDISP
      FROM PCEST E
     WHERE E.CODFILIAL IN (
        1, 7
    )
), CONTAGEM_CATEGORIA_COM_ESTOQUE AS (
    SELECT E.CODFILIAL,
           P.CODCATEGORIA,
           COUNT (P.CODCATEGORIA) AS QT_PRODCAT
      FROM PCPRODUT P
      LEFT JOIN ESTOQUE_DISPONIVEL E ON P.CODPROD = E.CODPROD
     WHERE P.DTEXCLUSAO IS NULL
       AND P.CODEPTO NOT IN (
        97, 98, 99
    )
       AND E.QTDISP > 0
     GROUP BY E.CODFILIAL,
              P.CODCATEGORIA
), CONTAGEM_CATEGORIA_SEM_ESTOQUE AS (
    SELECT E.CODFILIAL,
           P.CODCATEGORIA,
           SUM (E.QTDISP) SOMA_QTDISP
      FROM PCPRODUT P
      LEFT JOIN ESTOQUE_DISPONIVEL E ON P.CODPROD = E.CODPROD
     WHERE P.DTEXCLUSAO IS NULL
       AND P.CODEPTO NOT IN (
        97, 98, 99
    )
     GROUP BY E.CODFILIAL,
              P.CODCATEGORIA
)
SELECT *
  FROM (
    SELECT E.CODFILIAL,
           S.DESCRICAO AS SECAO,
           P.CODCATEGORIA,
           C.CATEGORIA,
           T.QT_PRODCAT,
           P.CODPROD,
           P.DESCRICAO,
           E.QTDISP
      FROM PCPRODUT P
      LEFT JOIN PCCATEGORIA C ON P.CODCATEGORIA = C.CODCATEGORIA
      LEFT JOIN PCSECAO S ON P.CODSEC = S.CODSEC
      LEFT JOIN ESTOQUE_DISPONIVEL E ON P.CODPROD = E.CODPROD
      LEFT JOIN CONTAGEM_CATEGORIA_COM_ESTOQUE T ON E.CODFILIAL = T.CODFILIAL
       AND P.CODCATEGORIA = T.CODCATEGORIA
     WHERE P.DTEXCLUSAO IS NULL
       AND E.QTDISP > 0
       AND T.QT_PRODCAT < 5
    UNION
    SELECT T.CODFILIAL,
           S.DESCRICAO AS SECAO,
           T.CODCATEGORIA,
           C.CATEGORIA,
           0 AS QT_PRODCAT,
           NULL AS CODPROD,
           NULL AS DESCRICAO,
           0 AS QTDISP
      FROM CONTAGEM_CATEGORIA_SEM_ESTOQUE T
     INNER JOIN PCCATEGORIA C ON C.CODCATEGORIA = T.CODCATEGORIA
      LEFT JOIN PCSECAO S ON C.CODSEC = S.CODSEC
     WHERE T.SOMA_QTDISP <= 0
)
 WHERE CODFILIAL = 7
   AND CODCATEGORIA IS NOT NULL
   AND CODCATEGORIA <> 0
 ORDER BY CODCATEGORIA;
/