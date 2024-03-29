CREATE OR REPLACE VIEW VIEW_BI_PRODUTO AS
    SELECT P.CODPROD,
           P.DESCRICAO AS PRODUTO,
           (
               CASE
                   WHEN P.CODPROD = P.CODPRODMASTER THEN 'PAI'
                   ELSE 'FILHO'
               END
           ) AS TIPO,
           F.CODFORNEC,
           P.CODMARCA,
           D.DESCRICAO AS DEPARTAMENTO,
           S.DESCRICAO AS SECAO,
           C.CATEGORIA,
           COALESCE (P.CODLINHAPROD, 99) AS CODPRODLINHA,
           L.ENVIARFORCAVENDAS AS LINHADISTRIBUICAO,
           (
               CASE P.OBS
                   WHEN 'PR'   THEN 'PROMOCIONAL'
                   WHEN 'OF'   THEN 'EM OFERTA'
                   WHEN 'TB'   THEN 'NOVIDADE'
                   ELSE NVL (P.OBS, 'NORMAL')
               END
           ) AS TIPOPRODUTO,
           (
               CASE P.OBS2
                   WHEN '  '   THEN 'ATIVO'
                   WHEN 'FL'   THEN 'FORA DE LINHA'
                   ELSE NVL (P.OBS2, 'ATIVO')
               END
           ) AS FORADELINHA,
           P.DTCADASTRO AS DTCADASTROPROD,
           P.DTULTALTCAD AS DTULTALTPROD
      FROM PCPRODUT P
      LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
      LEFT JOIN PCDEPTO D ON P.CODEPTO = D.CODEPTO
      LEFT JOIN PCSECAO S ON P.CODSEC = S.CODSEC
      LEFT JOIN PCCATEGORIA C ON P.CODCATEGORIA = C.CODCATEGORIA
      LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
      LEFT JOIN PCPRODFILIAL L ON P.CODPROD = L.CODPROD
       AND L.CODFILIAL = 2;
/