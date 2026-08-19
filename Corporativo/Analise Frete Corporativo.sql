-- ============================================================
-- % de frete por nota de venda (CT-e vinculado à NF de saída)
-- Parâmetros:
--   :CODFILIAL    obrigatório -> código da filial, ex.: 6
--   :NUMNOTA_INI  opcional    -> nº inicial da nota de venda
--   :NUMNOTA_FIM  opcional    -> nº final da nota de venda
--   :ANO          obrigatório -> ano(s) da movimentação, ex.: 2025,2026
--   :CODREDE      opcional    -> rede do cliente (PCCLIENT.CODREDE)
-- ============================================================
SELECT CODFILIAL,
       NUMTRANSENT,
       DTMOV,
       CODCLI,
       CLIENTE,
       CODREDE,
       NUMNOTAVENDA,
       VLVENDA,
       VLCTE,
       ROUND((VLCTE / VLVENDA) * 100, 2) PERCFRETE,
       DTEMISSAO,
       NUMNOTA_CTE,
       CODFORNEC,
       FORNECEDOR
  FROM (SELECT E.CODFILIAL,
               E.NUMTRANSENT,
               NVL(S.DTSAIDA, E2.DTENT) DTMOV,
               NVL(S.CODCLI, E2.CODFORNEC) CODCLI,
               NVL(S.CLIENTE, E2.FORNECEDOR) CLIENTE,
               C.CODREDE,
               NVL(S.NUMNOTA, E2.NUMNOTA) AS NUMNOTAVENDA,
               NVL(S.VLTOTAL, E2.VLTOTAL) VLVENDA,
               ROUND((E.VLTOTAL / COUNT(E.NUMTRANSENT)
                      OVER (PARTITION BY E.NUMTRANSENT)), 2) VLCTE,
               E.DTEMISSAO,
               E.NUMNOTA AS NUMNOTA_CTE,
               E.CODFORNEC,
               T.FORNECEDOR
          FROM PCNFENT E
          JOIN PCFORNEC T ON T.CODFORNEC = E.CODFORNEC
          LEFT JOIN PCCONHECIMENTOFRETEI F ON F.NUMTRANSCONHEC = E.NUMTRANSENT
          LEFT JOIN PCNFSAID S ON S.CHAVENFE = F.CHAVENFE
          LEFT JOIN PCNFENT E2 ON E2.CHAVENFE = F.CHAVENFE
          LEFT JOIN PCCLIENT C ON C.CODCLI = S.CODCLI
         WHERE E.ESPECIE = 'CT'
           AND E.DTCANCEL IS NULL
           AND E.CODFILIAL = :CODFILIAL)
 WHERE (:NUMNOTA_INI IS NULL OR NUMNOTAVENDA >= :NUMNOTA_INI)
   AND (:NUMNOTA_FIM IS NULL OR NUMNOTAVENDA <= :NUMNOTA_FIM)
   AND EXTRACT(YEAR FROM DTMOV) IN (:ANO)
   AND (:CODREDE IS NULL OR CODREDE = :CODREDE)
