WITH ESTOQUE_ENDERECADO AS (
    SELECT A.PROD_ID,
           SUM (A.QTD) AS QT_END,
           B.FILIAL_ID
      FROM JCENDESTOQUE A,
           JCENDAPTO B
     WHERE A.APTO_ID = B.ID
     GROUP BY A.PROD_ID,
              B.FILIAL_ID
), ESTOQUE_GERENCIAL AS (
    SELECT C.CODFILIAL,
           C.CODPROD,
           C.QTESTGER,
           C.DTULTINVENT
      FROM PCEST C
), ANALISE_EST_ENDERECADO_X_GER AS (
        SELECT G.DTULTINVENT,
               G.CODFILIAL,
               G.CODPROD,
               G.QTESTGER AS QT_GER,
               E.QT_END,
               (G.QTESTGER - E.QT_END) AS DIVERG
          FROM ESTOQUE_ENDERECADO E,
               ESTOQUE_GERENCIAL G
         WHERE E.FILIAL_ID = G.CODFILIAL
           AND E.PROD_ID = G.CODPROD
           AND (G.QTESTGER - E.QT_END) <> 0
), BONUS_DIVERGENTE AS (
        SELECT D.DATABONUS,
               D.CODFILIAL,
               E.CODPROD,
               (E.QTNF - E.QTENTRADA) AS DIF_ENT
          FROM PCBONUSC D,
               PCBONUSI E
         WHERE D.NUMBONUS = E.NUMBONUS
         AND (E.QTNF - E.QTENTRADA) > 0
), PEDIDOS AS (
    SELECT G.CODFILIALRETIRA AS CODFILIAL,
           G.CODPROD,
           (
               CASE
                   WHEN (G.QT <> (SUM (H.QTD_MOV))) THEN 'A SEPARAR'
                   ELSE 'SEPARADO'
               END
           ) AS STATUS,
           G.QT,
           F.NUMPED
      FROM PCPEDC F,
           PCPEDI G,
           JCENDOSITEM H
     WHERE F.NUMPED = G.NUMPED
       AND F.NUMPED = H.PEDIDO_ID
       AND G.NUMPED = H.PEDIDO_ID
       AND G.CODPROD = H.PROD_ID
       AND F.POSICAO IN (
        'L', 'M'
    )
     GROUP BY G.CODFILIALRETIRA,
              G.CODPROD,
              G.QT,
              F.NUMPED
), DEVOLUCAO AS (
    SELECT I.DTMOV,
           I.CODFILIAL,
           I.CODPROD,
           SUM (I.QT) AS DIV_DEV
      FROM PCMOV I
     WHERE I.NUMBONUS IS NULL
       AND I.CODOPER = 'ED'
     GROUP BY I.DTMOV,
              I.CODFILIAL,
              I.CODPROD
) SELECT DTULTINVENT,
         CODFILIAL,
         CODPROD,
         DESCRICAO,
         QT_GER,
         QT_END,
         DIF,
         BONUS_PEND,
         SEPARACAO_PEND,
         SITUACAO_SEP,
         DEVOLUCAO_PEND,
         (
             CASE
                 WHEN (DIF = BONUS_PEND
                     OR DIF = (BONUS_PEND + SEPARACAO_PEND)
                     OR DIF = (DEVOLUCAO_PEND + SEPARACAO_PEND + BONUS_PEND)) THEN 'OK'
                 WHEN (DIF = SEPARACAO_PEND
                     OR DIF = (DEVOLUCAO_PEND + SEPARACAO_PEND)
                     OR DIF = (DEVOLUCAO_PEND + SEPARACAO_PEND + BONUS_PEND)) THEN 'OK'
                 WHEN (DIF = DEVOLUCAO_PEND
                     OR DIF = (DEVOLUCAO_PEND + SEPARACAO_PEND)
                     OR DIF = (DEVOLUCAO_PEND + SEPARACAO_PEND + BONUS_PEND)) THEN 'OK'
                 ELSE 'ANALISAR'
             END
         ) AS STATUS
    FROM (
      SELECT A.DTULTINVENT,
             A.CODFILIAL,
             A.CODPROD,
             P.DESCRICAO,
             NVL (A.QT_GER, 0) AS QT_GER,
             A.QT_END,
             A.DIVERG AS DIF,
             B.DIF_ENT AS BONUS_PEND,
             P.QT AS SEPARACAO_PEND,
             P.STATUS AS SITUACAO_SEP,
             D.DIV_DEV AS DEVOLUCAO_PEND
        FROM ANALISE_EST_ENDERECADO_X_GER A
        LEFT JOIN PCPRODUT P ON A.CODPROD = P.CODPROD
        LEFT JOIN BONUS_DIVERGENTE B ON B.CODFILIAL = A.CODFILIAL
         AND B.CODPROD = A.CODPROD
         AND B.DATABONUS > A.DTULTINVENT
        LEFT JOIN PEDIDOS P ON P.CODFILIAL = A.CODFILIAL
         AND P.CODPROD = A.CODPROD
        LEFT JOIN DEVOLUCAO D ON D.CODFILIAL = A.CODFILIAL
         AND D.CODPROD = A.CODPROD
         AND D.DTMOV > A.DTULTINVENT
       WHERE A.CODFILIAL IN (
          7
      )
     /*([FILIAL])*/
       ORDER BY A.CODPROD
  )