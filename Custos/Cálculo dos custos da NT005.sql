SELECT CODFILIAL,
       CODPROD,
       BASEBCR,
       (((NVL (VALORLIQ, 0) + NVL (VLIPIULTENT, 0)) * (NVL (IVAULTENT, 0) / 100)) + NVL (VLIPIULTENT, 0) + NVL (VALORLIQ, 0)) CALC_BASEST
       ,
       STBCR,
       CALC_VLST,
       ALIQICMS1,
       ALIQICMS1ULTENT,
       BASEICMSBCR,
       BASEICMSULTENT,
       VLICMSBCR,
       CALC_VLICMS
  FROM (
    SELECT CODFILIAL,
           CODPROD,
           BASEBCR,
           STBCR,
           VLIPIULTENT,
           IVAULTENT,
           (
               CASE
                   WHEN NVL (VLSTULTENT, 0) = 0
                       OR NVL (VLSTULTENT, 0) IS NULL THEN NVL (VLSTGUIAULTENT, 0)
                   ELSE NVL (VLSTULTENT, 0)
               END
           ) CALC_VLST,
           (NVL (VALORULTENT, 0) - NVL (VLIPIULTENT, 0) - NVL (VLIPIULTENT, 0) - (
               CASE
                   WHEN NVL (VLSTULTENT, 0) = 0
                       OR NVL (VLSTULTENT, 0) IS NULL THEN NVL (VLSTGUIAULTENT, 0)
                   ELSE NVL (VLSTULTENT, 0)
               END
           )) VALORLIQ,
           ALIQICMS1,
           ALIQICMS1ULTENT,
           ALIQICMS2ULTENT,
           BASEICMSBCR,
           BASEICMSULTENT,
           VLICMSBCR,
           (NVL (BASEICMSULTENT, 0) * NVL (ALIQICMS1ULTENT, 0) / 100) CALC_VLICMS
      FROM PCEST
     WHERE (NVL (PCEST.BASEBCR, 0) = 0
        OR NVL (PCEST.STBCR, 0) = 0
        OR NVL (PCEST.ALIQICMS1, 0) = 0
        OR NVL (PCEST.BASEICMSBCR, 0) = 0
        OR NVL (PCEST.VLICMSBCR, 0) = 0)
       AND QTEST > 0
);
/

