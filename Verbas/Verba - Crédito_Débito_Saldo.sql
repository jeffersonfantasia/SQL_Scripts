/*Verba - Crédito / Débito / Saldo*/
SELECT M.*,
       (NVL (DEBITO, 0) - NVL (CREDITO, 0)) SALDO
  FROM (
    SELECT ROUND (SUM (NVL (V.VALOR, 0)), 4) DEBITO,
           T.CREDITO
      FROM PCMOVCRFOR V,
           (
               SELECT NUMVERBA,
                      ROUND (SUM (NVL (VALOR, 0)), 4) CREDITO
                 FROM PCMOVCRFOR
                WHERE TIPO = 'C'
                GROUP BY NUMVERBA
           ) T
     WHERE T.NUMVERBA (+) = V.NUMVERBA
       AND V.TIPO = 'D'
       AND V.NUMVERBA IN (6216)
     GROUP BY T.CREDITO
) M;