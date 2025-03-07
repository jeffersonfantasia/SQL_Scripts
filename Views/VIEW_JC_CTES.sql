CREATE OR REPLACE VIEW VIEW_JC_CTES AS
WITH FRETES AS
 (SELECT E.CODFILIAL,
         E.DTEMISSAO DTCTE,
         (CASE
           WHEN S.NUMTRANSVENDA IS NOT NULL THEN
            'S'
           WHEN E2.NUMTRANSENT IS NOT NULL THEN
            'E'
           ELSE
            'CT'
         END) TIPO,
         E.NUMNOTA NUMNOTA_CTE,
         E.CODFORNEC,
         T.FORNECEDOR TRANSPORTADORA,
         COALESCE(S.NUMTRANSVENDA, E2.NUMTRANSENT, 0) NUMTRANSACAO,
         COALESCE(S.CODCLI, E2.CODFORNEC, 10) CODCLI,
         ROUND((E.VLTOTAL / COUNT(E.NUMTRANSENT) OVER(PARTITION BY E.NUMTRANSENT)), 2) VLCTE
    FROM PCNFENT E
    JOIN PCFORNEC T ON T.CODFORNEC = E.CODFORNEC
    LEFT JOIN PCCONHECIMENTOFRETEI F ON F.NUMTRANSCONHEC = E.NUMTRANSENT
    LEFT JOIN PCNFSAID S ON S.CHAVENFE = F.CHAVENFE
    LEFT JOIN PCNFENT E2 ON E2.CHAVENFE = F.CHAVENFE
   WHERE E.ESPECIE = 'CT'
     AND E.DTCANCEL IS NULL)

SELECT CODFILIAL,
       CASE
         WHEN CODCLI = 10 THEN
          DTCTE
         ELSE
          MIN(DTCTE) OVER(PARTITION BY NUMTRANSACAO)
       END DATA,
       TIPO,
       NUMNOTA_CTE,
       CODFORNEC,
       CASE
         WHEN CODCLI = 10 THEN
          TRANSPORTADORA
         ELSE
          MIN(TRANSPORTADORA) OVER(PARTITION BY NUMTRANSACAO)
       END TRANSPORTADORA,
       NUMTRANSACAO,
       CODCLI,
       VLCTE,
       CASE
         WHEN CODCLI = 10 THEN
          1
         ELSE
          COUNT(NUMTRANSACAO) OVER(PARTITION BY NUMTRANSACAO)
       END QTCTESNOTA,
       CASE
         WHEN CODCLI = 10 THEN
          VLCTE
         ELSE
          SUM(VLCTE) OVER(PARTITION BY NUMTRANSACAO)
       END VLTOTALFRETE
  FROM FRETES

