WITH VERIFICAR_PEDIDOS AS (
    SELECT P.CODFILIAL,
           P.NUMPEDRCA,
           P.NUMNOTA
      FROM PCPEDC P
     WHERE P.NUMNOTA IS NOT NULL
), DUPLICATAS_PEDIDOS AS (
    SELECT T.CODFILIAL,
           T.CODCLI,
           C.CLIENTE,
           T.DUPLIC,
           T.PREST,
           T.CODCOB,
           T.VALOR,
           T.VALORDESC,
           T.VPAGO,
           T.DTPAG,
           T.CODBAIXA,
           T.DTCANCEL,
           E.NOME_GUERRA,
           P.NUMPEDRCA
      FROM PCPREST T
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
      LEFT JOIN PCEMPR E ON T.CODBAIXA = E.MATRICULA
      LEFT JOIN VERIFICAR_PEDIDOS P ON T.DUPLIC = P.NUMNOTA
       AND T.CODFILIAL = P.CODFILIAL
     WHERE T.CODCOB NOT IN (
        'DESD', 'ESTR'
    )
       AND T.VALORESTORNO IS NULL
       AND T.CODSUPERVISOR IN (
        7, 8
    )
), DUPLICATAS AS (
    SELECT T.CODFILIAL,
           T.CODCLI,
           C.CLIENTE,
           T.DUPLIC,
           T.PREST,
           T.CODCOB,
           T.VALOR,
           T.VALORDESC,
           T.VPAGO,
           T.DTPAG,
           T.CODBAIXA,
           T.DTCANCEL,
           E.NOME_GUERRA
      FROM PCPREST T
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
      LEFT JOIN PCEMPR E ON T.CODBAIXA = E.MATRICULA
     WHERE T.CODCOB NOT IN (
        'DESD', 'ESTR'
    )
       AND T.VALORESTORNO IS NULL
       AND T.CODSUPERVISOR IN (
        7, 8
    )
)
SELECT *
  FROM (
    SELECT C.CODFILIAL,
           C.CODIGO,
           C.DTLANC,
           C.CODCLI AS CODCLICRED,
           T.CLIENTE AS CLIENTE_CREDITO,
           C.NUMNOTA,
           C.HISTORICO,
           C.VALOR AS VLCREDITO,
           C.CODFUNCLANC AS CODFUNC,
           E.NOME_GUERRA AS NOME,
           C.CODMOVIMENTO AS CODBANCO,
           B.NOME AS BANCO,
           D.CODCLI,
           D.CLIENTE,
           D.DUPLIC,
           D.PREST,
           D.CODCOB,
           D.VALOR,
           D.VALORDESC,
           D.VPAGO,
           D.DTPAG,
           D.CODBAIXA,
           D.NOME_GUERRA,
           D.DTCANCEL
      FROM PCCRECLI C
      LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
      LEFT JOIN PCEMPR E ON C.CODFUNCLANC = E.MATRICULA
      LEFT JOIN PCBANCO B ON C.CODMOVIMENTO = B.CODBANCO
     INNER JOIN DUPLICATAS_PEDIDOS D ON C.CODFILIAL = D.CODFILIAL
       AND C.NUMNOTA = D.NUMPEDRCA
     WHERE C.CODFILIAL = 7
       AND C.DTDESCONTO IS NULL
       AND NVL (C.ORIGEM, 0) NOT IN (
        'M'
    )
       AND NVL (C.CODMOVIMENTO, 0) IS NOT NULL
       AND C.NUMTRANSENTDEVCLI IS NULL
    UNION
    SELECT C.CODFILIAL,
           C.CODIGO,
           C.DTLANC,
           C.CODCLI AS CODCLICRED,
           T.CLIENTE AS CLIENTE_CREDITO,
           C.NUMNOTA,
           C.HISTORICO,
           C.VALOR AS VLCREDITO,
           C.CODFUNCLANC AS CODFUNC,
           E.NOME_GUERRA AS NOME,
           C.CODMOVIMENTO AS CODBANCO,
           B.NOME AS BANCO,
           D.CODCLI,
           D.CLIENTE,
           D.DUPLIC,
           D.PREST,
           D.CODCOB,
           D.VALOR,
           D.VALORDESC,
           D.VPAGO,
           D.DTPAG,
           D.CODBAIXA,
           D.NOME_GUERRA,
           D.DTCANCEL
      FROM PCCRECLI C
      LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
      LEFT JOIN PCEMPR E ON C.CODFUNCLANC = E.MATRICULA
      LEFT JOIN PCBANCO B ON C.CODMOVIMENTO = B.CODBANCO
     INNER JOIN DUPLICATAS_PEDIDOS D ON C.CODFILIAL = D.CODFILIAL
       AND C.NUMNOTA = D.DUPLIC
     WHERE C.CODFILIAL = 7
       AND C.DTDESCONTO IS NULL
       AND NVL (C.ORIGEM, 0) NOT IN (
        'M'
    )
       AND NVL (C.CODMOVIMENTO, 0) IS NOT NULL
       AND C.NUMTRANSENTDEVCLI IS NULL
)
 ORDER BY NUMNOTA,
          DUPLIC,
          PREST;
/