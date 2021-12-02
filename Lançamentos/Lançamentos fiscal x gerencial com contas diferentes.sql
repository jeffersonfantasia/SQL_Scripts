WITH PCMOV_NUMTRANSENT AS
/*TODAS AS MOVIMENTACOES DA PCMOV PARA DESCONSIDERAR POSTERIORMENTE*/ (
    SELECT DISTINCT (NUMTRANSENT)
      FROM PCMOV
), LANC_PCLANC AS (
    SELECT DISTINCT L.NUMNOTA,
                    L.CODFORNEC,
                    MIN (L.CODCONTA) AS CODCONTA
      FROM PCLANC L
     WHERE L.TIPOPARCEIRO = 'F'
       AND L.VALOR > 0
       AND L.DTCANCEL IS NULL
       AND L.DTESTORNOBAIXA IS NULL
       AND L.RECNUMBAIXA IS NULL
     /*PARA TIRAR DESCONTOS E JUROS*/
       AND NVL (L.HISTORICO2, '0') NOT IN (
        TRIM ('ISS'), TRIM ('CSRF'), TRIM ('IRRF'), TRIM ('INSS')
    )
     /*TIRAR OS LAN�AMENTOS DE IMPOSTOS*/
       AND NVL (L.HISTORICO2, '0') NOT IN TRIM ('ESTORNO')
       AND L.CODCONTA NOT IN (
        530102, 620108
    )
     /*TIRAR LANCAMENTOS DE IPTU E TAXAS MARKEPLACES*/
     GROUP BY L.NUMNOTA,
              L.CODFORNEC
)
SELECT E.CODFILIALNF AS CODFILIAL,
       E.DTEMISSAO,
       E.DTENT,
       E.NUMTRANSENT,
       E.CODCONT AS CONTA_1007,
       L.CODCONTA AS CONTA_750,
       E.CODFORNEC,
       E.CODFORNECNF,
       (E.ESPECIE || ' ' || E.NUMNOTA || ' - CNPJ: ' || E.CGC || ' - ' || E.FORNECEDOR) AS HISTORICO,
       B.VLCONTABIL AS VALOR
  FROM PCNFENT E
 INNER JOIN PCNFBASE B ON E.NUMTRANSENT = B.NUMTRANSENT
  LEFT JOIN PCMOV_NUMTRANSENT M ON E.NUMTRANSENT = M.NUMTRANSENT
  LEFT JOIN LANC_PCLANC L ON E.NUMNOTA = L.NUMNOTA
   AND E.CODFORNEC = L.CODFORNEC
 WHERE E.DTCANCEL IS NULL
      /*NAO TRAZER NOTAS CANCELADAS*/
   AND M.NUMTRANSENT IS NULL
      /*NAO TRAZER NOTAS COM MOVIMENTACAO NA PCMOV*/
   AND E.ESPECIE NOT IN (
    'OE', 'NE', 'TP', 'CT'
)
      /*N�O TRAZER ENTRADA NULACAO DE FRETE*/
   AND NOT (E.ESPECIE = 'NF'
   AND B.CODFISCAL IN (
    1911, 1923, 2923, 1949, 2949, 1116, 2116
))
      /*N�O TRAZER REMESSAS*/
   AND E.CODFORNEC NOT IN (
    8549, 143, 15
)
     /*RB SERVICOS, NET, TELEFONICA*/
   AND (E.CODCONT <> NVL (L.CODCONTA, 0)
    OR E.CODCONT IN (
    590101
)
    OR E.CODFORNEC <> E.CODFORNECNF)
   AND NOT (E.DTENT < '01-JAN-2021'
   AND E.CODFORNEC IN (
    31
))
   AND E.DTENT > TO_DATE ('01/01/2020', 'DD/MM/YYYY')
     /*RETIRAR LANCAMENTOS DAS CONTAS DE LUZ*/
/*AND E.DTENT BETWEEN '01-FEB-2020' AND '28-FEB-2021'*/
 ORDER BY E.DTENT;
/