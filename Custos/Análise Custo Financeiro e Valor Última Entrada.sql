SELECT *
  FROM (
    SELECT N.CODFILIAL,
           N.DTCADASTRO,
           N.CODMASTER,
           N.CODPROD,
           N.PRODUTO,
           N.NCM,
           N.DTULTENT_1103,
           N.DTULTALT_240,
           N.REGIME_ICMS,
           N.VLULTENT_MASTER,
           ROUND ((N.CUSTOREP_MASTER * ((100 - N.PERCDESC_MASTER) / 100)), 4) PBRUTOMASTER_240,
           N.VLULTENT_1103,
              /* N.VLIPIULTENT_MASTER,*/
              /* N.VLSTULTENT_MASTER,*/
           N.VLULTENTLIQ,
           N.PBRUTO_240,
           ROUND ((N.VLULTENTLIQ / PBRUTO_240_CALC) * 100, 2) DIFBRUTO,
           N.CUSTOFIN_MASTER,
           N.CUSTOFIN_1103,
           N.CUSTOLIQMASTER_240,
           N.CUSTOLIQ_240,
           ROUND ((N.CUSTOFIN_1103_CALC / CUSTOLIQ_240_CALC) * 100, 2) DIFFIN,
           N.QTESTGER
      FROM
       /*---------------TABELA N---------------*/
       (
        SELECT E.CODFILIAL,
               P.DTCADASTRO,
               P.CODPRODMASTER CODMASTER,
               E.CODPROD,
               P.DESCRICAO PRODUTO,
               P.CODNCMEX NCM,
               E.QTESTGER,
               E.DTULTENT DTULTENT_1103,
               F.DTULTATUPCOMPRA DTULTALT_240,
               F.GERAICMSLIVROFISCAL REGIME_ICMS,
               TAB.VLULTENT_MASTER,
               ROUND (NVL (E.VALORULTENT, 0), 4) VLULTENT_1103,
               (
                   CASE
                       WHEN NVL (E.VALORULTENT, 0) = 0 THEN 1
                       ELSE E.CUSTOFIN
                   END
               ) VLULTENT_1103_CALC,
               NVL (VLIPIULTENT_MASTER, 0) VLIPIULTENT_MASTER,
               NVL (VLSTULTENT_MASTER, 0) VLSTULTENT_MASTER,
               (
                   CASE F.GERAICMSLIVROFISCAL
                       WHEN 'S'   THEN NVL (E.VALORULTENT, 0) - NVL (VLIPIULTENT_MASTER, 0)
                       WHEN 'N'   THEN NVL (E.VALORULTENT, 0) - NVL (VLIPIULTENT_MASTER, 0) - NVL (VLSTULTENT_MASTER, 0)
                   END
               ) VLULTENTLIQ,
               (
                   SELECT CUSTOREP
                     FROM PCPRODFILIAL
                    WHERE CODPROD = P.CODPRODMASTER
                      AND CODFILIAL = E.CODFILIAL
               ) CUSTOREP_MASTER,
               (
                   SELECT PERCDESC
                     FROM PCPRODFILIAL
                    WHERE CODPROD = P.CODPRODMASTER
                      AND CODFILIAL = E.CODFILIAL
               ) PERCDESC_MASTER,
               ROUND ((F.CUSTOREP * ((100 - F.PERCDESC) / 100)), 4) PBRUTO_240,
               (
                   CASE
                       WHEN (F.CUSTOREP * ((100 - F.PERCDESC) / 100)) = 0 THEN (
                           CASE
                               WHEN NVL (E.VALORULTENT, 0) = 0 THEN 1
                               ELSE E.CUSTOFIN
                           END
                       )
                       ELSE ROUND ((F.CUSTOREP * ((100 - F.PERCDESC) / 100)), 4)
                   END
               ) PBRUTO_240_CALC,
               CUSTOFIN_MASTER,
               ROUND (E.CUSTOFIN, 4) CUSTOFIN_1103,
               (
                   CASE
                       WHEN NVL (E.CUSTOFIN, 0) = 0 THEN 1
                       ELSE E.CUSTOFIN
                   END
               ) CUSTOFIN_1103_CALC,
               ROUND (E.CUSTOPROXIMACOMPRA, 4) CUSTOLIQ_240,
               (
                   SELECT ROUND (CUSTOPROXIMACOMPRA, 4)
                     FROM PCEST
                    WHERE CODPROD = P.CODPRODMASTER
                      AND CODFILIAL = E.CODFILIAL
               ) CUSTOLIQMASTER_240,
               NVL ((
                   CASE
                       WHEN E.CUSTOPROXIMACOMPRA = 0 THEN (
                           CASE
                               WHEN NVL (E.CUSTOFIN, 0) = 0 THEN 1
                               ELSE E.CUSTOFIN
                           END
                       )
                       ELSE ROUND (E.CUSTOPROXIMACOMPRA, 4)
                   END
               ), 1) CUSTOLIQ_240_CALC
          FROM PCEST E,
               PCPRODUT P,
               PCPRODFILIAL F,
           /*----TABELA TAB ----------------------   */
               (
                   SELECT E.CODFILIAL,
                          P.CODPRODMASTER,
                          E.CODPROD,
                          E.VALORULTENT,
                          E.VLIPIULTENT,
                          E.VLSTULTENT,
                          E.CUSTOFIN,
                          ROUND ((
                              SELECT VALORULTENT
                                FROM PCEST
                               WHERE PCEST.CODPROD = P.CODPRODMASTER
                                 AND PCEST.CODFILIAL = E.CODFILIAL
                          ), 4) VLULTENT_MASTER,
                          (
                              CASE
                                  WHEN (
                                      SELECT NVL (VLIPIULTENT, 0)
                                        FROM PCEST
                                       WHERE PCEST.CODPROD = P.CODPRODMASTER
                                         AND PCEST.CODFILIAL = 2
                                  ) = 0 THEN (
                                      SELECT NVL (VLIPIULTENT, 0)
                                        FROM PCEST
                                       WHERE PCEST.CODPROD = P.CODPRODMASTER
                                         AND PCEST.CODFILIAL = 1
                                  )
                                  ELSE (
                                      SELECT NVL (VLIPIULTENT, 0)
                                        FROM PCEST
                                       WHERE PCEST.CODPROD = P.CODPRODMASTER
                                         AND PCEST.CODFILIAL = 2
                                  )
                              END
                          ) VLIPIULTENT_MASTER,
                          (
                              CASE
                                  WHEN (
                                      SELECT NVL (VLSTULTENT, 0)
                                        FROM PCEST
                                       WHERE PCEST.CODPROD = P.CODPRODMASTER
                                         AND PCEST.CODFILIAL = 2
                                  ) = 0 THEN (
                                      SELECT NVL (VLSTULTENT, 0)
                                        FROM PCEST
                                       WHERE PCEST.CODPROD = P.CODPRODMASTER
                                         AND PCEST.CODFILIAL = 1
                                  )
                                  ELSE (
                                      SELECT NVL (VLSTULTENT, 0)
                                        FROM PCEST
                                       WHERE PCEST.CODPROD = P.CODPRODMASTER
                                         AND PCEST.CODFILIAL = 2
                                  )
                              END
                          ) VLSTULTENT_MASTER,
                          ROUND ((
                              SELECT CUSTOFIN
                                FROM PCEST
                               WHERE PCEST.CODPROD = P.CODPRODMASTER
                                 AND PCEST.CODFILIAL = E.CODFILIAL
                          ), 4) CUSTOFIN_MASTER,
                          E.QTEST
                     FROM PCEST E,
                          PCPRODUT P
                    WHERE E.CODPROD = P.CODPROD
               ) TAB
         /*-----------------------------------------------------------------*/
         WHERE P.CODPROD = E.CODPROD
           AND E.CODPROD = F.CODPROD
           AND E.CODFILIAL = F.CODFILIAL
           AND TAB.CODPROD = E.CODPROD
           AND TAB.CODFILIAL = E.CODFILIAL
           AND P.DTEXCLUSAO IS NULL
           AND P.TIPOMERC = 'L'
           AND P.REVENDA = 'S'
           AND P.CODFORNEC NOT IN (
            305
        )
           AND E.QTEST > 0
    ) N
           /*-------------------------------------------------------------------*/
)
 WHERE ((DIFBRUTO <> 100
   AND DIFBRUTO <> 100.01)
   AND DIFBRUTO <> 99.99)
   AND DIFFIN = 100
   AND CUSTOLIQMASTER_240 <> 0
 ORDER BY DTULTENT_1103 DESC,
          DIFFIN,
          CODMASTER DESC,
          DTCADASTRO DESC,
          CODPROD,
          CODFILIAL;
/