CREATE OR REPLACE VIEW VIEW_JC_CUSTOLIQ_240 AS
    WITH TRIBUTACAO_ENTRADA AS (
        SELECT F.CODFIGURA,
               NVL (F.PERPIS, 0) / 100 AS PERPIS,
               NVL (F.PERCOFINS, 0) / 100 AS PERCOFINS,
               NVL (F.PERCICMRED, 0) / 100 AS PERCICMRED,
               NVL (F.PERCICM, 0) / 100 AS PERCICM,
               NVL (F.PERCREDICMS, 0) / 100 AS PERCREDICMS,
               NVL (F.PERIPI, 0) / 100 AS PERIPI,
               NVL (F.PERCIVA, 0) / 100 AS PERCIVA,
               NVL (F.PERCALIQEXTGUIA, 0) / 100 AS PERCALIQEXTGUIA,
               NVL (F.PERCALIQEXT, 0) / 100 AS PERCALIQEXT,
               NVL (F.PERCALIQINT, 0) / 100 AS PERCALIQINT,
               NVL (F.REDBASEALIQEXT, 0) / 100 AS REDBASEALIQEXT,
               (
                   CASE
                       WHEN F.PERCICMRED = 0 THEN F.PERCICM / 100
                       ELSE F.PERCICMRED / 100
                   END
               ) AS PRECICMS_ESCOLHIDO,
               (
                   CASE
                       WHEN F.PERCICMRED = 0 THEN F.PERCREDICMS / 100
                       ELSE F.PERCICMRED / 100
                   END
               ) AS PRECCREDICMS_ESCOLHIDO
          FROM PCTRIBFIGURA F
    ), CUSTO_COMPRA AS (
        SELECT P.CODFILIAL,
               P.CODPROD,
               ROUND (NVL ((P.CUSTOREP * (1 - P.PERCDESC)), 0), 4) AS PCOMPRA,
               ROUND (NVL ((P.CUSTOREP * (1 - P.PERCDESC)), 0), 6) AS PLIQCOMPRA
          FROM (
            SELECT P.CODFILIAL,
                   P.CODPROD,
                   P.CUSTOREP,
                   1 - ((1 - P.PERCDESC1 / 100) * (1 - P.PERCDESC2 / 100) * (1 - P.PERCDESC3 / 100) * (1 - P.PERCDESC4 / 100) * (
                   1 - P.PERCDESC5 / 100) * (1 - P.PERCDESC6 / 100) * (1 - P.PERCDESC7 / 100) * (1 - P.PERCDESC8 / 100) * (1 - P.
                   PERCDESC9 / 100) * (1 - P.PERCDESC10 / 100)) PERCDESC
              FROM PCPRODFILIAL P
        ) P
    ), CALCULOS_CUSTO AS (
        SELECT E.CODFILIAL,
               P.CODPROD,
               P.CODFORNEC,
               F.EQUIPINDUSTRIA,
               P.CODNCMEX,
               F.TIPOFORNEC,
               F.ESTADO,
               E.CODFIGURA,
               C.PCOMPRA,
               C.PLIQCOMPRA,
               ROUND ((C.PLIQCOMPRA * T.PRECCREDICMS_ESCOLHIDO), 6) AS VLCREDICMS,
               PRECICMS_ESCOLHIDO,
               PRECCREDICMS_ESCOLHIDO,
               T.PERPIS,
               T.PERCOFINS,
               T.PERCICM,
               T.PERCICMRED,
               T.PERCREDICMS,
               (
                   CASE
                       WHEN (F.EQUIPINDUSTRIA = 'N'
                          AND F.TIPOFORNEC = 'D') THEN 0
                       ELSE T.PERIPI
                   END
               ) AS PERIPI,
               T.PERCIVA,
               T.PERCALIQEXT,
               T.PERCALIQINT,
               T.PERCALIQEXTGUIA,
               T.REDBASEALIQEXT,
               (T.PERCALIQINT * T.REDBASEALIQEXT) AS PERCALIQSTRED
          FROM PCPRODUT P
         INNER JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
         INNER JOIN PCTRIBENTRADA E ON P.CODNCMEX = E.NCM
           AND F.TIPOFORNEC = E.TIPOFORNEC
           AND F.ESTADO = E.UFORIGEM
          LEFT JOIN TRIBUTACAO_ENTRADA T ON E.CODFIGURA = T.CODFIGURA
          LEFT JOIN CUSTO_COMPRA C ON P.CODPROD = C.CODPROD
           AND E.CODFILIAL = C.CODFILIAL
         WHERE F.TIPOFORNEC NOT IN (
            'C', 'O'
        )
    ), BASEPISCOFINS_VLIPI AS (
        SELECT ROUND ((C.PLIQCOMPRA * (1 - C.PRECICMS_ESCOLHIDO) + (C.PLIQCOMPRA * C.PERIPI)), 6) AS BASEPISCOFINS,
               (C.PLIQCOMPRA * C.PERIPI) AS VLIPI,
               C.*
          FROM CALCULOS_CUSTO C
    ), VALORPISCOFINS AS (
        SELECT ROUND ((C.BASEPISCOFINS * C.PERPIS), 6) AS VLCREDPIS,
               ROUND ((C.BASEPISCOFINS * C.PERCOFINS), 6) AS VLCREDCOFINS,
               C.*
          FROM BASEPISCOFINS_VLIPI C
    ), BASEICMSST AS (
        SELECT (((C.PLIQCOMPRA + C.VLIPI) * C.PERCIVA) + (C.PLIQCOMPRA + C.VLIPI)) AS BASEICMSST,
               C.*
          FROM VALORPISCOFINS C
    ), VALORICMSST AS (
        SELECT (
            CASE
                WHEN C.PERCALIQSTRED = 0 THEN ROUND (((C.BASEICMSST * C.PERCALIQINT) - (C.PLIQCOMPRA * C.PERCALIQEXT)), 4)
                ELSE ROUND (((C.BASEICMSST * C.PERCALIQINT) - (C.PLIQCOMPRA * C.PERCALIQSTRED)), 4)
            END
        ) VLICMSST,
               C.*
          FROM BASEICMSST C
    ), PRECOBRUTO AS (
        SELECT (
            CASE
                WHEN PERCALIQEXTGUIA = 0 THEN ROUND ((C.PLIQCOMPRA + C.VLIPI + C.VLICMSST), 6)
                ELSE ROUND ((C.PLIQCOMPRA + C.VLIPI), 6)
            END
        ) AS PBRUTO,
               C.*
          FROM VALORICMSST C
    )
    SELECT (
        CASE
            WHEN C.PERCALIQEXTGUIA = 0 THEN ROUND ((C.PBRUTO - C.VLCREDPIS - VLCREDCOFINS - C.VLCREDICMS), 4)
            ELSE ROUND ((C.PBRUTO + C.VLICMSST - C.VLCREDPIS - VLCREDCOFINS - C.VLCREDICMS), 4)
        END
    ) AS PLIQUIDO,
           C.*
      FROM PRECOBRUTO C
        /* WHERE C.CODFILIAL = 7*/
      /* AND C.CODPROD IN( 796177, 803349)*/;
/