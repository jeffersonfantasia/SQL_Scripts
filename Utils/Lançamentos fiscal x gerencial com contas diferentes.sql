WITH LANC_PCLANC AS
 (SELECT DISTINCT L.NUMNOTA,
                  L.CODFORNEC,
                  L.CODCONTA,
                  L.CODFUNCESTORNOBAIXA
    FROM PCLANC L
   WHERE L.TIPOPARCEIRO = 'F'
     AND L.VALOR > 0
     AND L.DTCANCEL IS NULL
     AND L.DTESTORNOBAIXA IS NULL
     AND L.RECNUMBAIXA IS NULL
        --TIRAR OS LAN�AMENTOS DE IMPOSTOS
     AND NVL(L.HISTORICO2, '0') NOT IN
         (TRIM('ISS'), TRIM('CSRF'), TRIM('IRRF'), TRIM('INSS'))
     AND NVL(L.HISTORICO2, '0') NOT IN TRIM('ESTORNO')
        --TIRAR LANCAMENTOS DE IPTU E TAXAS MARKEPLACES
     AND L.CODCONTA NOT IN (530102, 620108)
     AND NVL(L.DTPAGTO,L.DTEMISSAO) > TO_DATE('01/03/2023', 'DD/MM/YYYY'))
SELECT E.DTLANCTO,
       COALESCE(R.NOME_GUERRA, E.FUNCLANC) FUNCIONARIO,
       E.CODFILIALNF AS CODFILIAL,
       E.DTEMISSAO,
       E.DTENT,
       E.NUMTRANSENT,
       E.CODCONT AS CONTA_1007,
       L.CODCONTA AS CONTA_750,
       E.CODFORNEC,
       E.CODFORNECNF,
       (E.ESPECIE || ' ' || E.NUMNOTA || ' - CNPJ: ' || E.CGC || ' - ' ||
       E.FORNECEDOR) AS HISTORICO,
       B.VLCONTABIL AS VALOR,
       E.ROWID
  FROM PCNFENT E
 INNER JOIN PCNFBASE B ON E.NUMTRANSENT = B.NUMTRANSENT
  LEFT JOIN PCMOV M ON E.NUMTRANSENT = M.NUMTRANSENT
	LEFT JOIN PCEMPR R ON R.MATRICULA = E.CODFUNCLANC
  LEFT JOIN LANC_PCLANC L ON E.NUMNOTA = L.NUMNOTA
                         AND E.CODFORNEC = L.CODFORNEC
                         AND L.CODFUNCESTORNOBAIXA IS NULL
--NAO TRAZER NOTAS CANCELADAS
 WHERE E.DTCANCEL IS NULL
      --NAO TRAZER NOTAS COM MOVIMENTACAO NA PCMOV  
   AND M.NUMTRANSENT IS NULL
      --N�O TRAZER ENTRADA NULACAO DE FRETE
   AND E.ESPECIE NOT IN ('OE', 'NE', 'TP', 'CT')
      --N�O TRAZER REMESSAS
   AND NOT (E.ESPECIE = 'NF' AND
        B.CODFISCAL IN (1910,
                            1911,
                            2910,
                            2911,
                            1912,
                            2912,
                            1923,
                            2923,
                            1949,
                            2949,
                            1116,
                            2116,
                            1117,
                            2117))
      --RB SERVICOS, NET, TELEFONICA
   AND E.CODFORNEC NOT IN (8549, 143, 15)
   AND (E.CODCONT <> NVL(L.CODCONTA, 0) OR E.CODCONT IN (590101) OR
       E.CODFORNEC <> E.CODFORNECNF)
      --RETIRAR LANCAMENTOS DAS CONTAS DE LUZ*/
   AND NOT (E.DTENT < '01-JAN-2021' AND E.CODFORNEC IN (31))
   AND E.DTENT > TO_DATE('01/01/2024', 'DD/MM/YYYY')
 ORDER BY E.DTENT;
