SELECT *
  FROM (
    SELECT M.CODFILIAL,
           M.DTMOV,
           F.NUMPED,
           M.NUMTRANSVENDA,
           F.CODCLI,
           F.CLIENTE,
           M.CODPROD,
           P.DESCRICAO,
           M.CODUSUR,
           U.USURDIRFV AS VENDEDOR,
           V.CODGERENTE,
           M.PERCOM,
           (
               CASE
                   WHEN M.CODUSUR IN (18, 34, 17, 56, 64)
                   THEN 0
                   WHEN V.CODGERENTE = 1 THEN 3.2
                   WHEN V.CODGERENTE = 3 THEN 0.5
                   ELSE 0
               END
           ) PERCORRETO
      FROM PCNFSAID F,
           PCMOV M,
           PCPRODUT P,
           PCUSUARI U,
           PCSUPERV V,
           PCPEDC C
     WHERE M.CODPROD = P.CODPROD
       AND F.NUMTRANSVENDA = M.NUMTRANSVENDA
       AND U.CODUSUR = M.CODUSUR
       AND V.CODSUPERVISOR = U.CODSUPERVISOR
       AND C.NUMPED = F.NUMPED
       AND M.CODOPER = 'S'
       AND F.DTCANCEL IS NULL
       AND F.CONDVENDA = 1
     GROUP BY M.CODFILIAL,
              M.DTMOV,
              F.NUMPED,
              M.NUMTRANSVENDA,
              F.CODCLI,
              F.CLIENTE,
              M.CODPROD,
              P.DESCRICAO,
              M.CODUSUR,
              U.USURDIRFV,
              U.NOME,
              V.CODGERENTE,
              M.PERCOM
)
 WHERE DTMOV >= TRUNC (SYSDATE) - 30
   AND PERCOM <> PERCORRETO
 ORDER BY DTMOV DESC,
          CODGERENTE
/