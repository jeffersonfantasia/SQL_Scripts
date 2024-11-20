CREATE OR REPLACE VIEW VIEW_JC_LANC_BASE AS
  SELECT L.CODFILIAL,
         L.RECNUM,
         L.RECNUMPRINC,
         L.VPAGO,
         L.VPAGOBORDERO,
         /*USADO COMO CONDICIONAL DENTRO DO BI*/
         (CASE
           WHEN L.VPAGO < 0 THEN
            NVL(L.VPAGO, 0) * -1
           ELSE
            (CASE
              WHEN (L.VPAGOBORDERO IS NOT NULL OR L.VPAGOBORDERO > 0) THEN
               CASE
               --TRAZER O VALOR DO BORDERO PARA QUE BATA O VALOR COM O EXTRATO BANCARIO
               --AO TIRARMOS O JUROS NAO TRAZERMOS DUPLICIDADE NO VALOR PAGO
                 WHEN L.VPAGO > L.VPAGOBORDERO THEN
                  (L.VPAGOBORDERO - NVL(L.TXPERM, 0))
                 ELSE
                  L.VPAGO
               END
              ELSE
               L.VPAGO
            END)
         END) AS VALOR,
         /*TRANSFORMAR OS VALORES NEGATIVOS PARA ARQUIVO CONTABILIDADE*/
         L.TXPERM,
         L.DESCONTOFIN,
         L.DTCOMPETENCIA,
         L.DTPAGTO,
         M.DTCOMPENSACAO,
         B.CODFILIAL      AS CODFILIALBANCO,
         B.NOME,
         M.CODBANCO,
         B.CODCONTABIL    AS CODCONTABILBANCO,
         L.CODCONTA,
         C.GRUPOCONTA,
         L.CODFORNEC,
         L.TIPOPARCEIRO,
         L.NUMTRANS,
         L.NUMNOTA,
         L.DUPLIC,
         L.HISTORICO,
         L.HISTORICO2,
         L.CODROTINABAIXA
    FROM PCLANC L
   INNER JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
    LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
    LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
   WHERE NVL(L.INDICE, 0) NOT IN ('B')
        /*LAN�AMENTOS ORIUNDOS DA MOVIMETA��O DE ESTOQUE E CUSTO*/
     AND L.DTCANCEL IS NULL
        /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
     AND L.DTESTORNOBAIXA IS NULL
        /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
     AND NVL(L.CODROTINABAIXA, 0) NOT IN (1207, 1502, 1503, 9806, 9876)
        /*NAO CONSIDERAR LANCAMENTOS ORIGINADOS DA BAIXA DE DUPLICATA PARA N�O DUPLICAR*/
     AND NVL(M.CODBANCO, 0) NOT IN (17, 20, 35, 50, 52, 53, 54, 40)
        /*BANCOS DE BONIFICACAO, ACERTO MOTORISTA, EXTRAVIO DE MERCADORIA, COMISSAO MKT*/
     AND M.DTESTORNO IS NULL
        /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
     AND NVL(M.CODROTINALANC, 0) NOT IN (1209)
        /*NAO CONSIDERAR MOVIMENTACOES QUE FORAM ESTORNADAS*/
     AND NVL(L.CODCONTA, 0) NOT IN (105, 100022, 100024, 100027)
		 AND NOT (NVL(L.CODCONTA, 0) IN (2104, 2106, 300108, 300109, 300110, 300111) AND M.CODBANCO IN ( 80, 104))
        /*NAO CONSIDERAR LANCAMENTOS DE DEVOLU��O, DE ACERTO DE SALDO NO INICIO, LANCAMENTOS NF MAE, E DE CONTRAPARTIDA PARA COMPRA DE FUNCIONARIOS*/
     AND NVL(C.GRUPOCONTA, 0) NOT IN (680)
        /*NAO CONSIDERAR LANCAMENTOS ORIUNDOS DE VERBAS*/
     AND NOT (L.CODCONTA IN (9004, 620108) AND B.CODFILIAL IN (99));
  /
