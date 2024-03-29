CREATE OR REPLACE VIEW VIEW_JC_LANC_PAGOS AS
WITH DESCONTOS_INTEGRAIS AS
 (SELECT L.CODFILIAL,
         L.RECNUM,
         L.VPAGO,
         L.DESCONTOFIN AS VALOR,
         L.DTCOMPETENCIA,
         L.DTPAGTO,
         TO_DATE('') AS DTCOMPENSACAO,
         '' AS CODFILIALBANCO,
         TO_NUMBER('') AS CODBANCO,
         TO_NUMBER('') AS CODCONTABILBANCO,
         L.CODCONTA,
         C.GRUPOCONTA,
         L.CODFORNEC,
         '' AS CODCONTABCLIENTE,
         L.TIPOPARCEIRO,
         L.NUMTRANS,
         'D' AS TIPO,
         (CASE
           WHEN L.DUPLIC IS NULL OR L.DUPLIC = '0' THEN
            'DESC FIN N� ' || L.NUMNOTA || ' - ' || L.HISTORICO
           ELSE
            'DESC FIN N� ' || L.NUMNOTA || '-' || L.DUPLIC || ' - ' ||
            L.HISTORICO
         END) HISTORICO
    FROM PCLANC L
    LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
   WHERE L.DESCONTOFIN > 0
        /*SOMENTE LANCAMENTOS QUE POSSUEM DESCONTO OU JUROS*/
     AND L.DTCANCEL IS NULL
        /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
     AND L.DTESTORNOBAIXA IS NULL
        /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
     AND L.DTPAGTO IS NOT NULL
        /*CONSIDERAR LANCAMENTOS PAGOS APENAS*/
     AND L.NUMTRANS IS NULL
        /*SOMEMNTE LAN�AMENTOS SEM NUMTRANS PREECHIDO*/
     AND L.CODROTINAVERSAODESD IS NULL) --RETIRAR LANCAMENTOS DESDOBRADOS
/*--DESCONTOS FINACEIROS OBTIDOS--*/
SELECT *
  FROM VIEW_JC_LANC_DESC_OBTIDO
UNION ALL
/*--DESCONTOS FINACEIROS INTEGRAIS OBTIDOS--*/
SELECT *
  FROM DESCONTOS_INTEGRAIS
UNION ALL
/*JUROS PAGOS A FORNECEDOR--*/
SELECT *
  FROM VIEW_JC_LANC_JUROS_PAGOS
UNION ALL
/*DEMAIS LANCAMENTOS FILTRADOS NA PCLANC--*/
SELECT *
  FROM VIEW_JC_LANC_OUTROS
UNION ALL
/*LANCAMENTOS DOS IMPOSTOS DAS NOTAS DE SERVICO E FUNCIONARIOS--*/
SELECT *
  FROM VIEW_JC_LANC_IMP_NFS_FUNC
UNION ALL
/*LANCAMENTOS DE COMISSAO DOS MARKETPLACES--*/
SELECT *
  FROM VIEW_JC_LANC_COMISSAO_MKT
UNION ALL
/*LANCAMENTOS DOS PAGAMENTOS DE NFS COM CARTAO DE CREDITO--*/
SELECT *
  FROM VIEW_JC_LANC_CARTAO_CORP
UNION ALL
/*LANCAMENTOS ENTRE EMPRESAS DIFERENTES MOVIMENTANDO CONTA E BANCO--*/
SELECT *
  FROM VIEW_JC_LANC_EMP_CONTA_BANCO
UNION ALL
/*LANCAMENTOS REFERENTE A ALUGUEL DE MAQUINAS DE CART�O--*/
SELECT *
  FROM VIEW_JC_LANC_ALUGUEL_CARTAO
UNION ALL
/*LANCAMENTOS REFERENTE AOS MUTUOS--*/
SELECT *
  FROM VIEW_JC_LANC_MUTUOS
UNION ALL
/*LANCAMENTOS VERBAS AVULSAS RECEBIDAS EM DINHEIRO--*/
SELECT *
  FROM VIEW_JC_LANC_VERBA_AVULSA
UNION ALL
--LANCAMENTO DE MOVIMENTACAO NOS CAIXAS MKT E CARTAO--
SELECT *
  FROM VIEW_JC_LANC_CAIXA_MKT
UNION ALL
--LANCAMENTO DESPESAS FORNECEDORES SEM LIVRO FISCAL--
SELECT * FROM VIEW_JC_LANC_DESP_GER;
/
