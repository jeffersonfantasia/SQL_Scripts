CREATE OR REPLACE VIEW VIEW_JC_LANC_CAIXA_MKT AS 
--RETIRAR TRIPLICIDADE DE LANCAMENTOS ESTORNADOS NA PCMOV, MANTENDO APENAS 1 LANCAMENTO
WITH REGISTRO_UNICO_ESTORNADO AS
 (SELECT M.NUMSEQ
    FROM PCMOVCR M
    JOIN PCLANC L ON L.NUMTRANS = M.NUMTRANS
   WHERE ((M.ESTORNO = 'N' AND M.CODROTINALANC = 631) OR
         (M.ESTORNO = 'S' AND M.CODROTINALANC = 604 AND
         M.DTESTORNO IS NOT NULL) OR
         (M.ESTORNO = 'S' AND M.CODROTINALANC = 631 AND
         M.ROTINALANCAMENTO LIKE '[PCSIS604%'))
     AND M.ROTINALANCAMENTO LIKE '[PCSIS604%')
SELECT *
  FROM (SELECT DISTINCT L.CODFILIAL,
                        --M.DTESTORNO,
                        L.RECNUM,
                        L.VPAGO,
                        --USADO COMO CONDICIONAL DENTRO DO BI
                        (CASE
                          WHEN L.VPAGO < 0 THEN
                           NVL(L.VPAGO, 0) * -1
                          ELSE
                           (CASE
                             WHEN (L.VPAGOBORDERO IS NOT NULL OR
                                  L.VPAGOBORDERO > 0) THEN
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
          JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
          LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
          LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
          LEFT JOIN REGISTRO_UNICO_ESTORNADO E ON E.NUMSEQ = M.NUMSEQ
         WHERE NVL(L.INDICE, 0) NOT IN ('B') --LANÇAMENTOS ORIUNDOS DA MOVIMETAÇÃO DE ESTOQUE E CUSTO
           AND L.DTCANCEL IS NULL --NAO CONSIDERAR LANCAMENTOS CANCELADOS
           AND NVL(L.CODROTINABAIXA, 0) NOT IN
               (1207, 1502, 1503, 9806, 9876) --NAO CONSIDERAR LANCAMENTOS ORIGINADOS DA BAIXA DE DUPLICATA PARA NÃO DUPLICAR*/
           AND NVL(M.CODROTINALANC, 0) NOT IN (1209) --NAO CONSIDERAR MOVIMENTACOES QUE FORAM ESTORNADAS*/
           AND (B.CODBACEN = 'MARKETPLACE' OR B.CODBANCO = 12)
           AND L.CODROTINABAIXA IN (631, 638, 775)
           AND (L.CODCONTA IN (3201, 3654) OR L.CODCONTA IN (SELECT CODCONTA FROM PCCONTA C WHERE C.CODCONTA BETWEEN 1153 AND 1173))
           AND E.NUMSEQ IS NULL --RETIRAR REGISTROS TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR
        )
 WHERE CODCONTABCLIENTE IS NOT NULL;
