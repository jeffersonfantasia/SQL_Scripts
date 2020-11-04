SELECT /*&CODFILIAL,
       &DATAINICIO,
       &DATAFIM,*/
       (
           CASE
               WHEN NUMERARIO = 'S' THEN 'ADIANTAMENTO DO CLIENTE'
               WHEN (NUMERARIO IS NULL
                  AND VL_DEVOLUCAO IS NOT NULL) THEN 'CREDITO GERADO NA DEVOLUCAO DE CLIENTE'
               WHEN (NUMERARIO IS NULL
                  AND VL_DEVOLUCAO IS NULL) THEN 'CREDITO GERADO MANUAL - DESCONTO FINANCEIRO'
               ELSE 'ANALISAR'
           END
       ) ORIGEM_CREDITO,
       (
           CASE
               WHEN CODROTINA = 619
                  AND NUMERARIO = 'S' THEN 'PAGAMENTO DO CRÉDITO EM DINHEIRO AO CLIENTE'
               WHEN CODROTINA = 619
                  AND NUMERARIO IS NULL THEN 'RECEITA FINANCEIRA'
               ELSE HISTORICO
           END
       ) HISTORICO,
       CODFILIAL,
       NUMTRANS,
       CODIGO,
       MIN_CODIGO,
       CODCLI,
       CLIENTE,
       NUMERARIO,
       NUMCRED,
       DTLANC,
       DTBAIXA,
       NUMTRANSVENDADESC,
       NUMTRANSENTDEVCLI,
       NOTA_DEV,
       VL_DEVOLUCAO,
       (
           CASE
               WHEN CODIGO = MIN_CODIGO THEN VL_CREDITO
               ELSE 0
           END
       ) VL_CREDITO,
       VL_PAGO,
       ((
           CASE
               WHEN CODIGO = MIN_CODIGO THEN VL_CREDITO
               ELSE 0
           END
       ) - VL_PAGO) VL_SALDO,
       DUPLIC,
       PREST,
       CODROTINA
  FROM (
    SELECT I.CODFILIAL,
           I.NUMTRANS,
           I.CODIGO,
           (
               SELECT MIN (CODIGO)
                 FROM PCCRECLI
                WHERE NUMTRANS = I.NUMTRANS
           ) MIN_CODIGO,
           I.CODCLI,
           C.CLIENTE,
           (
               CASE
                   WHEN I.NUMERARIO IS NOT NULL THEN I.NUMERARIO
                   ELSE (
                       SELECT NUMERARIO
                         FROM PCCRECLI
                        WHERE NUMTRANS = I.NUMTRANS
                          AND CODROTINA = 618
                   )
               END
           ) NUMERARIO,
           I.NUMCRED,
           I.DTLANC,
           I.DTDESCONTO DTBAIXA,
           I.NUMTRANSVENDADESC,
           I.NUMTRANSENTDEVCLI,
           E.NUMNOTA NOTA_DEV,
           E.VLTOTAL VL_DEVOLUCAO,
           NVL (I.VALOR, 0) VL_CREDITO,
           NVL (T.VPAGO, 0) VL_PAGO,
               /*(NVL(I.VALOR, 0) - NVL(T.VPAGO, 0)) VL_SALDO,*/
           T.DUPLIC,
           T.PREST,
           I.PRESTRESTCLI,
           I.CODROTINA,
           I.HISTORICO
      FROM PCCRECLI I,
           PCCLIENT C,
           PCNFENT E,
           PCPREST T
     WHERE I.CODCLI = C.CODCLI
       AND T.NUMTRANSVENDA (+) = I.NUMTRANSVENDADESC
       AND E.NUMTRANSENT (+) = I.NUMTRANSENTDEVCLI
       AND T.DTESTORNO IS NULL
       AND T.CODCOB (+) = 'CRED'
       AND ((I.DTESTORNO IS NOT NULL
       AND I.CODROTINA IN (
        618, 619
    ))
        OR (I.DTESTORNO IS NULL))
       AND I.CODFILIAL IN (
        &CODFILIAL
    )
          /* AND I.CODCLI IN (&CODCLI)*/
           /* AND I.CODCLI = 106761*/
           /*AND I.CODFILIAL IN (6)*/
       AND ((I.CODROTINA NOT IN (
        9801, 1209
    ))
        OR (I.CODROTINA IS NULL))
       AND I.HISTORICO NOT LIKE '%DIF ENTRE NOTA E FINANCEIRO%'
       AND I.HISTORICO NOT LIKE '%-BX PARC NF.: 0 - NUMTRANSVENDA.:%'
       AND I.DTLANC > TO_DATE ('01-01-2017', 'DD/MM/YYYY')
     ORDER BY C.CLIENTE,
              I.NUMTRANS,
              I.NUMCRED
) U
 WHERE DTLANC < TO_DATE (&DATAFIM, 'DD/MM/YYYY')
   AND DTBAIXA BETWEEN TO_DATE (&DATAINICIO, 'DD/MM/YYYY') AND TO_DATE (&DATAFIM, 'DD/MM/YYYY')
/* WHERE DTLANC < TO_DATE('31-07-2018', 'DD/MM/YYYY')
   AND DTBAIXA BETWEEN TO_DATE('01-07-2018', 'DD/MM/YYYY') AND TO_DATE('31-07-2018', 'DD/MM/YYYY')*/
   AND NUMERARIO = 'S'
 ORDER BY ORIGEM_CREDITO,
          CLIENTE,
          NUMTRANS,
          NUMCRED,
          CODIGO;
/