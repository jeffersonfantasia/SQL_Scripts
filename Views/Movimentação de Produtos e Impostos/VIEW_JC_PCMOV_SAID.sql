CREATE OR REPLACE VIEW VIEW_JC_PCMOV_SAID AS
SELECT M.DTMOV,
       M.CODFILIAL,
       M.CODFISCAL,
       M.CODOPER,
       'S' AS TIPOCONTABIL,
       NVL(F.CODFORNEC, S.CODCLI) AS CODIGO,
       ('NF' || ' ' || S.NUMNOTA || ' - ' || S.CLIENTE) AS CLIENTE_FORNECEDOR,
       S.NUMNOTA,
       M.CODPROD,
       M.DESCRICAO AS PRODUTO,
       M.QTCONT,
       M.PUNITCONT,
       (CASE
         WHEN M.CODFISCAL IN (5923, 6923, 5117, 6117) THEN
          T.CUSTOCONT_TV7
         ELSE
          M.CUSTOCONT
       END) AS CUSTOCONT, --PARA TERMOS O CUSTO CONTABIL UTILIZADO NA NOTA MAE
       (CASE
         WHEN M.CODFISCAL IN (5923, 6923, 5117, 6117) THEN
          ROUND( NVL(M.QTCONT, 0) * NVL(T.CUSTOCONT_TV7, 0) ,2 )
         ELSE
          ROUND(NVL(M.QTCONT, 0) * NVL(M.CUSTOCONT, 0), 2)
       END) AS VLTOTALCUSTOCONT, --CUSTO CONTABIL
       ROUND(M.QTCONT * M.PUNITCONT, 2) AS VLTOTALPROD, --VALOR PRODUTO
       /*SE FOR DEVOLUCAO M.QTCONT * (M.PUNITCONT + M.VLDESCONTO - M.ST - M.VLIPI - M.VLFRETE)
       SENAO  M.QTCONT * (M.PUNITCONT + M.VLDESCONTO - M.ST - M.VLIPI)*/
       ROUND(NVL(I.VLFRETE, 0), 2) AS VLTOTALFRETE, --VALOR FRETE
       ROUND(NVL(I.VLIPI, 0), 2) AS VLTOTALIPI, --VALOR IPI
       ROUND(NVL(I.VLDESCONTO, 0), 2) AS VLTOTALDESCONTO, --VALOR DESCONTO
       (CASE WHEN M.CODFISCAL = 5927 THEN ROUND(M.QTCONT * M.PUNITCONT, 2) ELSE
       ROUND(NVL(I.VLCONTABIL, 0), 2) END) AS VLTOTALNF, -- VALOR BRUTO PRODUTO
       /*SE FOR DEVOLUCAO M.QTCONT * (M.PUNITCONT )
       SENAO  M.QTCONT * (M.PUNITCONT + M.VLFRETE + M.VLOUTROS)*/
       M.SITTRIBUT AS CST_ICMS,
       (CASE
         WHEN I.GERAICMSLIVROFISCAL = 'S' THEN
          ROUND(NVL(I.VLBASEICMS, 0), 2)
         ELSE
          0
       END) AS BASEICMS_NF, --TRAZER BASE DE ICMS SOMENTE PARA PRODUTOS ICMS
       (CASE
         WHEN I.GERAICMSLIVROFISCAL = 'S' THEN
          I.PERCICM
         ELSE
          0
       END) AS ALIQ_ICMS, --TRAZER ALIQUOTA
       (CASE
         WHEN I.GERAICMSLIVROFISCAL = 'S' THEN
          ROUND(NVL(I.VLICMS, 0), 2)
         ELSE
          0
       END) AS VLTOTALCREDICMSNF,
       (CASE
         WHEN M.GERAICMSLIVROFISCAL = 'N' THEN
          ROUND(NVL(I.VLCONTABIL, 0), 2) --PRODUTOS ST
         ELSE
          ROUND((NVL(I.VLCONTABIL, 0) - NVL(I.VLBASEICMS, 0)), 2) --PRODUTOS ICMS
       END) AS VLOUTRAS_NF, --VALOR TOTAL OUTRAS
       ROUND(NVL(I.VLOUTRASDESP, 0), 2) AS VLTOTALOUTRASDESP, --VALOR OUTRAS DESPESAS
       ROUND((NVL(M.QTCONT, 0) * NVL(L.VLBASEOUTROS, 0)), 2) AS VLTOTALBASEOUTROS, --VALOR DESPESAS NOTA RATEADA NO ITEM
       ROUND(NVL(I.VLST, 0), 2) AS VLTOTALST, --VALOR ST
       ROUND(NVL(I.VLSTGUIA, 0), 2) AS VLTOTALSTFORANF, --VALOR ST NA GUIA
       I.CST_PISCOFINS AS CST_PISCOFINS,
       ROUND(NVL(I.VLPIS, 0), 2) AS VLTOTALPIS,
       ROUND(NVL(I.VLCOFINS, 0), 2) AS VLTOTALCOFINS,
       ROUND(NVL(M.QTCONT, 0) * NVL(L.VLICMSPARTREM, 0), 2) VLTOTALICMSPART,
       ROUND(NVL(M.QTCONT, 0) * NVL(L.VLICMSPARTDEST, 0), 2) VLTOTALICMSPARTDEST,
       ROUND(NVL(M.QTCONT, 0) * NVL(L.VLFCPPART, 0), 2) VLTOTALFCPPART,
       M.CODUSUR,
       M.NUMTRANSVENDA AS NUMTRANSACAO,
       M.NUMTRANSITEM
  FROM PCMOV M
  LEFT JOIN PCNFSAID S --TRAZER INFORMACOES DE CLIENTES/FORNECEDORES
    ON M.NUMTRANSVENDA = S.NUMTRANSVENDA
  LEFT JOIN PCFORNEC F --PARA TERMOS O CODFORNEC DAS DEVOLUCOES AOS FORNECEDORES
    ON S.CODCLI = F.CODCLI
  LEFT JOIN PCMOVCOMPLE L --TRAZER INFORMACOES COMPLEMENTARES TRIBUTARIAS DOS ITENS
    ON M.NUMTRANSITEM = L.NUMTRANSITEM
  LEFT JOIN VIEW_JC_CUSTOCONT_TV8 T
    ON M.NUMTRANSITEM = T.NUMTRANSITEM_TV8
  LEFT JOIN VIEW_JC_ITEM_NOTAFISCAL I --TRAZER INFOMACOES CONSOLIDADAS DOS PRODUTOS
    ON M.NUMTRANSVENDA = I.NUMTRANSACAO
   AND M.NUMSEQ = I.NUMSEQ
   AND M.CODFILIALNF = I.CODFILIAL
   AND M.CODPROD = I.CODPROD --AMARRACAO FUNDAMENTAL FECHAR O JOIN
   AND I.TIPOMOV = 'S' --SOMENTE TRANSACOES DE SAIDA
 WHERE M.DTCANCEL IS NULL --N�O TRAZER MOVIMENTA��ES CANCELADAS
   AND M.STATUS IN ('A', 'AB') --TRAZER APENAS MOVIMENTA��ES CONTABEIS
   AND M.CODOPER LIKE 'S%' --SOMENTE MOVIMENTA��ES DE SAIDA DE MERCADORIA
   AND NVL(F.CODFORNEC, S.CODCLI) IS NOT NULL --N�O TRAZER REGISTROS EM BRANCO
;