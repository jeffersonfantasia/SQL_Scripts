SELECT P.CODPROD,
       P.DESCRICAO,
       P.CODMARCA,
       M.MARCA,
       P.CODEPTO,
       D.DESCRICAO DEPARTAMENTO,
       P.CODSEC,
       S.DESCRICAO SECAO,
       P.CODCATEGORIA,
       C.CATEGORIA,
       P.CODLINHAPROD,
       L.DESCRICAO LINHA_PRODUTO
  FROM PCPRODUT P,
       PCDEPTO D,
       PCSECAO S,
       PCCATEGORIA C,
       PCLINHAPROD L,
       PCMARCA M
 WHERE P.CODMARCA = M.CODMARCA
   AND P.CODEPTO = D.CODEPTO
   AND P.CODSEC = S.CODSEC
   AND P.CODCATEGORIA = C.CODCATEGORIA
   AND P.CODLINHAPROD = L.CODLINHA (+)
   AND P.CODMARCA IN (
    1, 2
)
   AND P.CODLINHAPROD IS NULL
 ORDER BY P.CODPROD;