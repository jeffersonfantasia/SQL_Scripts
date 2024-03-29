WITH PRECOS_PROMOCIONAIS AS
 (SELECT P.DTFIMVIGENCIA DTALTERACAO,
         'A' STATUS,
         P.CODFILIAL,
         F.FANTASIA FILIAL,
         P.CODPROD,
         T.DESCRICAO,
         P.PRECOFIXO PRECO_ALTERADO,
         P.CODFUNCULTALTER CODFUNC,
         E.NOME_GUERRA FUNCIONARIO,
         COALESCE((SELECT MAX(CP.PVENDA)
                    FROM PCPRECO CP,
                         (SELECT MAX(DATAALTER) DATAALTER
                            FROM PCPRECO C
                           WHERE C.PVENDA > 0
                             AND C.ROTINA = 201
                             AND C.NUMREGIAO = P.NUMREGIAO
                             AND C.CODPROD = P.CODPROD
                             AND C.DATAALTER <= P.DTINICIOVIGENCIA) C
                   WHERE CP.DATAALTER = C.DATAALTER
                     AND CP.CODPROD = P.CODPROD
                     AND CP.NUMREGIAO = P.NUMREGIAO),
                  R.PVENDA) PRECO_CORRETO
    FROM PCPRECOPROM P
    LEFT JOIN PCPRODUT T ON T.CODPROD = P.CODPROD
    LEFT JOIN PCEMPR E ON E.MATRICULA = P.CODFUNCULTALTER
    LEFT JOIN PCFILIAL F ON P.CODFILIAL = F.CODIGO
    LEFT JOIN PCTABPR R ON R.CODPROD = P.CODPROD
                       AND R.NUMREGIAO = P.NUMREGIAO
   WHERE P.NUMREGIAO = 100
     AND P.DTINICIOVIGENCIA >= TO_DATE('01/01/2024', 'DD/MM/YYYY')
     AND (P.DTFIMVIGENCIA - P.DTINICIOVIGENCIA) = 0
  
  UNION ALL
  
  SELECT P.DTFIMVIGENCIA DTALTERACAO,
         'LOG' STATUS,
         P.CODFILIAL,
         F.FANTASIA FILIAL,
         P.CODPROD,
         T.DESCRICAO,
         P.PRECOFIXO PRECO_ALTERADO,
         P.CODFUNCULTALTER CODFUNC,
         E.NOME_GUERRA FUNCIONARIO,
         COALESCE((SELECT MAX(CP.PVENDA)
                    FROM PCPRECO CP,
                         (SELECT MAX(DATAALTER) DATAALTER
                            FROM PCPRECO C
                           WHERE C.PVENDA > 0
                             AND C.ROTINA = 201
                             AND C.NUMREGIAO = P.NUMREGIAO
                             AND C.CODPROD = P.CODPROD
                             AND C.DATAALTER <= P.DTINICIOVIGENCIA) C
                   WHERE CP.DATAALTER = C.DATAALTER
                     AND CP.CODPROD = P.CODPROD
                     AND CP.NUMREGIAO = P.NUMREGIAO),
                  R.PVENDA) PRECO_CORRETO
    FROM PCPRECOPROMLOG P
    LEFT JOIN PCPRODUT T ON T.CODPROD = P.CODPROD
    LEFT JOIN PCEMPR E ON E.MATRICULA = P.CODFUNCULTALTER
    LEFT JOIN PCFILIAL F ON P.CODFILIAL = F.CODIGO
    LEFT JOIN PCTABPR R ON R.CODPROD = P.CODPROD
                       AND R.NUMREGIAO = P.NUMREGIAO
   WHERE P.NUMREGIAO = 100
     AND P.CODFILIAL IN ('1', '8', '12', '13')
     AND P.DTINICIOVIGENCIA >= TO_DATE('01/01/2024', 'DD/MM/YYYY')
     AND (P.DTFIMVIGENCIA - P.DTINICIOVIGENCIA) = 0)

SELECT DTALTERACAO,
       STATUS,
       CODFILIAL,
       FILIAL,
       CODPROD,
       DESCRICAO,
       PRECO_ALTERADO,
       PRECO_CORRETO,
       (PRECO_CORRETO - PRECO_ALTERADO) PREJUIZO,
       CODFUNC,
       FUNCIONARIO
  FROM PRECOS_PROMOCIONAIS
 ORDER BY CODFILIAL, DTALTERACAO DESC;
