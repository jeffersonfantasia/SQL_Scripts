SELECT *
  FROM (
    SELECT C.CODFILIAL FILIAL,
           T.CODCLI,
           T.CLIENTE,
           I.CODPROD,
           P.DESCRICAO,
           I.PERDESC,
           I.PVENDA,
           I.PTABELA,
           C.CODFUNCCX,
           R.NOME
      FROM PCPEDI I,
           PCPEDC C,
           PCPRODUT P,
           PCEMPR R,
           PCCLIENT T
     WHERE I.NUMPED = C.NUMPED
       AND I.CODPROD = P.CODPROD
       AND C.CODCLI = T.CODCLI
       AND C.CODFUNCCX = R.MATRICULA
       AND C.ORIGEMPED = 'A'
       AND I.DATA >= TRUNC (SYSDATE) - 30
       AND I.PERDESC > 0
)
 WHERE PERDESC > 0
/