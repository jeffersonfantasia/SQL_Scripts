SELECT DTSAIDA,
       CODFILIAL,
       FILIAL,
       NUMNOTA,
       TV,
       TIPO,
       CODCLI,
       CLIENTE,
       VLTOTGER,
       DTCANCEL,
       OBS
-- TESTE
  FROM (SELECT F.DTSAIDA,
               F.CODFILIAL,
               L.FANTASIA FILIAL,
               F.CONDVENDA TV,
               F.TIPOVENDA TIPO,
               F.NUMNOTA,
               F.CODCLI,
               C.FANTASIA CLIENTE,
               F.VLTOTGER,
               F.DTCANCEL,
               F.OBS,
               (CASE
                 WHEN ((F.CODFILIAL = 2 AND F.CODCLI = 7543 AND
                      F.CONDVENDA = 10) OR
                      (F.CODFILIAL = 1 AND F.CODCLI = 4 AND F.CONDVENDA = 10) OR
                      (F.CODFILIAL = 7 AND F.CODCLI = 82215 AND
                      F.CONDVENDA = 10)) THEN
                  1
                 WHEN ((F.CODFILIAL = 2 AND F.CODCLI = 4 AND F.CONDVENDA = 1) OR
                      (F.CODFILIAL = 2 AND F.CODCLI = 82215 AND
                      F.CONDVENDA = 1) OR
                      (F.CODFILIAL = 1 AND F.CODCLI = 7543 AND
                      F.CONDVENDA = 1) OR
                      (F.CODFILIAL = 1 AND F.CODCLI = 82215 AND
                      F.CONDVENDA = 1) OR
                      (F.CODFILIAL = 7 AND F.CODCLI = 4 AND F.CONDVENDA = 1) OR
                      (F.CODFILIAL = 7 AND F.CODCLI = 7543 AND
                      F.CONDVENDA = 1)) THEN
                  1
                 ELSE
                  0
               END) TESTE
          FROM PCNFSAID F, PCCLIENT C, PCFILIAL L
         WHERE F.CODCLI = C.CODCLI
           AND F.CODFILIAL = L.CODIGO
           AND F.TIPOVENDA <> 'SR'
           AND F.DTSAIDA >= TRUNC(SYSDATE) - 30
         ORDER BY F.DTSAIDA DESC)
 WHERE TESTE = 1;