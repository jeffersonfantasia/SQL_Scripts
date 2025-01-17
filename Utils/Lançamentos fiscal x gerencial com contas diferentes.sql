WITH LANC_PCLANC AS
 (SELECT DISTINCT TO_NUMBER(EXTRACT(YEAR FROM L.DTCOMPETENCIA)) ANO_LANC,
                  L.NUMNOTA,
                  L.CODFORNEC,
                  MIN(L.CODCONTA) AS CODCONTA
    FROM PCLANC L
    LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
   WHERE L.TIPOPARCEIRO = 'F'
     AND L.VALOR > 0
     AND L.DTCANCEL IS NULL
     AND L.DTESTORNOBAIXA IS NULL
     AND L.RECNUMBAIXA IS NULL
        --TIRAR OS LANÇAMENTOS DE IMPOSTOS
     AND C.GRUPOCONTA NOT IN (100, 225, 680)
     AND NVL(L.HISTORICO2, '0') NOT IN TRIM('ESTORNO')
        --TIRAR LANCAMENTOS DE IPTU E TAXAS MARKEPLACES
     AND L.CODCONTA NOT IN (3451, 9004)
   GROUP BY L.DTCOMPETENCIA,
            L.NUMNOTA,
            L.CODFORNEC)
SELECT E.CODFILIALNF AS CODFILIAL,
       E.DTEMISSAO,
       E.DTENT,
       E.NUMTRANSENT,
       E.CODCONT AS CONTA_1007,
       L.CODCONTA AS CONTA_750,
       E.CODFORNEC,
       E.CODFORNECNF,
       E.NUMNOTA,
       (E.ESPECIE || ' ' || E.NUMNOTA || ' - CNPJ: ' || E.CGC || ' - ' ||
       E.FORNECEDOR) AS HISTORICO,
       B.VLCONTABIL AS VALOR
  FROM PCNFENT E
  LEFT JOIN PCNFBASE B ON E.NUMTRANSENT = B.NUMTRANSENT
  LEFT JOIN PCMOV M ON E.NUMTRANSENT = M.NUMTRANSENT
  LEFT JOIN PCCONTA C ON C.CODCONTA = E.CODCONT
  LEFT JOIN LANC_PCLANC L ON E.NUMNOTA = L.NUMNOTA
                         AND E.CODFORNECNF = L.CODFORNEC
                         AND TO_NUMBER(EXTRACT(YEAR FROM E.DTENT)) =
                             L.ANO_LANC
--NAO TRAZER NOTAS CANCELADAS
 WHERE E.DTCANCEL IS NULL
   AND M.NUMTRANSENT IS NULL
   AND E.ESPECIE NOT IN ('OE', 'NE', 'TP', 'CT')
   AND NOT (E.ESPECIE = 'NF' AND
        B.CODFISCAL IN
        (1911, 1923, 2923, 1949, 2949, 1116, 2116, 1117, 2117))
      --VR BENEFICIOS, FLASH, RB SERVICOS, NET, TELEFONICA
   AND E.CODFORNEC NOT IN (9964, 10529, 8549, 143, 15)
   AND (E.CODCONT <> NVL(L.CODCONTA, 0) OR E.CODCONT IN (4106))
      --RETIRAR LANCAMENTOS DAS CONTAS DE LUZ*/
   AND NOT (E.DTENT < '01-JAN-2021' AND E.CODFORNEC IN (31))
   AND C.GRUPOCONTA NOT IN (100, 200, 225)
 ORDER BY E.DTENT DESC;
