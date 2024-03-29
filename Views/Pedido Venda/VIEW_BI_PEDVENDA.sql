CREATE OR REPLACE VIEW VIEW_BI_PEDVENDA AS
    SELECT CAST (C.CODFILIAL AS NUMBER) AS CODFILIAL,
           CAST (NVL (I.CODFILIALRETIRA, C.CODFILIAL) AS NUMBER) AS CODFILIALRETIRA,
           I.DATA,
           I.CODPROD,
           I.QT,
           I.PVENDA AS VLPROD,
           (I.QT * I.PVENDA) AS VLTOTPROD,
           I.CODUSUR,
           I.POSICAO,
           C.CONDVENDA,
           I.CODCLI
      FROM PCPEDI I
      LEFT JOIN PCPEDC C ON I.NUMPED = C.NUMPED
     WHERE I.POSICAO = 'F';
/