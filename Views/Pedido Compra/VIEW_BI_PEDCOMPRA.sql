CREATE OR REPLACE VIEW VIEW_BI_PEDCOMPRA AS
    SELECT P.CODFILIAL,
           P.DATALANC AS DATA,
           I.CODPROD,
           I.QTPEDIDA,
           (
               CASE
                   WHEN I.QTENTREGUE > I.QTPEDIDA THEN I.QTPEDIDA
                   ELSE I.QTENTREGUE
               END
           ) AS QTENTREGUE,
           (
               CASE
                   WHEN P.CODCOMPRADOR = 47 THEN 2
                   WHEN (F.CODFORNECPRINC IN (
                       2, 305, 9078, 8994, 9225
                   )
                      AND P.CODFILIAL = 2) THEN 1
                   ELSE 3
               END
           ) AS CODCOMPRADOR,
           P.TIPODESCARGA AS TIPOCOMPRA,
           P.CODFORNEC
      FROM PCITEM I
      LEFT JOIN PCPEDIDO P ON I.NUMPED = P.NUMPED
      LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC;
/