WITH VENDEDOR AS (
    SELECT U.CODUSUR,
           U.USURDIRFV VENDEDOR,
           V.CODGERENTE
      FROM PCUSUARI U
      JOIN PCSUPERV V ON V.CODSUPERVISOR = U.CODSUPERVISOR
      JOIN PCGERENTE G ON V.CODGERENTE = G.CODGERENTE
)
SELECT *
  FROM (
    SELECT DISTINCT C.CODCLI,
                    (
                        CASE
                            WHEN R.DESCRICAO IS NULL THEN
                                ( 'C' || C.CODCLI )
                            ELSE
                                ( 'R' || C.CODREDE )
                        END
                    ) AS CODCLIREDE,
                    (
                        CASE
                            WHEN R.DESCRICAO IS NULL THEN
                                ( 'C' || C.CODCLI || ' - ' || UPPER(C.CLIENTE) )
                            ELSE
                                ( 'R' || C.CODREDE || ' - ' || UPPER(R.DESCRICAO) )
                        END
                    ) AS CLIENTE_REDE,
                    C.CODCLIPRINC,
                    V.VENDEDOR,
                    C.LIMCRED,
                    CASE
                        WHEN C.CODCLI = C.CODCLIPRINC THEN
                            'S'
                        ELSE
                            'N'
                    END PRINCIPAL,
                    C.BLOQUEIODEFINITIVO,
                    C.DTCADASTRO,
                    C.CODCOB,
                    MAX(S.DTSAIDA)
                    OVER(PARTITION BY C.CODCLI) DTSAIDA_CLI,
                    MAX(S.DTSAIDA)
                    OVER(PARTITION BY C.CODCLIPRINC) DTSAIDA_CLIPRINC,
                    COUNT(S.CODCLI)
                    OVER(PARTITION BY C.CODCLIPRINC) QTVENDA_CLIPRINC
      FROM PCCLIENT C
      JOIN VENDEDOR V ON C.CODUSUR1 = V.CODUSUR
      LEFT JOIN PCREDECLIENTE R ON C.CODREDE = R.CODREDE
      LEFT JOIN PCNFSAID S ON S.CODCLI = C.CODCLI AND S.CONDVENDA = 1
     WHERE V.CODGERENTE IN ( 1, 8, 9, 10 )
     ORDER BY C.CODCLIPRINC,
              C.CODCLI
)