CREATE OR REPLACE VIEW VIEW_JC_LANC_OUTROS AS
  WITH TODOS_LANC_FINANCEIROJUR AS
/*SELECAO DE TODOS OS LANCAMENTOS DE DESCONTOS E JUROS*/ (
    SELECT L.RECNUM
      FROM PCLANC L
     INNER JOIN VIEW_JC_LANC_DESC_JUR T ON L.RECNUMBAIXA = T.RECNUM
  )
  SELECT B.CODFILIAL,
         B.RECNUM,
         B.VPAGO,
         B.VALOR,
         B.DTCOMPETENCIA,
         B.DTPAGTO,
         B.DTCOMPENSACAO,
         B.CODFILIALBANCO,
         B.CODBANCO,
         (CASE WHEN B.CODBANCO = 80 AND B.NUMNOTA = 41099 THEN 2308 ELSE B.CODCONTABILBANCO END) CODCONTABILBANCO, --FINANCIAMENTO FORD TERRITORY
         B.CODCONTA,
         B.GRUPOCONTA,
         B.CODFORNEC,
         '' AS CODCONTABCLIENTE,
         B.TIPOPARCEIRO,
         B.NUMTRANS,
         (
           CASE
             WHEN B.TIPOPARCEIRO = 'F' THEN 'F'
             ELSE 'O'
           END
         ) AS TIPO,
         (
           CASE
             WHEN B.NUMNOTA IS NULL
                 OR B.NUMNOTA = '0' THEN
                 CASE
                   --RENDIMENTOS, IR, IOF, TARIFAS
                   WHEN B.CODCONTA IN (4001, 4100, 4103, 4102, 610101,620110,620111,650101) THEN B.HISTORICO || ' - ' || B.NOME
                   ELSE B.RECNUM || ' - ' || B.HISTORICO
                 END
             WHEN B.DUPLIC IS NULL OR B.DUPLIC = '0' THEN 'NF ' || B.NUMNOTA || ' - ' || B.HISTORICO
             ELSE 'NF ' || B.NUMNOTA || ' - ' || B.DUPLIC || ' - ' || B.HISTORICO
           END
         ) HISTORICO
    FROM VIEW_JC_LANC_BASE B
    LEFT JOIN VIEW_JC_LANC_ADIANTAMENTOFOR AF ON B.RECNUM = AF.RECNUM
    LEFT JOIN VIEW_JC_LANC_ADIANTFOR_BAIXA AB ON B.RECNUM = AB.RECNUM
    LEFT JOIN TODOS_LANC_FINANCEIROJUR T ON B.RECNUM = T.RECNUM
    LEFT JOIN VIEW_JC_IMPOSTO_NFSE I ON B.RECNUM = I.RECNUM
    LEFT JOIN VIEW_JC_CARTAO_MKT CM ON B.RECNUM = CM.RECNUM
    LEFT JOIN VIEW_JC_LANC_EMP_CONTA_BANCO LE ON B.RECNUM = LE.RECNUM
    LEFT JOIN VIEW_JC_LANC_ALUGUEL_CARTAO A ON B.RECNUM = A.RECNUM
    LEFT JOIN VIEW_JC_LANC_MUTUOS M ON B.RECNUM = M.RECNUM
    LEFT JOIN VIEW_JC_LANC_VERBA_AVULSA V ON B.RECNUM = V.RECNUM
    LEFT JOIN VIEW_JC_LANC_CAIXA_MKT MKT ON MKT.RECNUM = B.RECNUM
    LEFT JOIN VIEW_JC_LANC_DESP_GER DG ON DG.RECNUM = B.RECNUM
   WHERE NOT (B.CODCONTA = 37 AND B.CODROTINABAIXA = 631)
     AND NOT (B.CODCONTA IN (4005, 610103) AND NVL(B.NUMTRANS,0) > 0) --RETIRAR DESCONTO FINANCEIROS QUE POSSUEM NUMTRANS
		 AND B.NUMTRANS NOT IN (200630) --CORRECAO ERRO
     --RETIRAR PS LANÇAMENTOS DE CONTRAPARTIDA DOS MUTUOS, POIS ESSES JA MOVIMENTARAM O BANCO
     AND NOT ((B.CODBANCO = 14 AND B.CODCONTA IN (2403, 300102)) OR
        (B.CODBANCO = 15 AND B.CODCONTA IN (2402, 300101)) OR
        (B.CODCONTA IN (2401, 2101, 2102, 2103, 2109, 300301, 300302) AND B.CODBANCO IN (63, 100, 101, 102, 103)) OR
        (B.CODCONTA IN ( 4112, 620112) AND B.VPAGO < 0)
				--RETIRAR LANCAMENTO DE BAIXA NO BANCO DE CARTAO CORPORATIVO
				OR B.CODBANCO IN (41)) 
      /*FILTROS NAS VIEW RELACIONADAS--*/
     AND AF.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE ADIANTAMENTO AO FORNECEDOR*/
     AND AB.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE BAIXA DO ADIANTAMENTO AO FORNECEDOR*/
     AND T.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE DESCONTO FINANCEIRO E JUROS PARA NÃO DUPLICAR*/
     AND I.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE IMPOSTOS DE NOTAS DE SERVICOS E FUNCIONARIOS*/
     AND CM.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE CARTÃO DE CREDITO E NOTAS DE COMISSAO*/
     AND LE.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE EMPRESAS COM BANCOS DE OUTRA EMPRESA*/
     AND A.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE ALUGUEL DE MAQUINA DE CARTAO*/
     AND M.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DOS CAIXAS DOS MUTUOS*/
     AND V.RECNUM IS NULL
     /*RETIRAR LAÇAMENTOS DE VERBAS AVULSAS RECEBIDAS COMO DINHEIRO*/
     AND MKT.RECNUM IS NULL
     AND DG.RECNUM IS NULL;
/
