CREATE OR REPLACE VIEW VIEW_JC_ADIANTCLI_DEVOLVIDO AS
/*REGISTROS COM MAIS DE 1 LANÇAMENTO COM O MESMO NUMTRANSBAIXA*/
    WITH ESTORNOS_PARA_FILTRAR AS (
        SELECT C.NUMTRANSBAIXA,
               COUNT (C.NUMTRANSBAIXA) CONTAGEM
          FROM VIEW_JC_BASE_ADIANT_CLIENTE C
         WHERE C.NUMTRANSBAIXA IS NOT NULL
         GROUP BY C.NUMTRANSBAIXA
        HAVING COUNT (C.NUMTRANSBAIXA) > 1
    ),
/*REGISTROS COM VALOR POSITIVO DA RELAÇÃO ACIMA PARA TERMOS APENAS REGISTRO DISTINTO DE NUMTRANSBAIXA*/ 
    ESTORNOS_UNICOS_CORRETOS AS (
        SELECT C.CODCRED,
               C.NUMTRANSBAIXA
          FROM VIEW_JC_BASE_ADIANT_CLIENTE C
         INNER JOIN ESTORNOS_PARA_FILTRAR E ON C.NUMTRANSBAIXA = E.NUMTRANSBAIXA
         WHERE C.VLPAGO > 0
    ), DEMAIS_ESTORNOS AS (
        SELECT C.CODCRED,
               C.NUMTRANSBAIXA
          FROM VIEW_JC_BASE_ADIANT_CLIENTE C
          LEFT JOIN ESTORNOS_UNICOS_CORRETOS E ON C.NUMTRANSBAIXA = E.NUMTRANSBAIXA
         WHERE C.NUMTRANSBAIXA IS NOT NULL
           AND C.VLPAGO < 0
           AND NOT (C.HISTORICO LIKE '%TAXA%'
           AND C.CODMOVIMENTO = 11)
           AND E.NUMTRANSBAIXA IS NULL
    )
    /*LANÇAMENTOS DE ESTORNOS COM O VALOR POSITIVO*/
    SELECT C.CODFILIAL,
           M.DTCOMPENSACAO,
           C.DTLANC,
           C.CODCRED,
           C.NUMCRED,
           M.CODBANCO,
           B.CODBACEN,
           B.CODCONTABIL AS CODCONTABILBANCO,
           C.NUMTRANS,
           C.NUMTRANSBAIXA,
           C.VLPAGO,
           C.VALOR,
           C.CLIENTE
      FROM VIEW_JC_BASE_ADIANT_CLIENTE C
     INNER JOIN ESTORNOS_UNICOS_CORRETOS E ON C.CODCRED = E.CODCRED
     INNER JOIN PCMOVCR M ON C.NUMTRANSBAIXA = M.NUMTRANS
       AND C.CODMOVIMENTO = M.CODBANCO
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR   */
       AND M.CODBANCO NOT IN (
        17, 20, 35, 50, 52, 53, 54
    )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
    UNION ALL
     /*LANÇAMENTOS DE ESTORNOS COM O VALOR NEGATIVOS*/
    SELECT C.CODFILIAL,
           M.DTCOMPENSACAO,
           C.DTLANC,
           C.CODCRED,
           C.NUMCRED,
           M.CODBANCO,
           B.CODBACEN,
           B.CODCONTABIL AS CODCONTABILBANCO,
           C.NUMTRANS,
           C.NUMTRANSBAIXA,
           C.VLPAGO,
           C.VALOR,
           C.CLIENTE
      FROM VIEW_JC_BASE_ADIANT_CLIENTE C
     INNER JOIN DEMAIS_ESTORNOS E ON C.CODCRED = E.CODCRED
     INNER JOIN PCMOVCR M ON C.NUMTRANSBAIXA = M.NUMTRANS
       AND C.CODMOVIMENTO = M.CODBANCO
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR   */
       AND M.CODBANCO NOT IN (
        17, 20, 35, 50, 52, 53, 54
    );
/