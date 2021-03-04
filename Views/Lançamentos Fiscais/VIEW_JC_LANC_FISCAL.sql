CREATE OR REPLACE VIEW VIEW_JC_LANC_FISCAL AS
    WITH PCMOV_NUMTRANSENT AS
/*TODAS AS MOVIMENTACOES DA PCMOV PARA DESCONSIDERAR POSTERIORMENTE*/ (
        SELECT DISTINCT (NUMTRANSENT)
          FROM PCMOV
    ), NOTAS_DESPESAS AS (
        SELECT E.CODFILIALNF AS CODFILIAL,
               E.DTEMISSAO,
               E.DTENT,
               E.NUMTRANSENT,
               (
                   CASE
                       WHEN E.ESPECIE = 'CT' THEN 420102
                       ELSE E.CODCONT
                   END
               ) AS CODCONTA,
               B.CODFISCAL,
               E.CODFORNEC,
               (E.ESPECIE || ' ' || E.NUMNOTA || ' - CNPJ: ' || E.CGC || ' - ' || E.FORNECEDOR) AS HISTORICO,
               B.VLCONTABIL AS VALOR,
               B.SITTRIBUT AS CST_ICMS,
               B.VLBASE,
               B.ALIQUOTA AS ALIQ_ICMS,
               B.VLICMS,
               B.VLISENTAS,
               E.VLOUTRAS,
               P.CODTRIBPISCOFINS AS CST_PISCOFINS,
               ROUND (P.VLPIS, 2) AS VLPIS,
               ROUND (P.VLCOFINS, 2) AS VLCOFINS
          FROM PCNFENT E
         INNER JOIN PCNFBASE B ON E.NUMTRANSENT = B.NUMTRANSENT
         INNER JOIN PCNFENTPISCOFINS P ON E.NUMTRANSENT = P.NUMTRANSENT
          LEFT JOIN PCMOV_NUMTRANSENT M ON E.NUMTRANSENT = M.NUMTRANSENT
         WHERE E.DTCANCEL IS NULL
     /*NAO TRAZER NOTAS CANCELADAS*/
           AND M.NUMTRANSENT IS NULL
     /*NAO TRAZER NOTAS COM MOVIMENTACAO NA PCMOV*/
           AND E.ESPECIE NOT IN (
            'OE', 'NE', 'TP'
        )
     /*NÃO TRAZER NOTAS QUE SAO OUTRAS ESPECIES*/
           AND NOT (E.ESPECIE = 'CT'
           AND B.CODFISCAL IN (
            2206
        ))
     /*NÃO TRAZER ENTRADA NULACAO DE FRETE*/
           AND NOT (E.ESPECIE = 'NF'
           AND B.CODFISCAL IN (
            1911, 1923, 2923, 1949, 2949
        ))
     /*NÃO TRAZER REMESSAS*/
    )
    SELECT N.CODFILIAL,
           N.DTEMISSAO,
           N.DTENT,
           N.NUMTRANSENT,
           N.CODCONTA,
           C.CONTACONTABIL,
           N.CODFISCAL,
           N.CODFORNEC,
           N.HISTORICO,
           N.VALOR,
           N.CST_ICMS,
           N.VLBASE,
           N.ALIQ_ICMS,
           N.VLICMS,
           N.VLISENTAS,
           N.VLOUTRAS,
           N.CST_PISCOFINS,
           N.VLPIS,
           N.VLCOFINS
      FROM NOTAS_DESPESAS N
      LEFT JOIN PCCONTA C ON N.CODCONTA = C.CODCONTA;
/