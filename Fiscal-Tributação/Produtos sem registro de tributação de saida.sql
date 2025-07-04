WITH FILIAL_ESTADO AS
 (SELECT F.CODIGO,
         E.UF
    FROM PCFILIAL F,
         PCESTADO E
   WHERE F.CODIGO NOT IN ('99')
     AND F.DTEXCLUSAO IS NULL)
SELECT DISTINCT P.DTCADASTRO,
                E.CODPROD,
                P.DESCRICAO,
                P.CODNCMEX,
                E.CODFILIAL,
                LISTAGG(FE.UF, ', ') WITHIN GROUP(ORDER BY FE.UF) OVER (PARTITION BY E.CODPROD, E.CODFILIAL) UF_PENDENTE
  FROM PCPRODFILIAL E
  JOIN PCPRODUT P ON P.CODPROD = E.CODPROD
  JOIN FILIAL_ESTADO FE ON E.CODFILIAL = FE.CODIGO
  LEFT JOIN PCTABTRIB T ON E.CODPROD = T.CODPROD
                       AND E.CODFILIAL = T.CODFILIALNF
                       AND FE.UF = T.UFDESTINO
 WHERE P.DTEXCLUSAO IS NULL
   AND P.TIPOMERC = 'L'
   AND T.UFDESTINO IS NULL
 ORDER BY E.CODPROD,
          TO_NUMBER(E.CODFILIAL);
