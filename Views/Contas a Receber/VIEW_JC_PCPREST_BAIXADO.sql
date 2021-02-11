CREATE OR REPLACE VIEW VIEW_JC_PCPREST_BAIXADO AS
    WITH CLIENTES_CARTAO_LOJA AS (
        SELECT DISTINCT (CODCLICC) AS CODCLI
          FROM PCCOB
         WHERE CODCONTACC = 620105
     /*CONTA GERENCIAL DE TAXA DE CARTAO, LOGO SOMENTE LOJA*/
           AND CODCLICC IS NOT NULL
     /*SOMENTE CLIENTES MARCADOS COMO CART�O*/
    ), COBRANCAS_CARTAOEMKT AS (
        SELECT CODCOB
          FROM PCCOB
         WHERE CODCLICC IS NOT NULL
     /*SOMENTE CLIENTES MARCADOS COMO CART�O*/
    ), CLIENTES_CARTAO AS (
        SELECT DISTINCT (CODCLICC) AS CODCLI
          FROM PCCOB
         WHERE CODCLICC IS NOT NULL
     /*SOMENTE CLIENTES MARCADOS COMO CART�O*/
    )
/*RELACAO DE JUROS RECEBIDOS--*/
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           (
               CASE
                   WHEN T.CODCOB = 'JUR' THEN VPAGO
                   ELSE (T.TXPERM + NVL (T.VLROUTROSACRESC, 0))
               END
           ) AS VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           'J' AS TIPO,
           (
               CASE
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('JUR RECEB DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (D.CLIENTE
                   ))
                   ELSE ('JUR RECEB DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND M.CODBANCO NOT IN (
        17, 20, 35, 50, 52, 53, 54
    )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
       AND T.CODCOB NOT IN (
        'DESD', 'TR', 'BNF', 'CHI', 'CANC', 'PERD', 'DEVT', 'DEVP', 'DESC', 'JUR', 'ESTR'
    )
      /*NAO TRAZER DESDOBRAMENTO, TROCO, BONIFICACAO, CHEQUE IRREGULAR, CANCELAMENTO, (JUROS NAO DUPLICA NA PCLANC), CONVENIO, PERDAS, DESC*/
       AND (T.TXPERM > 0)
     /*SOMENTE DUPLICATAS COM JUROS*/
    UNION ALL
