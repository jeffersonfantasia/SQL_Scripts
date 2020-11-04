----------------ANÁLISE CONSIDERANDO URL-------------------
SELECT CODFILIAL,
       DTCADASTRO,
       CODPROD,
       DESCRICAO,
       ENVIAECOMMERCE,
       QTESTGER,
       VALOR_ESTOQUE,
       NOMEECOMMERCE , URLIMAGEM
  FROM (SELECT E.CODFILIAL,
               TO_DATE(P.DTCADASTRO, 'DD/MM/YY') DTCADASTRO,
               E.CODPROD,
               (SELECT COUNT(CODPRODMASTER)
                  FROM PCPRODUT
                 WHERE CODPRODMASTER = E.CODPROD) CONTAGEM,
               P.DESCRICAO,
               P.ENVIAECOMMERCE,
               E.QTESTGER,
               (NVL(E.VALORULTENT, 0) * NVL(E.QTESTGER, 0)) VALOR_ESTOQUE,
               W.NOMEECOMMERCE , W.URLIMAGEM
          FROM PCPRODUT P, PCFORNEC F, PCEST E, ESTPRODUTOWEB W
         WHERE P.CODPROD = E.CODPROD
           AND E.CODPROD(+) = W.CODPROD
           AND P.CODFORNEC = F.CODFORNEC
           AND E.CODFILIAL = 7
           AND QTESTGER > 0
           AND (W.NOMEECOMMERCE IS NULL OR P.ENVIAECOMMERCE = 'N' OR W.URLIMAGEM IS NULL
               )
         GROUP BY E.CODFILIAL,
                  P.DTCADASTRO,
                  E.CODPROD,
                  P.DESCRICAO,
                  P.ENVIAECOMMERCE,
                  E.QTESTGER,
                  E.VALORULTENT,
                  E.QTESTGER,
                  W.NOMEECOMMERCE , W.URLIMAGEM
        )
 WHERE CONTAGEM <= 1

 ORDER BY QTESTGER DESC, VALOR_ESTOQUE DESC;


----------------ANÁLISE SEM CONSIDERAR URL-------------------
SELECT CODFILIAL,
       DTCADASTRO,
       CODPROD,
       DESCRICAO,
       ENVIAECOMMERCE,
       QTESTGER,
       VALOR_ESTOQUE,
       NOMEECOMMERCE /*, URLIMAGEM*/
  FROM (SELECT E.CODFILIAL,
               TO_DATE(P.DTCADASTRO, 'DD/MM/YY') DTCADASTRO,
               E.CODPROD,
               (SELECT COUNT(CODPRODMASTER)
                  FROM PCPRODUT
                 WHERE CODPRODMASTER = E.CODPROD) CONTAGEM,
               P.DESCRICAO,
               P.ENVIAECOMMERCE,
               E.QTESTGER,
               (NVL(E.VALORULTENT, 0) * NVL(E.QTESTGER, 0)) VALOR_ESTOQUE,
               W.NOMEECOMMERCE /*, W.URLIMAGEM*/
          FROM PCPRODUT P, PCFORNEC F, PCEST E, ESTPRODUTOWEB W
         WHERE P.CODPROD = E.CODPROD
           AND E.CODPROD(+) = W.CODPROD
           AND P.CODFORNEC = F.CODFORNEC
           AND E.CODFILIAL = 7
           AND QTESTGER > 0
           AND (W.NOMEECOMMERCE IS NULL OR P.ENVIAECOMMERCE = 'N' /*OR W.URLIMAGEM IS NULL)*/
               )
         GROUP BY E.CODFILIAL,
                  P.DTCADASTRO,
                  E.CODPROD,
                  P.DESCRICAO,
                  P.ENVIAECOMMERCE,
                  E.QTESTGER,
                  E.VALORULTENT,
                  E.QTESTGER,
                  W.NOMEECOMMERCE /*, W.URLIMAGEM*/
        )
 WHERE CONTAGEM <= 1
 ORDER BY QTESTGER DESC, VALOR_ESTOQUE DESC;
