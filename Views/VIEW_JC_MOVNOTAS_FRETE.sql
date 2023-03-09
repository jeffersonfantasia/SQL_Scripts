CREATE OR REPLACE VIEW VIEW_JC_MOVNOTAS_FRETE AS 
  WITH BASEMOVENT AS
   (SELECT M.DTMOV DATA,
           E.CODFILIAL,
           M.NUMTRANSENT NUMTRANSACAO,
           E.CODFORNEC CODCLI,
           M.CODFISCAL,
           'SEM TRANSPORTADORA' TRANSPORTADORA,
           NVL(E.CODUSURDEVOL, 0) AS CODUSUR,
           SUM(ROUND(M.QTCONT *
                     (M.PUNITCONT + NVL(M.VLFRETE, 0) + NVL(M.VLOUTROS, 0)),
                     2)) AS VLTOTAL
      FROM PCMOV M
      JOIN PCNFENT E ON E.NUMTRANSENT = M.NUMTRANSENT
     WHERE M.DTCANCEL IS NULL
       AND M.CODFISCAL IS NOT NULL
       AND M.NUMTRANSENT IS NOT NULL
       AND E.CODFILIAL NOT IN (3, 4)
      -- AND M.DTMOV >= TO_DATE('01/01/2017', 'DD/MM/YYYY')
     GROUP BY M.DTMOV, E.CODFILIAL, M.NUMTRANSENT, E.CODFORNEC, M.CODFISCAL, E.CODUSURDEVOL),
  BASEMOVSAID AS
   (SELECT M.DTMOV DATA,
           S.CODFILIAL,
           M.NUMTRANSVENDA NUMTRANSACAO,
           S.CODCLI,
           M.CODFISCAL,
           S.TRANSPORTADORA,
           NVL(S.CODUSUR, 0) AS CODUSUR,
           SUM(ROUND(M.QTCONT *
                     (M.PUNITCONT + NVL(M.VLFRETE, 0) + NVL(M.VLOUTROS, 0)),
                     2)) AS VLTOTAL
      FROM PCMOV M
      JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSVENDA
     WHERE M.DTCANCEL IS NULL
       AND M.CODFISCAL IS NOT NULL
       AND M.NUMTRANSVENDA IS NOT NULL
       AND S.CODFILIAL NOT IN (3, 4)
     --  AND M.DTMOV >= TO_DATE('01/01/2017', 'DD/MM/YYYY')
     GROUP BY M.DTMOV, S.CODFILIAL, M.NUMTRANSVENDA, S.CODCLI, M.CODFISCAL, S.TRANSPORTADORA, S.CODUSUR)

  --NOTAS DE ENTRADA - DEV CLIENTE--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         E.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN E.TOTPESO >= 150000 THEN
            6
           WHEN E.TOTPESO >= 100000 THEN
            5
           WHEN E.TOTPESO >= 60000 THEN
            4
           WHEN E.TOTPESO >= 40000 THEN
            3
           WHEN E.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'DEV. CLIENTE' TIPO
    FROM BASEMOVENT M
    JOIN PCNFENT E ON E.NUMTRANSENT = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (1202, 1411, 2202, 2411)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, E.TOTPESO, M.TRANSPORTADORA
  UNION ALL
  --NOTAS DE ENTRADA - DEV. REM AMOSTRA--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         E.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN E.TOTPESO >= 150000 THEN
            6
           WHEN E.TOTPESO >= 100000 THEN
            5
           WHEN E.TOTPESO >= 60000 THEN
            4
           WHEN E.TOTPESO >= 40000 THEN
            3
           WHEN E.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'DEV. AMOSTRAS' TIPO
    FROM BASEMOVENT M
    JOIN PCNFENT E ON E.NUMTRANSENT = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (1912, 1913, 2912, 2913)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, E.TOTPESO, M.TRANSPORTADORA
  UNION ALL
  --NOTAS DE ENTRADA - RETORNO DE CONSERTO--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         E.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN E.TOTPESO >= 150000 THEN
            6
           WHEN E.TOTPESO >= 100000 THEN
            5
           WHEN E.TOTPESO >= 60000 THEN
            4
           WHEN E.TOTPESO >= 40000 THEN
            3
           WHEN E.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'RETORNO CONSERTO' TIPO
    FROM BASEMOVENT M
    JOIN PCNFENT E ON E.NUMTRANSENT = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (1915, 1916, 2915, 2916)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, E.TOTPESO, M.TRANSPORTADORA

  UNION ALL
  --NOTAS DE SAIDA - VENDA--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         S.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN S.TOTPESO >= 150000 THEN
            6
           WHEN S.TOTPESO >= 100000 THEN
            5
           WHEN S.TOTPESO >= 60000 THEN
            4
           WHEN S.TOTPESO >= 40000 THEN
            3
           WHEN S.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'VENDA' TIPO
    FROM BASEMOVSAID M
    JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (5102,
                   5109,
                   5403,
                   5405,
                   6102,
                   6108,
                   6403,
                   5120,
                   6120,
                   5923,
                   6923,
                   5117,
                   6117)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, S.TOTPESO, M.TRANSPORTADORA
  UNION ALL
  --NOTAS DE SAIDA - REM. AMOSTRAS--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         S.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN S.TOTPESO >= 150000 THEN
            6
           WHEN S.TOTPESO >= 100000 THEN
            5
           WHEN S.TOTPESO >= 60000 THEN
            4
           WHEN S.TOTPESO >= 40000 THEN
            3
           WHEN S.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'REM. AMOSTRAS' TIPO
    FROM BASEMOVSAID M
    JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (5912, 6912)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, S.TOTPESO, M.TRANSPORTADORA
  UNION ALL
  --NOTAS DE SAIDA - REM. CONSERTO--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         S.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN S.TOTPESO >= 150000 THEN
            6
           WHEN S.TOTPESO >= 100000 THEN
            5
           WHEN S.TOTPESO >= 60000 THEN
            4
           WHEN S.TOTPESO >= 40000 THEN
            3
           WHEN S.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'REM. CONSERTO' TIPO
    FROM BASEMOVSAID M
    JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (5915, 5916, 6915, 6916)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, S.TOTPESO, M.TRANSPORTADORA
  UNION ALL
  --NOTAS DE SAIDA - BONIFICACAO E SIMPLES REMESSA--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         S.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN S.TOTPESO >= 150000 THEN
            6
           WHEN S.TOTPESO >= 100000 THEN
            5
           WHEN S.TOTPESO >= 60000 THEN
            4
           WHEN S.TOTPESO >= 40000 THEN
            3
           WHEN S.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'BONIFICACAO' TIPO
    FROM BASEMOVSAID M
    JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (5910, 6910, 6911, 5949, 6949)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, S.TOTPESO, M.TRANSPORTADORA
   UNION ALL
  --NOTAS DE SAIDA -DEV. AO FORNECEDOR--
  SELECT M.DATA,
         M.CODFILIAL,
         M.NUMTRANSACAO,
         M.CODCLI,
         M.CODUSUR,
         M.TRANSPORTADORA,
         S.TOTPESO PESO,
         SUM(M.VLTOTAL) VLTOTAL,
         (CASE
           WHEN SUM(M.VLTOTAL) >= 20000 THEN
            6
           WHEN SUM(M.VLTOTAL) >= 10000 THEN
            5
           WHEN SUM(M.VLTOTAL) >= 5000 THEN
            4
           WHEN SUM(M.VLTOTAL) >= 2000 THEN
            3
           WHEN SUM(M.VLTOTAL) >= 1000 THEN
            2
           ELSE
            1
         END) TIPOFAT,
         (CASE
           WHEN S.TOTPESO >= 150000 THEN
            6
           WHEN S.TOTPESO >= 100000 THEN
            5
           WHEN S.TOTPESO >= 60000 THEN
            4
           WHEN S.TOTPESO >= 40000 THEN
            3
           WHEN S.TOTPESO >= 20000 THEN
            2
           ELSE
            1
         END) TIPOPESO,
         'DEV. AO FORNECEDOR' TIPO
    FROM BASEMOVSAID M
    JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSACAO
   WHERE M.CODFISCAL IN (5202, 5209, 5411, 6202, 6411)
   GROUP BY M.DATA, M.CODFILIAL, M.NUMTRANSACAO, M.CODCLI, M.CODUSUR, S.TOTPESO, M.TRANSPORTADORA
