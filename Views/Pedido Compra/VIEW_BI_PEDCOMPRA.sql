CREATE OR REPLACE VIEW VIEW_BI_PEDCOMPRA AS
    WITH PEDIDOCOMPRA AS (
        SELECT P.CODFILIAL,
               P.DTEMISSAO AS DATA,
               I.CODPROD,
               I.QTPEDIDA AS QTCOMPRA,
               (
                   CASE
                       WHEN I.QTENTREGUE > I.QTPEDIDA THEN I.QTPEDIDA
                       ELSE I.QTENTREGUE
                   END
               ) AS QTENTREGUE,
               (I.PLIQUIDO + I.VLIPI + I.VLST) AS PUNIT,
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
          LEFT JOIN PCFORNEC F ON P.CODFORNEC = F.CODFORNEC
    )
    SELECT C.CODFILIAL,
           C.DATA,
           C.CODPROD,
           C.QTCOMPRA,
           C.QTENTREGUE,
           C.PUNIT,
           (C.QTCOMPRA * C.PUNIT) AS VLCOMPRA,
           (C.QTENTREGUE * C.PUNIT) AS VLENTREGUE,
           C.CODCOMPRADOR,
           C.TIPOCOMPRA,
           C.CODFORNEC
      FROM PEDIDOCOMPRA C;
/