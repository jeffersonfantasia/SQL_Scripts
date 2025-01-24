CREATE OR REPLACE VIEW VIEW_JC_CARTAO_MKT AS
  SELECT L.CODFILIAL,
         L.RECNUM,
         L.CODROTINABAIXA,
         L.DTCOMPETENCIA,
         M.DTCOMPENSACAO,
         L.DTESTORNOBAIXA,
         L.DTPAGTO,
         L.NUMNOTA,
         L.VALOR,
         L.VPAGO,
         L.CODCONTA,
         C.GRUPOCONTA,
         L.TIPOPARCEIRO,
         L.NUMTRANS,
         L.CODFORNEC,
         F.CODCONTAB AS CODCONTABCLIENTE,
         B.CODFILIAL AS CODFILIALBANCO,
         M.CODBANCO,
         B.CODCONTABIL AS CODCONTABILBANCO,
         'MK' AS TIPO,
         (CASE
           WHEN M.CODBANCO = 41 THEN
            'NFS ' || L.NUMNOTA || ' - ' || L.HISTORICO || ' - ' || F.FORNECEDOR
           ELSE
            'NFS ' || L.NUMNOTA || ' - ' || F.FORNECEDOR
         END) AS HISTORICO,
         (CASE
           WHEN L.TIPOLANC = 'C' THEN
            'CONFIRMADO'
           WHEN L.TIPOLANC = 'P' THEN
            'PROVISIONADO'
           WHEN L.TIPOLANC IS NULL THEN
            CASE
              WHEN DTPAGTO IS NULL THEN
               'PROVISIONADO'
              ELSE
               'CONFIRMADO'
            END
         END) AS TIPOLANC
    FROM PCLANC L
   INNER JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
    LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
    LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
    LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
   WHERE L.DTCANCEL IS NULL --NAO CONSIDERAR LANCAMENTOS CANCELADOS
        --AND L.DTESTORNOBAIXA IS NULL --NAO CONSIDERAR LANCAMENTOS ESTORNADOS
     AND L.DTDESD IS NULL --NAO CONSIDERAR OS LAN�AMENTOS GERADOS DE UM DESDOBRAMENTO
     AND L.CODROTINABAIXA NOT IN (1207, 1502, 1503, 9806) --NAO CONSIDERAR LANCAMENTOS ORIGINADOS DA BAIXA DE DUPLICATA PARA N�O DUPLICAR
     AND L.CODCONTA NOT IN (37, 9007) --RETIRAR LANCAMENTOS DE AJUSTE
     AND M.ESTORNO = 'N' --PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR
     AND M.CODROTINALANC NOT IN (1209) --NAO CONSIDERAR MOVIMENTACOES QUE FORAM ESTORNADAS
     AND (M.CODBANCO IN (40, 41, 72, 75) OR (M.CODBANCO IN (36, 39) AND L.CODCONTA IN (3201)) OR
         (M.CODBANCO = 11 AND L.CODCONTA IN (3201)))
  --SOMENTE LAN�AMENTOS NOS BANCOS DE COMISSAO MKT E CART�O DE CREDITO OU NOTAS DA AMAZON DE ASSINATURA OU NOTAS DE GATEWAY DA PAGAR.ME
  UNION ALL
  SELECT L.CODFILIAL,
         L.RECNUM,
         0 AS CODROTINABAIXA,
         L.DTLANC AS DTCOMPETENCIA,
         L.DTLANC AS DTCOMPENSACAO,
         L.DTCOMPETENCIA AS DTPAGTO,
         L.DTLANC AS DTESTORNOBAIXA,
         L.NUMNOTA,
         L.VALOR,
         L.VALOR AS VPAGO,
         L.CODCONTA,
         L.GRUPOCONTA,
         L.TIPOPARCEIRO,
         0 AS NUMTRANS,
         L.CODFORNEC,
         F.CODCONTAB AS CODCONTABCLIENTE,
         (SELECT CODFILIAL FROM PCBANCO WHERE CODBANCO = 40) AS CODFILIALBANCO,
         40 AS CODBANCO,
         (SELECT CODCONTABIL FROM PCBANCO WHERE CODBANCO = 40) AS CODCONTABILBANCO,
         'MI' AS TIPO,
         L.HISTORICO,
         L.TIPOLANC
    FROM VIEW_JC_IMPOSTO_NFSE L
    LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
   WHERE L.CODCONTA IN (3201) --SOMENTE LANCAMENTOS DAS NOTAS DE COMISSAO DE MKT
  ;
  /
