SELECT A.*,
       PCEMPR.NOME
  FROM (
    SELECT DISTINCT PCEST.CODFILIAL FILIAL,
                    PCEST.CODPROD,
                    PCPRODUT.DESCRICAO PRODUTO,
                    PCPRODUT.CODEPTO DEPTO,
                    PCPRODUT.EMBALAGEM,
                    PCPRODUT.UNIDADE,
                    CASE
                        WHEN ((PCPRODUT.OBS2 = 'FL')
                           AND (PCPRODFILIAL.FORALINHA = 'S')) THEN 'S'
                        ELSE 'N'
                    END FORADELINHA,
                    NVL (PCEST.QTESTGER, 0) QTESTGER,
                    NVL (PCEST.QTRESERV, 0) QTRESERV,
                    NVL (PCEST.QTBLOQUEADA, 0) QTBLOQUEADA,
                    NVL (PCEST.QTINDENIZ, 0) QTINDENIZ,
                    NVL ((NVL (PCEST.QTESTGER, 0) - NVL (PCEST.QTRESERV, 0) - NVL (PCEST.QTBLOQUEADA, 0)), 0) QTDISP,
                    PCEST.MOTIVOBLOQESTOQUE,
                    TRUNC (PCEST.DTULTENT) DATAULTENT
                        /*, NVL(TRUNC(BLOQ.DTDESBLOQUEIO),PCEST.DTULTENT) DTBLOQUEIO*/
                    ,
                    CASE
                        WHEN (
                            SELECT LIBERAESTENTMERC
                              FROM PCCONSUM
                        ) = 'N' THEN GREATEST (PCEST.DTULTENT, NVL (TRUNC (BLOQ.DTDESBLOQUEIO), PCEST.DTULTENT))
                        ELSE NVL (TRUNC (BLOQ.DTDESBLOQUEIO), PCEST.DTULTENT)
                    END AS DTBLOQUEIO,
                    CASE
                        WHEN (TRUNC (BLOQ.DTDESBLOQUEIO) >= PCMOV.DTMOV) THEN TRUNC (SYSDATE) - NVL (TRUNC (TRUNC (BLOQ.DTDESBLOQUEIO
                        )), TRUNC (SYSDATE))
                        ELSE TRUNC (SYSDATE) - NVL (TRUNC (TRUNC (PCMOV.DTMOV)), TRUNC (SYSDATE))
                    END AS DIAS,
                    CASE
                        WHEN (TRUNC (BLOQ.DTDESBLOQUEIO) >= PCMOV.DTMOV) THEN BLOQ.CODFUNCDESBLOQUEIO
                        ELSE PCMOV.CODFUNCLANC
                    END AS MATRICULA,
                    PCMOV.CODOPER
      FROM PCEST,
           PCPRODUT,
           PCFORNEC,
           PCFILIAL,
           PCPRODFILIAL,
           PCMOV,
           (
               SELECT PCLOGDESBLOQUEIO.CODPROD,
                      PCLOGDESBLOQUEIO.CODFUNCDESBLOQUEIO,
                      PCLOGDESBLOQUEIO.DTDESBLOQUEIO,
                      PCLOGDESBLOQUEIO.CODFILIAL
                 FROM PCLOGDESBLOQUEIO,
                      (
                          SELECT MAX (PCLOGDESBLOQUEIO.DTDESBLOQUEIO) DTDESBLOQUEIO,
                                 PCLOGDESBLOQUEIO.CODPROD
                            FROM PCLOGDESBLOQUEIO
                           WHERE PCLOGDESBLOQUEIO.QTBLOQUEADA > 0
                           GROUP BY PCLOGDESBLOQUEIO.CODPROD
                      ) LOGDES
                WHERE LOGDES.CODPROD = PCLOGDESBLOQUEIO.CODPROD
                  AND LOGDES.DTDESBLOQUEIO = PCLOGDESBLOQUEIO.DTDESBLOQUEIO
           ) BLOQ
     WHERE PCEST.CODPROD = PCPRODUT.CODPROD
       AND PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
       AND PCEST.CODFILIAL = PCFILIAL.CODIGO
       AND PCEST.CODPROD = BLOQ.CODPROD (+)
       AND PCEST.CODFILIAL = BLOQ.CODFILIAL (+)
       AND PCEST.CODPROD = PCPRODFILIAL.CODPROD
       AND PCEST.CODFILIAL = PCPRODFILIAL.CODFILIAL
       AND ((PCPRODUT.REVENDA = 'S'))
    /* OR ('N' = '[SOMENTEPRODUTOREVENDA]'))*/
       AND (PCEST.DTULTENT <= TRUNC (SYSDATE) - 2
        OR PCEST.DTULTENT IS NULL)
       AND ((PCEST.CODFILIAL IN (
        1
    )))
     /*OR ('99' IN ([ FILIAL ])))*/
       AND NVL (PCEST.QTBLOQUEADA, 0) <> 0
           /*AND ((NVL(PCEST.QTBLOQUEADA, 0) - NVL(QTINDENIZ, 0)) <> 0)*/
       AND PCEST.NUMTRANSENTULTENT = PCMOV.NUMTRANSENT
       AND PCEST.CODFILIAL = PCMOV.CODFILIAL
       AND PCEST.CODPROD = PCMOV.CODPROD
     ORDER BY TRUNC (SYSDATE) - NVL (TRUNC (PCEST.DTULTENT), TRUNC (SYSDATE)) DESC
) A,
       PCEMPR
 WHERE A.MATRICULA = PCEMPR.MATRICULA (+)
/* AND MOTIVOBLOQESTOQUE = 'PERICIA'*/
/