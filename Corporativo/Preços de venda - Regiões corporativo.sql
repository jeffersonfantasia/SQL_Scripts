SELECT PCTABPR.CODPROD,
       (
           SELECT A.PVENDA
             FROM PCTABPR A
            WHERE NUMREGIAO = 5
              AND PCTABPR.CODPROD = A.CODPROD
       ) BROKER_JFF,
       (
           SELECT A.PVENDA
             FROM PCTABPR A
            WHERE NUMREGIAO = 2
              AND PCTABPR.CODPROD = A.CODPROD
       ) LUC_REAL,
       (
           SELECT A.PVENDA
             FROM PCTABPR A
            WHERE NUMREGIAO = 6
              AND PCTABPR.CODPROD = A.CODPROD
       ) SIMPLES
  FROM PCTABPR
 WHERE PCTABPR.NUMREGIAO IN (
    2, 5, 6
);
/