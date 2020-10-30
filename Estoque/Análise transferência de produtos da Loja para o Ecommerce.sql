SELECT CODPROD,
       DESCRICAO,
       DTULTENT_1,
       VALORULTENT_1,
       QTDISPONIVEL_1,
       QTDISPONIVEL_2,
       QTDISPONIVEL_7,
       QTVENDIDA_7
  FROM (
    SELECT CODPROD,
           DESCRICAO,
           (QTVENDMES + QTVENDMES1 + QTVENDMES2 + QTVENDMES3) QTVENDIDA_7,
           DTULTENT_1,
           VALORULTENT_1,
           (QTESTGER_1 - QTRESERV_1 - QTBLOQUEADA_1) QTDISPONIVEL_1,
           (QTESTGER - QTRESERV - QTBLOQUEADA) QTDISPONIVEL_7,
           (QTESTGER_2 - QTRESERV_2 - QTBLOQUEADA_2) QTDISPONIVEL_2
      FROM (
        SELECT P.CODPROD,
               P.DESCRICAO,
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
                      AND PCEST.CODFILIAL = 1
               ) DTULTENT_1,
               (
                   SELECT ROUND (PCEST.VALORULTENT, 2)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 1
               ) VALORULTENT_1,
               (
                   SELECT NVL (PCEST.QTESTGER, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 1
               ) QTESTGER_1,
               (
                   SELECT NVL (PCEST.QTRESERV, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 1
               ) QTRESERV_1,
               (
                   SELECT NVL (PCEST.QTBLOQUEADA, 0)
                     FROM PCEST
                    WHERE PCEST.CODPROD = P.CODPROD
                      AND PCEST.CODFILIAL = 1
               ) QTBLOQUEADA_1,
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
           AND E.CODFILIAL = 7
    )
)
 WHERE QTDISPONIVEL_1 >= 1
   AND QTDISPONIVEL_7 <= 0
   AND QTDISPONIVEL_2 <= 0
 ORDER BY QTVENDIDA_7 DESC,
          QTDISPONIVEL_1 DESC;
/