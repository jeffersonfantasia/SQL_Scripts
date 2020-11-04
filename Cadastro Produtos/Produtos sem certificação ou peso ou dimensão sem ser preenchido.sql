SELECT *
  FROM (SELECT P.CODFORNEC,
               F.FORNECEDOR,
               P.CODPROD,
               P.CODFAB,
               P.DTCADASTRO,
               P.DESCRICAO,
               P.PESOLIQ,
               P.ALTURAM3,
               P.COMPRIMENTOM3,
               P.LARGURAM3,
               P.SUBTITULOECOMMERCE CERTIFICACAO,
               SUM(NVL(E.QTESTGER, 0)) QT_TOTAL
          FROM PCEST E, PCPRODUT P, PCFORNEC F
         WHERE E.CODFILIAL IN (1, 2, 3, 4, 7)
           AND E.CODPROD = P.CODPROD
           AND P.CODFORNEC = F.CODFORNEC
           AND P.DTEXCLUSAO IS NULL
           AND P.TIPOMERC NOT IN ('CB', 'KT')
         GROUP BY P.CODFORNEC,
                  F.FORNECEDOR,
                  P.CODPROD,
                  P.CODFAB,
                  P.DTCADASTRO,
                  P.DESCRICAO,
                  P.PESOLIQ,
                  P.ALTURAM3,
                  P.COMPRIMENTOM3,
                  P.LARGURAM3,
                  P.SUBTITULOECOMMERCE) TAB
 WHERE TAB.QT_TOTAL > 0
   AND (TAB.CERTIFICACAO IS NULL
   OR (TAB.CERTIFICACAO LIKE '-%')
   OR (TAB.PESOLIQ IS NULL)
   OR (TAB.ALTURAM3 IS NULL)
   OR (TAB.COMPRIMENTOM3 IS NULL)
   OR (TAB.LARGURAM3 IS NULL))
 ORDER BY TAB.FORNECEDOR, TAB.DESCRICAO;