/*Script NT005*/
SELECT DISTINCT *
  FROM (
    SELECT PCEST.CODFILIAL AS FILIAL,
           PCPRODUT.CODPROD AS COD_PCPRODUT,
           PCTABPR.NUMREGIAO,
           PCPRODUT.DESCRICAO,
           PCDEPTO.DESCRICAO AS DEPTO,
           PCPRODUT.CODAUXILIAR,
           PCFORNEC.FORNECEDOR,
           PCPRODUT.NBM AS NCM,
           PCCEST.CODCEST,
           PCTRIBUT.IVAFONTE,
           PCTRIBUT.CODICMTAB AS IMP_CMV_NORMAL,
           PCTRIBUT.CODICM AS ALIQ_ICMS_NORMAL,
           PCTRIBUT.SITTRIBUT AS CST,
           PCEST.BASEBCR AS VLRBCICMSRETIDO,
           PCEST.STBCR AS VLR_ICMS_RETIDO,
           PCEST.ALIQICMS1 AS PERCALIQINTERNAICMSFINAL,
           PCEST.BASEICMSBCR,
           PCEST.VLICMSBCR,
           PCTRIBPISCOFINS.DESCRICAOTRIBPISCOFINS,
           DECODE (PCPRODUT.REVENDA, 'S', 'SIM', 'N', 'NAO') AS DISPONIVEL_VENDA,
           PCREGIAO.UF AS UF_DESTINO,
           PCTABPR.CODST,
           PCTRIBUT.PERCBASEREDSTFONTE AS PERC_RED_BASE_CALC,
           PCPRODUT.OBS2,
           TRUNC (PCEST.DTULTENT) ULTIMAENTRADA,
           PCEST.QTEST
      FROM PCPRODUT,
           PCCEST,
           PCCESTPRODUTO,
           PCTRIBUT,
           PCTABPR,
           PCDEPTO,
           PCTRIBPISCOFINS,
           PCFORNEC,
           PCREGIAO,
           PCEST
     WHERE PCCESTPRODUTO.CODPROD (+) = PCPRODUT.CODPROD
       AND PCTABPR.CODPROD = PCPRODUT.CODPROD
       AND PCCEST.CODIGO (+) = PCCESTPRODUTO.CODSEQCEST
       AND PCEST.QTEST > 0
       AND PCTRIBUT.CODST (+) = PCTABPR.CODST
       AND PCTRIBUT.SITTRIBUT = 60
       AND PCDEPTO.CODEPTO (+) = PCPRODUT.CODEPTO
       AND PCTABPR.CODTRIBPISCOFINS (+) = PCTRIBPISCOFINS.CODTRIBPISCOFINS
       AND PCFORNEC.CODFORNEC (+) = PCPRODUT.CODFORNEC
       AND PCREGIAO.NUMREGIAO = PCTABPR.NUMREGIAO
       AND PCEST.CODPROD (+) = PCPRODUT.CODPROD
       AND ((PCEST.CODFILIAL IN (
        1, 2, 3, 4, 5, 6, 7
    ))
        OR ('99' IN (
        1, 2, 3, 4, 5, 6, 7
    )))
       AND PCPRODUT.DTEXCLUSAO IS NULL
       AND (NVL (PCEST.BASEBCR, 0) = 0
        OR NVL (PCEST.STBCR, 0) = 0
        OR NVL (PCEST.ALIQICMS1, 0) = 0
        OR NVL (PCEST.BASEICMSBCR, 0) = 0
        OR NVL (PCEST.VLICMSBCR, 0) = 0)
    UNION ALL
        /*PRODUTOS COM ST NA ENTRADA SEM INFORMAÇÕES DO ICMS BCR(NT005-2018)*/
    SELECT PCEST.CODFILIAL AS FILIAL,
           PCPRODUT.CODPROD AS COD_PCPRODUT,
           0 AS NUMREGIAO,
           PCPRODUT.DESCRICAO,
           PCDEPTO.DESCRICAO AS DEPTO,
           PCPRODUT.CODAUXILIAR,
           PCFORNEC.FORNECEDOR,
           PCPRODUT.NBM AS NCM,
           PCCEST.CODCEST,
           PCTRIBUT.IVAFONTE,
           PCTRIBUT.CODICMTAB AS IMP_CMV_NORMAL,
           PCTRIBUT.CODICM AS ALIQ_ICMS_NORMAL,
           PCTRIBUT.SITTRIBUT AS CST,
           PCEST.BASEBCR AS VLRBCICMSRETIDO,
           PCEST.STBCR AS VLR_ICMS_RETIDO,
           PCEST.ALIQICMS1 AS PERCALIQINTERNAICMSFINAL,
           PCEST.BASEICMSBCR,
           PCEST.VLICMSBCR,
           PCTRIBPISCOFINS.DESCRICAOTRIBPISCOFINS,
           DECODE (PCPRODUT.REVENDA, 'S', 'SIM', 'N', 'NAO') ASDISPONIVEL_VENDA,
           PCTABTRIB.UFDESTINO AS UF_DESTINO,
           PCTABTRIB.CODST,
           PCTRIBUT.PERCBASEREDSTFONTE AS PERC_RED_BASE_CALC,
           PCPRODUT.OBS2,
           TRUNC (PCEST.DTULTENT) ULTIMAENTRADA,
           PCEST.QTEST
      FROM PCPRODUT,
           PCCEST,
           PCCESTPRODUTO,
           PCTRIBUT,
           PCTABTRIB,
           PCDEPTO,
           PCTRIBPISCOFINS,
           PCFORNEC,
           PCEST
     WHERE PCCESTPRODUTO.CODPROD (+) = PCPRODUT.CODPROD
       AND PCTABTRIB.CODPROD = PCPRODUT.CODPROD
       AND PCCEST.CODIGO (+) = PCCESTPRODUTO.CODSEQCEST
       AND PCEST.QTEST > 0
       AND PCTRIBUT.CODST (+) = PCTABTRIB.CODST
       AND PCTRIBUT.SITTRIBUT = 60
       AND PCDEPTO.CODEPTO (+) = PCPRODUT.CODEPTO
       AND PCTABTRIB.CODTRIBPISCOFINS (+) = PCTRIBPISCOFINS.CODTRIBPISCOFINS
       AND PCFORNEC.CODFORNEC (+) = PCPRODUT.CODFORNEC
       AND PCEST.CODPROD (+) = PCPRODUT.CODPROD
       AND ((PCEST.CODFILIAL IN (
        1, 2, 3, 4, 5, 6, 7
    ))
        OR ('99' IN (
        1, 2, 3, 4, 5, 6, 7
    )))
       AND PCPRODUT.DTEXCLUSAO IS NULL
       AND (NVL (PCEST.BASEBCR, 0) = 0
        OR NVL (PCEST.STBCR, 0) = 0
        OR NVL (PCEST.ALIQICMS1, 0) = 0
        OR NVL (PCEST.BASEICMSBCR, 0) = 0
        OR NVL (PCEST.VLICMSBCR, 0) = 0)
)
 ORDER BY NUMREGIAO
/