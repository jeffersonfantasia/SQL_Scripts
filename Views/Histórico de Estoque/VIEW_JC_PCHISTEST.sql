CREATE OR REPLACE VIEW VIEW_JC_PCHISTEST AS
    SELECT H.CODFILIAL,
           H.CODPROD,
           H.DATA,
           H.QTESTGER,
           (
               CASE
                   WHEN DATA < TO_DATE ('01/09/2016', 'DD/MM/YYYY') THEN QTESTGER
                   ELSE QTEST
               END
           ) QTCONT,
           H.CUSTOREP,
           H.CUSTOCONT
      FROM PCHISTEST H;/