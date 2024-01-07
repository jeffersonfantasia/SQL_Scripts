CREATE OR REPLACE VIEW VIEW_BI_MOVPROD AS
    SELECT I.DATA,
           CAST(I.CODFILIAL AS NUMBER) AS CODFILIAL,
           I.NUMTRANSACAO,
           I.CODPROD,
           I.QTCONT AS QT,
           I.PUNITCONT AS VLPROD,
           ROUND(I.CUSTOFINEST, 4) AS CUSTO,
           I.VLPRODUTO AS VLTOTPROD,
           (CASE
             WHEN I.TIPOMOV = 'E' THEN
              ROUND(((I.QTCONT * I.CUSTOFINEST) + I.VLICMS + I.VLPIS +
                    I.VLCOFINS),
                    2)
             ELSE
              ROUND(((I.QTCONT * I.CUSTOFINEST) + I.VLICMS + I.VLPIS +
                    I.VLCOFINS + I.VLICMSPARTILHA),
                    2)
           END) AS VLCMV,
           I.VLFRETE,
           I.VLST,
           I.VLOUTRASDESP,
           I.VLCONTABIL AS VLTOTALNF,
           NVL(I.CODUSUR, 0) AS CODUSUR,
           I.TIPOMOV,
           CAST(I.CODFISCAL AS VARCHAR2(4)) AS CODFISCAL,
           I.CODFORCLI,
           I.PARCELAS,
           I.PRAZO,
           I.CODCOB
      FROM VIEW_JC_ITEM_NOTAFISCAL I
     WHERE I.DTCANCEL IS NULL
       AND I.CODFISCAL IS NOT NULL
       AND I.NUMTRANSACAO IS NOT NULL
       AND I.CODFILIAL NOT IN (3, 4);
