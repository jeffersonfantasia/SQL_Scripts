WITH ITENS_OS AS (
    SELECT OS_ID,
           COUNT (PROD_ID) QTITENS
      FROM (
        SELECT DISTINCT I.OS_ID,
                        I.PROD_ID
          FROM JCENDOSITEM I
    )
     GROUP BY OS_ID
)
SELECT CODFUNC,
       FUNCIONARIO,
       COUNT (ID) QTABASTECIMENTO,
       SUM (QTITENS) QTITENS
  FROM (
    SELECT C.ID,
           C.USUARIO_ID AS CODFUNC,
           E.NOME_GUERRA AS FUNCIONARIO,
           I.QTITENS
      FROM JCENDOS C
     INNER JOIN ITENS_OS I ON C.ID = I.OS_ID
      LEFT JOIN PCEMPR E ON C.USUARIO_ID = E.MATRICULA
     WHERE C.TIPO_MOV = 'H'
       AND C.TIPO_OS = 3
       AND C.DT_CANCEL IS NULL
     /*RETIRAR 'OS' CANCELADAS*/
       AND C.DT_FIM IS NOT NULL
     /*PEGAR APENAR 'OS' FINALIZADAS*/
       AND DT_INICIO >= TRUNC(SYSDATE) - 1
)
 GROUP BY CODFUNC,
          FUNCIONARIO
 ORDER BY QTITENS DESC;
/