/*RELACAO DE DESCONTO CONCEDIDOS--*/
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           T.VALORDESC AS VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           'D' AS TIPO,
           (
               CASE
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('DESC DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (D.CLIENTE)
                   )
                   ELSE ('DESC DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
      LEFT JOIN COBRANCAS_CARTAOEMKT L ON T.CODCOB = L.CODCOB
      LEFT JOIN CLIENTES_CARTAO R ON T.CODCLI = R.CODCLI
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND M.CODBANCO NOT IN (
        17, 20, 35, 50, 52, 53, 54
    )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
       AND T.CODCOB NOT IN (
        'DESD', 'TR', 'BNF', 'CHI', 'CANC', 'PERD', 'DEVT', 'DEVP', 'CARC', 'CADB', 'DESC', 'JUR', 'ESTR'
    )
      /*NAO TRAZER DESDOBRAMENTO, TROCO, BONIFICACAO, CHEQUE IRREGULAR, CANCELAMENTO, (JUROS NAO DUPLICA NA PCLANC), CONVENIO, PERDAS, CARTAO, DESC, JUR*/
       AND (T.VALORDESC > 0)
     /*SOMENTE LANCAMENTOS COM DESCONTO OU JUROS*/
       AND L.CODCOB IS NULL
     /*RETIRAR COBRANCAS DE MKT E LOJA*/
       AND R.CODCLI IS NULL
     /*RETIRAR CLIENTES DE MKT E LOJA*/
    UNION ALL
/*RELACAO DAS TAXAS DE CARTAO--*/
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           T.VALORDESC AS VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           'T' AS TIPO,
           (
               CASE
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('TX CARTAO DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (D.CLIENTE
                   ))
                   ELSE ('TX CARTAO DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
     INNER JOIN CLIENTES_CARTAO_LOJA L ON T.CODCLI = L.CODCLI
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND (T.VALORDESC > 0)
     /*SOMENTE LANCAMENTOS COM DESCONTO*/
    UNION ALL
/*BAIXA DUPLICATAS--*/
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           (
               CASE
                   WHEN T.CODCOB = 'DESC' THEN T.VALORDESC
                   WHEN T.CODCOB = 'JUR'  THEN T.VPAGO
                   WHEN T.VPAGO > T.VALOR THEN
     /*PARA QUE NAO TRAGA INFORMACAO DE JUROS*/ (
                       CASE
                           WHEN (T.TXPERM IS NULL
                              AND T.VALORDESC = 0) THEN T.VPAGO
                           WHEN T.VALORDESC > 0 THEN (T.VALOR - NVL (T.VALORDESC, 0))
     /*CASO HAJA DESCONTO NA DUPLICATA DEVEMOS TRAZER O VALOR MENOS O DESCONTO*/
                           ELSE T.VALOR
                       END
                   )
     /*PARA TRAZER A INFORMA��O QUE REALMENTE RECEBEU, POIS EXISTE DIFERENCA DE 0,01 AS VEZES*/
                   WHEN T.VPAGO < 0       THEN 0
     /*CORRIGIR BUG DO SISTEMA*/
                   ELSE T.VPAGO
               END
           ) VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           'B' AS TIPO,
           (
               CASE
                   WHEN T.CODCOB = 'DESC' THEN ('DESC DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
                   WHEN T.CODCOB = 'JUR'  THEN ('JUR RECEB DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (D.CLIENTE))
                   ELSE ('DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND M.CODBANCO NOT IN (
        17, 20, 35, 50, 52, 53, 54
    )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
       AND T.CODCOB NOT IN (
        'DESD', 'TR', 'BNF', 'CHI', 'CANC', 'CONV', 'PERD', 'DEVT', 'DEVP', 'ESTR'
    )
/*NAO TRAZER DESDOBRAMENTO, TROCO, BONIFICACAO, CHEQUE IRREGULAR, CANCELAMENTO (JUROS NAO DUPLICA NA PCLANC),CONVENIO, PERDAS, DEVOLUCOES, ESTORNOS*/
    UNION ALL
/*RELACAO DE PERDAS--*/
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           (
               CASE
                   WHEN T.VPAGO > T.VALOR THEN
     /*PARA QUE NAO TRAGA INFORMACAO DE JUROS*/ T.VALOR
                   ELSE T.VPAGO
               END
           ) VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           'P' AS TIPO,
           (
               CASE
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('PERDA DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (D.CLIENTE
                   ))
                   ELSE ('PERDA DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND T.CODCOB = 'PERD'
     /*SOMENTE DUPLICATAS BAIXADAS COMO PERDAS*/
    UNION ALL
/*RELACAO DE ESTORNOS--*/
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           (T.VALOR * - 1) AS VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           'E' AS TIPO,
           (
               CASE
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('ESTORNO DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (D.CLIENTE
                   ))
                   ELSE ('ESTORNO DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND T.CODCOB = 'ESTR'
     /*SOMENTE DUPLICATAS ESTORNADAS*/
       AND M.CODBANCO NOT IN (
        17, 20, 35, 50, 52, 53, 54
    )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
    UNION ALL
     /*RELACAO DE ESTORNOS DE JUROS--*/
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           (T.DUPLIC || '-' || T.PREST) AS DUPLICATA,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           (T.TXPERM * - 1) AS VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           'EJ' AS TIPO,
           (
               CASE
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('ESTORNO JUROS DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (D
                   .CLIENTE))
                   ELSE ('ESTORNO JUROS DUP ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || TRIM (C.CLIENTE))
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND T.CODCOB = 'ESTR'
     /*SOMENTE DUPLICATAS ESTORNADAS*/
       AND T.TXPERM <> 0
     /*SOMENTE JUROS ESTORNADOS COM VALOR DIF DE ZERO*/
       AND M.CODBANCO NOT IN (
        17, 20, 35, 50, 52, 53, 54
    )
     /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/;
/