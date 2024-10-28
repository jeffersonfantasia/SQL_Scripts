--TODAS AS MOVIMENTACOES DA PCMOV PARA DESCONSIDERAR POSTERIORMENTE 
WITH PCMOV_NUMTRANSENT AS
 (SELECT DISTINCT (NUMTRANSENT) FROM PCMOV)
SELECT E.DTLANCTO,
       E.CODFUNCLANC,
       E.CODFILIALNF AS CODFILIAL,
       E.DTEMISSAO,
       E.DTENT,
       E.NUMTRANSENT,
       (CASE
         WHEN E.ESPECIE = 'CT' THEN
          3801
         ELSE
          E.CODCONT
       END) AS CODCONTA,
       E.ESPECIE,
       B.CODFISCAL,
       E.CODFORNEC,
       (E.ESPECIE || ' ' || E.NUMNOTA || ' - CNPJ: ' || E.CGC || ' - ' ||
       E.FORNECEDOR) AS HISTORICO,
       B.VLCONTABIL AS VALOR,
       ROUND(P.VLPIS, 2) AS VLPIS,
       ROUND(P.VLCOFINS, 2) AS VLCOFINS,
       P.NATCREDITO
  FROM PCNFENT E
  LEFT JOIN PCNFBASE B ON E.NUMTRANSENT = B.NUMTRANSENT
  LEFT JOIN PCNFENTPISCOFINS P ON B.NUMTRANSPISCOFINS = P.NUMTRANSPISCOFINS
  LEFT JOIN PCMOV_NUMTRANSENT M ON E.NUMTRANSENT = M.NUMTRANSENT
 WHERE E.DTCANCEL IS NULL	 
	 AND ((E.ESPECIE = 'NF' AND B.CODFISCAL IN (1911, 1923, 2923, 1949, 2949)) OR
       (E.ESPECIE = 'NS' AND B.CODFISCAL NOT IN (1253, 1353, 2353, 1933, 2933, 1923, 2923, 1949, 2949)) OR
       (B.CODFISCAL IN (1949, 2949) AND (P.VLPIS > 0 OR P.VLCOFINS > 0) AND NVL(P.NATCREDITO, '03') = '03') OR
       (B.CODFISCAL IN (1933, 2933) AND (P.VLPIS = 0 OR P.VLCOFINS = 0 OR NVL(P.NATCREDITO, '02') <> '03') AND E.CODFILIAL NOT IN ('5', '6', '9', '10')) OR
       (E.CODCONT IN (3201, 3411, 410101, 410102, 410103, 410104) AND B.CODFISCAL NOT IN (1933, 2933)) OR
       (E.CODCONT NOT IN (3201, 3411, 410101, 410102, 410103, 410104) AND B.CODFISCAL IN (1933, 2933)) OR
       (E.CODCONT IN (3450, 530101) AND (B.CODFISCAL NOT IN (1949, 2949) OR NVL(P.NATCREDITO, '04') <> '04')) OR
       (E.CODCONT IN (3452, 530103) AND (B.CODFISCAL NOT IN (1253, 2353) OR NVL(P.NATCREDITO, '04') <> '04')))
   AND E.CODCONT NOT IN (200159, 100001, 100023)
   AND E.ESPECIE NOT IN ('OE')
   AND M.NUMTRANSENT IS NULL
   AND E.DTENT >= TO_DATE('01/03/2024', 'DD/MM/YYYY')
 ORDER BY DTENT DESC;
