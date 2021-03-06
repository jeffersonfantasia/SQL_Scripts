------ AN�LISE DO SITE DISTRIBUI��O------
SELECT F.CODFILIAL,
       F.CODPROD,
       P.DESCRICAO,
       F.ENVIARFORCAVENDAS,
       P.OBS,
       P.OBS2,
       P.DTEXCLUSAO
  FROM PCPRODFILIAL F, PCPRODUT P, ESTPRODUTOWEB W
 WHERE F.CODPROD = P.CODPROD
   AND W.CODPROD = F.CODPROD
   AND F.CODFILIAL = 2
   AND F.ENVIARFORCAVENDAS = 'S'
   AND COALESCE(P.OBS, 'X') <> 'PV'
   AND COALESCE(P.OBS2, 'X') <> 'FL'
   AND W.NOMEECOMMERCE IS NOT NULL
   AND P.DTEXCLUSAO IS NULL;