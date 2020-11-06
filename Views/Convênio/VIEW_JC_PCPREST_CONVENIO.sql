CREATE OR REPLACE VIEW VIEW_JC_PCPREST_CONVENIO AS
    SELECT T.CODFILIAL,
           T.DTPAG AS DATA,
           T.DTVENC,
           T.DTEMISSAO,
           M.CODBANCO,
           B.CODCONTABIL CODCONTABILBANCO,
           (
               CASE
                   WHEN T.VPAGO > T.VALOR THEN T.VALOR
     /*PARA QUE NAO TRAGA INFORMACAO DE JUROS POIS ESSA APARACE NA PCLANC*/ 
                   ELSE T.VPAGO
               END
           ) VALOR,
           C.CODCONTAB,
           T.CODCLI,
           T.CODCOB,
           T.CODUSUR,
           T.NUMTRANS,
           (
               CASE
                   WHEN T.DTINCLUSAOMANUAL IS NULL THEN ('DUPLIC ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || D.CLIENTE)
                   ELSE ('DUPLIC ' || T.DUPLIC || ' - ' || T.PREST || ' - ' || C.CLIENTE)
     /*TRAZER INFORMACAO DO CLIENTE NA INCLUSAO MANUAL DE DUPLICATA*/
               END
           ) HISTORICO
      FROM PCPREST T
      LEFT JOIN PCNFSAID D ON T.NUMTRANSVENDA = D.NUMTRANSVENDA
      LEFT JOIN PCCLIENT C ON T.CODCLI = C.CODCLI
     INNER JOIN PCMOVCR M ON T.NUMTRANS = M.NUMTRANS
     /*PARA TRAZER SOMENTE DUPLICATAS QUE MOVIMENTARAM NUMERARIOS, OU SEJA, QUE FORAM PAGAS*/
      LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
     WHERE T.VALORESTORNO IS NULL
     /*NAO PODEMOS COLOCAR T.DTESTORNO IS NULL POIS AS DUPLICATAS QUE TIVERAM NO SEU HISTORICO PRESTACOES ESTORNADAS POSSUEM O DTESTORNO PREENCHIDO*/
       AND M.DTESTORNO IS NULL
     /*PARA NAO TRAZER LANCAMENTO DUPLICADOS OU TRIPILICADOS QUE TENHA SIDO ESTORNADOS NA PCMOVCR*/
       AND T.CODCOB IN (
        'CONV'
    );
/