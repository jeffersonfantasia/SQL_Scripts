/*Relatório Produtos sem flag Gera ICMS no livro fiscal   */
SELECT T.DTCADASTRO,
       P.CODFILIAL,
       T.CODPRODMASTER,
       P.CODPROD,
       T.DESCRICAO,
       T.CODNCMEX,
       P.GERAICMSLIVROFISCAL REGIME_ICMS,
       P.GERAICMSLIVROFISCALENT ICMS_ENT,
       P.GERAICMSLIVROFISCALDEVFORNEC ICMS_DEV
  FROM PCPRODFILIAL P,
       PCPRODUT T
 WHERE T.CODPROD = P.CODPROD
   AND ((P.GERAICMSLIVROFISCAL IS NULL
    OR (P.GERAICMSLIVROFISCALENT IS NULL))
    OR (P.GERAICMSLIVROFISCALDEVFORNEC IS NULL))
   AND T.DTCADASTRO <= TRUNC (SYSDATE)
   AND T.DTEXCLUSAO IS NULL
   AND T.CODPRODMASTER IS NOT NULL
 ORDER BY T.CODNCMEX,
          T.DTCADASTRO DESC,
          P.CODPROD,
          P.CODFILIAL;
/
UPDATE PCPRODFILIAL
   SET
    GERAICMSLIVROFISCAL = 'S'
 WHERE GERAICMSLIVROFISCAL IS NULL
   AND CODPROD IN (
   812868, 812867,812872
);
/
SELECT T.DTCADASTRO,
       P.CODFILIAL,
       T.CODPRODMASTER,
       P.CODPROD,
       T.DESCRICAO,
       T.CODNCMEX,
       P.GERAICMSLIVROFISCAL REGIME_ICMS,
       P.GERAICMSLIVROFISCALENT ICMS_ENT,
       P.GERAICMSLIVROFISCALDEVFORNEC ICMS_DEV
  FROM PCPRODFILIAL P,
       PCPRODUT T
 WHERE T.CODPROD = P.CODPROD
   AND P.CODPROD IN (
    810127, 810128, 810129, 810130
);
/