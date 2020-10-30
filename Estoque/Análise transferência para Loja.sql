SELECT CODPROD,
       DESCRICAO,
       DTULTENT_7,
       VALORULTENT_7_2,
       QTDISPONIVEL_7,
       QTDISPONIVEL_2,
       QTDISPONIVEL_1,
       QTVENDIDA_1
  FROM (
    SELECT CODPROD,
           DESCRICAO,
           (QTVENDMES + QTVENDMES1 + QTVENDMES2 + QTVENDMES3) QTVENDIDA_1,
           DTULTENT_7,
           (
               CASE
                   WHEN VALORULTENT_7 IS NULL THEN VALORULTENT_2
                   ELSE VALORULTENT_7
               END
           ) VALORULTENT_7_2,
           (QTESTGER_7 - QTRESERV_7 - QTBLOQUEADA_7) QTDISPONIVEL_7,
           (QTESTGER - QTRESERV - QTBLOQUEADA) QTDISPONIVEL_1,
           (QTESTGER_2 - QTRESERV_2 - QTBLOQUEADA_2) QTDISPONIVEL_2
      FROM (
        SELECT P.CODPROD,
               P.DESCRICAO,
               P.CODCATEGORIA,
               NVL (E.QTESTGER, 0) QTESTGER,
               NVL (E.QTRESERV, 0) QTRESERV,
               NVL (E.QTBLOQUEADA, 0) QTBLOQUEADA,
               E.QTVENDMES,
               E.QTVENDMES1,
               E.QTVENDMES2,
               E.QTVENDMES3,
               (
                   SELECT PCEST.DTULTENT
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 7
               ) DTULTENT_7,
               (
                   SELECT ROUND (PCEST.VALORULTENT, 2)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 7
               ) VALORULTENT_7,
               (
                   SELECT NVL (PCEST.QTESTGER, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 7
               ) QTESTGER_7,
               (
                   SELECT NVL (PCEST.QTRESERV, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 7
               ) QTRESERV_7,
               (
                   SELECT NVL (PCEST.QTBLOQUEADA, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 7
               ) QTBLOQUEADA_7,
               (
                   SELECT ROUND (PCEST.VALORULTENT, 2)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 2
               ) VALORULTENT_2,
               (
                   SELECT NVL (PCEST.QTESTGER, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 2
               ) QTESTGER_2,
               (
                   SELECT NVL (PCEST.QTRESERV, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 2
               ) QTRESERV_2,
               (
                   SELECT NVL (PCEST.QTBLOQUEADA, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 2
               ) QTBLOQUEADA_2
          FROM PCPRODUT P,
               PCEST E
         WHERE E.CODPROD = P.CODPROD
           AND P.CODCATEGORIA NOT IN (
            4000, 4011, 4012, 4013, 4014, 4015, 4030
        )
     /*PUERICULTURA PESADA*/
           AND P.CODSEC NOT IN (
            300, 301
        )
     /*BOLSAS E MOCHILAS , LANCHEIRAS E ESTOJOS*/
           AND P.CODEPTO NOT IN (
            97
        )
     /*MATERIAL EMBALAGENS*/
           AND E.CODFILIAL = 1
    )
)
 WHERE QTDISPONIVEL_1 <= 0
   AND (QTDISPONIVEL_7 >= 1
    OR QTDISPONIVEL_2 > 0)
   AND QTVENDIDA_1 >= 0
 ORDER BY QTVENDIDA_1 DESC,
          QTDISPONIVEL_7 DESC,
          QTDISPONIVEL_2 DESC;
/