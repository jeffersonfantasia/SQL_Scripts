CREATE OR REPLACE VIEW MV_JC_PCMOV_SAID AS
SELECT S.DATA DTMOV,
       S.CODFILIAL,
       S.CFOP CODFISCAL,
       M.CODOPER,
       'N' TIPOPROCESSO,
       S.MOVIMENTO TIPOCONTABIL,
       DECODE(S.CODFORNEC,0, S.CODCLI, S.CODFORNEC) CODIGO,
       ('NF' || ' ' || N.NUMNOTA || ' - ' || N.CLIENTE) AS CLIENTE_FORNECEDOR,
       N.NUMNOTA,
       S.CODPROD,
       M.DESCRICAO PRODUTO,
       M.NBM NCM,
       S.QT QTCONT,
       S.PUNIT PUNITCONT,
       S.CUSTOCONTABIL CUSTOCONT,
       (S.QT * S.CUSTOCONTABIL) VLTOTALCUSTOCONT,
       S.VLPRODUTO VLTOTALPROD,
       S.VLFRETE VLTOTALFRETE,
       S.VLIPI VLTOTALIPI,
       S.VLDESCONTO VLTOTALDESCONTO,
       S.VLCONTABIL VLTOTALNF,
       S.CST_ICMS,
       S.VLBASEICMS BASEICMS_NF,
       S.PERCICMS ALIQ_ICMS,
       S.VLICMS VLTOTALCREDICMSNF,
       0 VLOUTRAS_NF,
       0 VLTOTALOUTRASDESP,
       0 VLTOTALBASEOUTROS,
       S.VLST VLTOTALST,
       S.VLSTGUIA VLTOTALSTFORANF,
       S.CST_PISCOFINS,
       S.VLBASEPISCOFINS,
       S.VLPIS VLTOTALPIS,
       S.VLCOFINS VLTOTALCOFINS,
       0 VLTOTALICMSPART,
       S.VLICMSDIFAL VLTOTALICMSPARTDEST,
       0 VLTOTALFCPPART,
       S.CODUSUR,
       S.NUMTRANSACAO,
       S.NUMTRANSITEM
 FROM BI_SINC_MOV_PRODUTO S
 JOIN PCMOV M ON M.NUMTRANSITEM = S.NUMTRANSITEM
 LEFT JOIN PCNFSAID N ON N.NUMTRANSVENDA = S.NUMTRANSACAO
WHERE S.MOVIMENTO = 'S'
AND M.DTCANCEL IS NULL
AND S.DATA >= TO_DATE('01/01/2023', 'DD/MM/YYYY')

