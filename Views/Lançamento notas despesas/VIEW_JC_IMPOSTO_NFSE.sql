CREATE OR REPLACE VIEW VIEW_JC_IMPOSTO_NFSE AS
    SELECT L.CODFILIAL,
           L.RECNUM,
           L.DTLANC,
           L.DTCOMPETENCIA,
           L.NUMNOTA,
           (
               CASE
                   WHEN L.DTPAGTO IS NOT NULL THEN (
                       CASE
                           WHEN L.VPAGOBORDERO IS NULL THEN L.VPAGO
                           ELSE L.VPAGOBORDERO
                       END
                   )
                   ELSE L.VALOR
               END
           ) AS VALOR,
           L.CODCONTA,
           C.GRUPOCONTA,
           L.TIPOPARCEIRO,
           L.CODFORNEC,
           (
               CASE
                   WHEN (C.GRUPOCONTA IN (
                       510, 515
                   )
                      AND L.CODCONTA NOT IN (
                       515106
                   )) THEN ('F' || L.HISTORICO2)
                   ELSE L.HISTORICO2
               END
           ) AS IMPOSTO,
           (
               CASE
                   WHEN NOT (C.GRUPOCONTA IN (
                       510, 515
                   )
                      AND L.CODCONTA NOT IN (
                       515106
                   )) THEN ('NFS ' || L.NUMNOTA || ' - ' || L.HISTORICO2 || ' - ' || F.FORNECEDOR)
                   ELSE (L.HISTORICO2 || ' - ' || L.HISTORICO)
               END
           ) AS HISTORICO,
           (
               CASE
                   WHEN L.TIPOLANC = 'C' THEN 'CONFIRMADO'
                   WHEN L.TIPOLANC = 'P' THEN 'PROVISIONADO'
                   WHEN L.TIPOLANC IS NULL THEN
                       CASE
                           WHEN DTPAGTO IS NULL THEN 'PROVISIONADO'
                           ELSE 'CONFIRMADO'
                       END
               END
           ) AS TIPOLANC
      FROM PCLANC L
      LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
     WHERE L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
       AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
       AND L.DTDESD IS NULL
     /*NAO CONSIDERAR OS LANÇAMENTOS GERADOS DE UM DESDOBRAMENTO*/
       AND L.VALOR > 0
     /*PARA DESCONSIDERAR O LANCAMENTO NEGATIVO GERADO PELO DESDOBRE*/
       AND L.HISTORICO2 IN (
        TRIM ('ISS'), TRIM ('CSRF'), TRIM ('IRRF'), TRIM ('INSS')
    )
     /*SOMENTE LANÇAMENTOS DE IMPOSTOS*/;
/