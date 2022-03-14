CREATE OR REPLACE VIEW VIEW_JC_PCPREST_BAIXA_CRED AS
/*--CONCILIAÇÃO DO ADIANTAMENTO EM DUPLICATA QUE TENHA GERADO NOVAS MOVIMENTAÇÕES--*/
/*--MANTENDO OS REGISTROS INICIAIS PARA NÃO MUDAR OS SALDOS DOS MESES--*/
    SELECT B.CODFILIAL,
           (
               CASE
                   WHEN B.VERIFICAR_DATA = 1 THEN B.DTLANC
                   ELSE B.DTDESCONTO
               END
           ) AS DATA,
           B.CODCRED,
           B.NUMCRED,
           B.NUMTRANS,
           B.NUMLANCBAIXA,
           B.NUMTRANSACAO,
           B.CODCONTAB,
           B.CODCONTABILBANCO,
           B.VALOR,
           (
               CASE
                   WHEN B.DTESTORNO IS NOT NULL THEN 'CE'
                   ELSE 'C'
               END
           ) AS TIPO,
           ('BAIXA NF ' || B.NUMNOTADESC || ' - ' || B.CLIENTE) AS HISTORICO
      FROM VIEW_JC_BASE_BAIXA_CRED B
      LEFT JOIN VIEW_JC_ADIANT_CLIENTE A ON B.CODCRED = A.CODCRED
     WHERE B.VALOR_ORIG > 0
       AND B.ROTINABAIXA NOT LIKE '%619%'
       AND B.NUMTRANSBAIXA IS NULL
       AND A.CODCRED IS NULL
    UNION ALL
/*--CONCILIAÇÃO DO ADIANTAMENTO EM DUPLICATA MESMO CODIGO DO ADIANTAMENTO--*/
    SELECT B.CODFILIAL,
           B.DTDESCONTO AS DATA,
           B.CODCRED,
           B.NUMCRED,
           B.NUMTRANS,
           B.NUMLANCBAIXA,
           B.NUMTRANSACAO,
           B.CODCONTAB,
           B.CODCONTABILBANCO,
           B.VALOR,
           (
               CASE
                   WHEN B.DTESTORNO IS NOT NULL THEN 'CE'
                   ELSE 'C'
               END
           ) AS TIPO,
           ('BAIXA NF ' || B.NUMNOTADESC || ' - ' || B.CLIENTE) AS HISTORICO
      FROM VIEW_JC_BASE_BAIXA_CRED B
     INNER JOIN VIEW_JC_ADIANT_CLIENTE A ON B.CODCRED = A.CODCRED
     WHERE B.VALOR_ORIG > 0
       AND B.ROTINABAIXA NOT LIKE '%619%'
       AND B.NUMTRANSBAIXA IS NULL
    UNION ALL
 /*--ESTORNOS REALIZADOS---*/
    SELECT B.CODFILIAL,
           B.DTDESCONTO AS DATA,
           B.CODCRED,
           B.NUMCRED,
           B.NUMTRANS,
           B.NUMLANCBAIXA,
           B.NUMTRANSACAO,
           B.CODCONTAB,
           B.CODCONTABILBANCO,
           B.VALOR,
           'E' AS TIPO,
           ('ESTORNO BAIXA CRED NFD ' || B.NUMCRED || ' - ' || B.CLIENTE) AS HISTORICO
      FROM VIEW_JC_BASE_BAIXA_CRED B
      LEFT JOIN VIEW_JC_ADIANT_CLIENTE A ON B.CODCRED = A.CODCRED
     WHERE (B.CODROTINA = 1209
       AND B.ROTINABAIXA LIKE '%1209%')
       AND B.VALOR_ORIG < 0
       AND A.CODCRED IS NULL
    UNION ALL
/*--BAIXA DO ADIANTAMENTO COMO RECEITA--*/
    SELECT B.CODFILIAL,
           (
               CASE
                   WHEN B.VERIFICAR_DATA = 1 THEN B.DTLANC
                   ELSE B.DTDESCONTO
               END
           ) AS DATA,
           B.CODCRED,
           B.NUMCRED,
           B.NUMTRANS,
           B.NUMLANCBAIXA,
           B.NUMTRANSACAO,
           B.CODCONTAB,
           B.CODCONTABILBANCO,
           B.VALOR,
           'R' AS TIPO,
           ('RECEITA CRED ' || B.NUMCRED || ' - ' || B.CLIENTE) AS HISTORICO
      FROM VIEW_JC_BASE_BAIXA_CRED B
     WHERE (B.CODROTINA IN (
        1400
    )
       AND B.ROTINABAIXA LIKE '%619%')
       AND B.NUMTRANS IS NOT NULL
       /*SOMENTE LANÇAMENTOS QUE MOVIMENTARAM CONTA GERENCIAL*/
       AND B.CODMOVIMENTO IS NOT NULL;
/