CREATE OR REPLACE VIEW VIEW_JC_LOGISTICA_CORP AS
    WITH SEPARACAO AS (
        SELECT NUMPED,
               (
                   CASE
                       WHEN COUNT (NUMPED) > 0 THEN (SUM (PERC) / COUNT (NUMPED))
                       ELSE 0
                   END
               ) AS PERC_SEP,
               (
                   SELECT MAX (JCENDOS.DT_FIM)
                     FROM JCENDOS,
                          JCENDOSITEM
                    WHERE JCENDOS.ID = JCENDOSITEM.OS_ID
                      AND NUMPED = JCENDOSITEM.PEDIDO_ID
               ) AS DTFIM_SEP
          FROM (
            SELECT I.NUMPED,
                   I.CODPROD,
                   P.DESCRICAO,
                   (
                       CASE
                           WHEN (COUNT (I.CODPROD) > 0
                              AND SUM (I.QT) > 0) THEN (ROUND (((SUM (S.QTSEPARADA) / (SUM (I.QT) / COUNT (I.CODPROD))) * 100), 0
                              ))
                           ELSE 0
                       END
                   ) AS PERC
              FROM PCPEDI I
              LEFT JOIN JCITEMSEPARACAO S ON I.NUMPED = S.NUMPED
               AND I.CODPROD = S.CODPROD
              LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
             GROUP BY I.NUMPED,
                      I.CODPROD,
                      P.DESCRICAO
        )
         GROUP BY NUMPED
    ), CONFERENCIA AS (
        SELECT NUMPED,
               (
                   CASE
                       WHEN COUNT (NUMPED) > 0 THEN (SUM (PERC) / COUNT (NUMPED))
                       ELSE 0
                   END
               ) AS PERC_CONF,
               MAX (DTFIM_CONF) AS DTFIM_CONF
          FROM (
            SELECT I.NUMPED,
                   I.CODPROD,
                   P.DESCRICAO,
                   MAX (C.DATACONF) AS DTFIM_CONF,
                   (
                       CASE
                           WHEN (COUNT (I.CODPROD) > 0
                              AND SUM (I.QT) > 0) THEN (ROUND (((SUM (C.QTCONF) / (SUM (I.QT) / COUNT (I.CODPROD))) * 100), 0))
                           ELSE 0
                       END
                   ) AS PERC
              FROM PCPEDI I
              LEFT JOIN PCITEMLOTECONFERIDO C ON I.NUMPED = C.NUMPED
               AND I.CODPROD = C.CODPROD
              LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
             GROUP BY I.NUMPED,
                      I.CODPROD,
                      P.DESCRICAO
        )
         GROUP BY NUMPED
    ), FATURAMENTO AS (
        SELECT A.NUMNOTA,
               A.NUMVOLUME,
               A.NUMPED,
               A.VLTOTGER,
               DTHORAAUTORIZACAOSEFAZ AS DTFAT
          FROM PCNFSAID A
    ), EXPEDICAO AS (
        SELECT B.PEDIDO_ID AS NUMPED,
               MAX (B.VOLUME) AS VOL_CONF,
               MAX (B.DT_CONF) AS DT_EXPED
          FROM JCROMANEIOPEDVOL B
         INNER JOIN JCROMANEIOC C ON B.ROMANEIO_ID = C.ID
         GROUP BY B.PEDIDO_ID,
                  B.ROMANEIO_ID
    )
    SELECT CAST (P.CODFILIAL AS NUMBER) AS CODFILIAL,
           P.CODCLI,
           P.NUMPED,
           P.NUMPEDCLI,
           P.DATA,
           P.VLATEND,
           (
               CASE P.CONDVENDA
                   WHEN 1   THEN 'VENDA'
                   WHEN 8   THEN 'NOTA FILHA'
                   ELSE 'BONIFIC'
               END
           ) AS TIPOPEDIDO,
           S.PERC_SEP,
           S.DTFIM_SEP,
           C.PERC_CONF,
           C.DTFIM_CONF,
           F.NUMNOTA,
           F.DTFAT,
           F.NUMVOLUME,
           E.DT_EXPED,
           E.VOL_CONF
      FROM PCPEDC P
      LEFT JOIN SEPARACAO S ON P.NUMPED = S.NUMPED
      LEFT JOIN CONFERENCIA C ON P.NUMPED = C.NUMPED
      LEFT JOIN FATURAMENTO F ON P.NUMPED = F.NUMPED
      LEFT JOIN EXPEDICAO E ON P.NUMPED = E.NUMPED
     WHERE P.CONDVENDA IN (
        1, 5, 8
    )
       AND P.DATA >= TO_DATE ('01/01/2021', 'DD/MM/YYYY')
       AND P.CODFILIAL IN (
        5, 6
    );
/