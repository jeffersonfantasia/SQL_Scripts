CREATE OR REPLACE VIEW VIEW_JC_LANC_CAIXA_MKT AS 
SELECT *
  FROM (SELECT L.CODFILIAL,
               L.RECNUM,
               L.VPAGO,
               --USADO COMO CONDICIONAL DENTRO DO BI
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
               L.DTCOMPETENCIA,
               L.DTPAGTO,
               M.DTCOMPENSACAO,
               B.CODFILIAL CODFILIALBANCO,
               M.CODBANCO,
               B.CODCONTABIL CODCONTABILBANCO,
               L.CODCONTA,
               C.GRUPOCONTA,
               L.CODFORNEC,
               (CASE
                 WHEN L.TIPOPARCEIRO = 'F' THEN
                  (SELECT F.CODCONTAB
                     FROM PCFORNEC F
                    WHERE F.CODFORNEC = L.CODFORNEC)
                 ELSE
                  (SELECT C.CODCONTAB
                     FROM PCCLIENT C
                    WHERE C.CODCLI = L.CODFORNEC)
               END) AS CODCONTABCLIENTE,
               L.TIPOPARCEIRO,
               L.NUMTRANS,
               'AM' TIPO,
               (CASE
                 WHEN L.NUMNOTA IS NULL OR L.NUMNOTA = '0' THEN
                  L.RECNUM || ' - ' || UPPER(L.HISTORICO)
                 WHEN L.DUPLIC IS NULL OR L.DUPLIC = '0' THEN
                  'NF ' || L.NUMNOTA || ' - ' || UPPER(L.HISTORICO)
                 ELSE
                  'NF ' || L.NUMNOTA || ' - ' || L.DUPLIC || ' - ' ||
                  UPPER(L.HISTORICO)
               END) HISTORICO
          FROM PCLANC L
         INNER JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
          LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
          LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
         WHERE NVL(L.INDICE, 0) NOT IN ('B') --LANÇAMENTOS ORIUNDOS DA MOVIMETAÇÃO DE ESTOQUE E CUSTO
           AND L.DTCANCEL IS NULL --NAO CONSIDERAR LANCAMENTOS CANCELADOS
           AND NVL(L.CODROTINABAIXA, 0) NOT IN (1207, 1502, 1503, 9806, 9876) --NAO CONSIDERAR LANCAMENTOS ORIGINADOS DA BAIXA DE DUPLICATA PARA NÃO DUPLICAR*/
           AND M.DTESTORNO IS NULL --PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR
           AND NVL(M.CODROTINALANC, 0) NOT IN (1209) --NAO CONSIDERAR MOVIMENTACOES QUE FORAM ESTORNADAS*/
           AND (B.CODBACEN = 'MARKETPLACE' OR B.CODBANCO = 12)
           AND L.CODROTINABAIXA IN (631, 638)
           AND L.CODCONTA NOT IN (650102, 650104)
        )
 WHERE CODCONTABCLIENTE IS NOT NULL;