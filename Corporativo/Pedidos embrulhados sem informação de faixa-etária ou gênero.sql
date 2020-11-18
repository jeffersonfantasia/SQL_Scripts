SELECT C.DATA,
       I.NUMPED,
       T.CODREDE,
       R.DESCRICAO AS REDE,
       C.CODCLI,
       T.CLIENTE,
       I.ESC_FAIXAETARIA AS FAIXAETARIA,
       I.ESC_GENERO AS GENERO,
       C.ESC_PEDIDOEMBRULHADO AS PEDIDOEMBRULHADO,
       I.CODPROD,
       P.DESCRICAO
  FROM PCPEDI I
 INNER JOIN PCPEDC C ON I.NUMPED = C.NUMPED
  LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  LEFT JOIN PCREDECLIENTE R ON T.CODREDE = R.CODREDE
 WHERE C.POSICAO NOT IN (
    'F', 'C'
)
   AND C.CODUSUR = 14
   AND (C.ESC_PEDIDOEMBRULHADO = 'S'
   AND (I.ESC_FAIXAETARIA IS NULL
    OR I.ESC_GENERO IS NULL))
 ORDER BY DATA,
          NUMPED;