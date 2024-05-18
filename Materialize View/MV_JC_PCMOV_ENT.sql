CREATE OR REPLACE VIEW MV_JC_PCMOV_ENT AS
SELECT S.DATA DTMOV,
       S.CODFILIAL,
       S.CFOP CODFISCAL,
       M.CODOPER,
       'NC' TIPOPROCESSO,
       NVL(E.NUMTRANSVENDAORIG, 0) AS NUMTRANSVENDAORIG,
       S.MOVIMENTO TIPOCONTABIL,
       DECODE(S.CODCLI,0, S.CODFORNEC, S.CODCLI) CODIGO,
       ('NF' || ' ' || E.NUMNOTA || ' - ' || E.FORNECEDOR) CLIENTE_FORNECEDOR,
       E.NUMNOTA,
       S.CODPROD,
       M.DESCRICAO PRODUTO,
       M.NBM NCM,
       S.QT QTCONT,
       S.PUNIT PUNITCONT,
       S.CUSTOCONTABIL CUSTOCONT,
       (S.QT * S.CUSTOCONTABIL) VLTOTALCUSTOCONT,
       ROUND(S.QT * S.PUNIT, 2)  VLTOTALPROD,
       ROUND(S.QT * NVL(S.VLFRETE, 0), 2) VLTOTALFRETE,
       ROUND(S.QT * NVL(S.VLIPI, 0), 2) VLTOTALIPI,
       ROUND(S.QT * NVL(S.VLDESCONTO, 0), 2) VLTOTALDESCONTO,
       (CASE
         WHEN (NVL(M.CODOPER, 'X') <> 'SD') THEN ROUND(S.QT * (S.PUNIT + NVL(S.VLFRETE, 0) + NVL(M.VLOUTROS, 0)),2)
         ELSE ROUND(S.QT * S.PUNIT, 2)
       END) AS VLTOTALNF,
       S.CST_ICMS,
       S.VLBASEICMS BASEICMS_NF,
       S.PERCICMS ALIQ_ICMS,
       ROUND(S.QT * S.VLICMS, 2) VLTOTALCREDICMSNF,
       0 VLOUTRAS_NF,
       0 VLTOTALOUTRASDESP,
       0 VLTOTALBASEOUTROS,
       ROUND(S.QT * S.VLST, 2) AS VLTOTALST,
       ROUND(S.QT * S.VLSTGUIA, 2) AS VLTOTALSTFORANF,
       S.CST_PISCOFINS,
       S.VLBASEPISCOFINS,
       ROUND(S.QT * S.VLPIS, 2) AS VLTOTALPIS,
       ROUND(S.QT * S.VLCOFINS, 2) AS VLTOTALCOFINS,
       0 VLTOTALICMSPART,
       ROUND(S.QT * NVL(S.VLICMSDIFAL, 0), 2) VLTOTALICMSPARTDEST,
       0 VLTOTALFCPPART,
       S.CODUSUR,
       S.NUMTRANSACAO,
       S.NUMTRANSITEM
 FROM BI_SINC_MOV_PRODUTO S
 JOIN PCMOV M ON M.NUMTRANSITEM = S.NUMTRANSITEM
 LEFT JOIN PCNFENT E ON E.NUMTRANSENT = S.NUMTRANSACAO
WHERE S.MOVIMENTO = 'E'
AND S.DATA >= TO_DATE('01/01/2023', 'DD/MM/YYYY')

