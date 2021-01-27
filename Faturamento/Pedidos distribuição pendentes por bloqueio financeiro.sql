WITH MAXCODIGOBLOQUEIO AS (
    SELECT MAX (CODIGO) CODIGO_MAX,
           NUMPED
      FROM PCBLOQUEIOSPEDIDO B
     GROUP BY NUMPED
), MOTIVOBLOQUEIO AS (
    SELECT B.NUMPED,
           B.TIPO
      FROM PCBLOQUEIOSPEDIDO B
     INNER JOIN MAXCODIGOBLOQUEIO M ON B.CODIGO = M.CODIGO_MAX
       AND B.NUMPED = M.NUMPED
)
SELECT C.CODFILIAL,
       C.DATA,
       C.CODUSUR,
       U.NOME,
       C.NUMPED,
       C.CODCLI,
       T.CLIENTE,
       C.CODCOB,
       C.VLATEND
  FROM PCPEDC C
  LEFT JOIN MOTIVOBLOQUEIO B ON C.NUMPED = B.NUMPED
  LEFT JOIN PCSUPERV V ON C.CODSUPERVISOR = V.CODSUPERVISOR
  LEFT JOIN PCUSUARI U ON C.CODUSUR = U.CODUSUR
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
 WHERE C.POSICAO IN (
    'B'
)
   AND V.CODGERENTE IN (
    1, 8, 9, 10
)
   AND C.CONDVENDA IN (
    1, 7
)
   AND B.TIPO = 'F'
 ORDER BY C.DATA;
/