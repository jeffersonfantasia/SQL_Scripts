CREATE OR REPLACE VIEW VIEW_JC_PCMOV_ENT AS
SELECT M.DTMOV,
       M.CODFILIAL,
       M.CODFISCAL,
       M.CODOPER,       'E' AS TIPOCONTABIL,     
       E.CODFORNEC AS CODIGO,
       ('NF'||' '|| E.NUMNOTA ||' - '||E.FORNECEDOR) AS CLIENTE_FORNECEDOR,
       E.NUMNOTA,
       M.CODPROD,
       M.DESCRICAO AS PRODUTO,
       M.QTCONT,
       M.PUNITCONT,
       M.CUSTOCONT,
       ROUND( NVL(M.QTCONT,0) * NVL(M.CUSTOCONT,0) ,2) AS VLTOTALCUSTOCONT, --CUSTO CONTABIL
       ROUND( M.QTCONT * M.PUNITCONT ,2) AS VLTOTALPROD, --VALOR PRODUTO
          --SE FOR DEVOLUCAO M.QTCONT * (M.PUNITCONT + M.VLDESCONTO - M.VLFRETE - VLOUTRASDESP - M.VLIPI - M.ST)
          --SENAO  M.QTCONT * M.PUNITCONT
       ROUND( NVL(I.VLFRETE,0) ,2) AS VLTOTALFRETE, --VALOR FRETE
       ROUND( NVL(I.VLIPI,0) ,2) AS VLTOTALIPI, --VALOR IPI
       ROUND( NVL(I.VLDESCONTO,0) ,2) AS VLTOTALDESCONTO, --VALOR DESCONTO
       ROUND( NVL(I.VLCONTABIL,0) ,2) AS VLTOTALNF, -- VALOR BRUTO PRODUTO
          --SE FOR DEVOLUCAO M.QTCONT * (M.PUNITCONT + M.VLFRETE + M.VLOUTROS,0)
          --SEN�O M.QTCONT * (PUNITCONT + M.VLIPI + M.ST + M.VLFRETE + VLOUTRASDESP - M.VLDESCONTO - M.VLSUFRAMA
       M.SITTRIBUT AS CST_ICMS,      
       (CASE WHEN I.GERAICMSLIVROFISCAL = 'S' THEN ROUND( NVL(I.VLBASEICMS, 0) ,2) ELSE 0 END) AS BASEICMS_NF, --TRAZER BASE DE ICMS SOMENTE PARA PRODUTOS ICMS
       (CASE WHEN I.GERAICMSLIVROFISCAL = 'S' THEN I.PERCICM ELSE 0 END) AS ALIQ_ICMS, --TRAZER ALIQUOTA 
       (CASE WHEN I.GERAICMSLIVROFISCAL = 'S' THEN ROUND( NVL(I.VLICMS,0), 2) ELSE 0 END) AS VLTOTALCREDICMSNF,
       (CASE WHEN M.GERAICMSLIVROFISCAL = 'N' 
             THEN ROUND( (NVL(I.VLBASEICMS, 0) + NVL(I.VLIPI,0) + NVL(I.VLST,0) + NVL(I.VLFRETE,0) + NVL(I.VLOUTRASDESP,0)) ,2) --PRODUTOS ST
             ELSE ROUND( ( (NVL(M.QTCONT,0) * NVL(M.PUNITCONT,0)) - NVL(I.VLBASEICMS, 0) + NVL(I.VLIPI,0) + NVL(I.VLFRETE,0) + NVL(I.VLOUTRASDESP,0)) ,2) --PRODUTOS ICMS
             END) AS VLOUTRAS_NF, --VALOR TOTAL OUTRAS
       ROUND( NVL(I.VLOUTRASDESP,0), 2) AS VLTOTALOUTRASDESP, --VALOR OUTRAS DESPESAS
       ROUND( (NVL(M.QTCONT,0) * NVL(L.VLBASEOUTROS,0)) ,2) AS VLTOTALBASEOUTROS, --VALOR DESPESAS NOTA RATEADA NO ITEM
       ROUND( NVL(I.VLST,0) ,2) AS VLTOTALST, --VALOR ST
       ROUND( NVL(I.VLSTGUIA,0) ,2) AS VLTOTALSTFORANF, --VALOR ST NA GUIA
       I.CST_PISCOFINS AS CST_PISCOFINS,
       ROUND( NVL(I.VLPIS,0) ,2) AS VLTOTALPIS,
       ROUND( NVL(I.VLCOFINS,0) ,2) AS VLTOTALCOFINS,
       ROUND( NVL(M.QTCONT,0) * NVL(L.VLICMSPARTREM,0) ,2) AS VLTOTALICMSPART,
       ROUND( NVL(M.QTCONT,0) * NVL(L.VLICMSPARTDEST,0) ,2) AS VLTOTALICMSPARTDEST,
       ROUND( NVL(M.QTCONT,0) * NVL(L.VLFCPPART,0) ,2) AS VLTOTALFCPPART,
       M.CODUSUR,
       M.NUMTRANSENT AS NUMTRANSACAO,
       M.NUMTRANSITEM
  FROM PCMOV M
  LEFT JOIN PCNFENT E --TRAZER INFORMACOES DE CLIENTES/FORNECEDORES
    ON M.NUMTRANSENT = E.NUMTRANSENT  LEFT JOIN PCMOVCOMPLE L --TRAZER INFORMACOES COMPLEMENTARES TRIBUTARIAS DOS ITENS
    ON M.NUMTRANSITEM = L.NUMTRANSITEM
  LEFT JOIN VIEW_JC_ITEM_NOTAFISCAL I --TRAZER INFOMACOES CONSOLIDADAS DOS PRODUTOS
    ON M.NUMTRANSENT = I.NUMTRANSACAO
   AND M.NUMSEQ = I.NUMSEQ
   AND M.CODPROD = I.CODPROD
   AND M.CODFILIALNF = I.CODFILIAL
   AND I.TIPOMOV = 'E' --SOMENTE TRANSACOES DE ENTRADA
 WHERE M.DTCANCEL IS NULL --N�O TRAZER MOVIMENTA��ES CANCELADAS
   AND M.STATUS IN ('A', 'AB') --TRAZER APENAS MOVIMENTA��ES CONTABEIS
   AND M.CODOPER LIKE 'E%'  --SOMENTE MOVIMENTA��ES DE SAIDA DE MERCADORIA
;