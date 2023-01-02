SELECT DISTINCT U.CODSUPERVISOR,
                V.NOME GERENTE,
                C.CODCLI,
                C.CODUSUR1 AS CODUSUR,
                U.USURDIRFV VENDEDOR,
                (
                    CASE
                        WHEN R.DESCRICAO IS NULL THEN
                            ( 'C' || C.CODCLI || ' - ' || UPPER(C.CLIENTE) )
                        ELSE
                            ( 'R' || C.CODREDE || ' - ' || UPPER(R.DESCRICAO) )
                    END
                ) AS CLIENTE_REDE,
                ( C.CODCLI || ' - ' || UPPER(C.CLIENTE) ) CLIENTE,
                ROUND((TRUNC(SYSDATE) - C.DTCADASTRO),
                      0) DIAS_CADASTRO,
                C.CGCENT AS CGC,
                ( C.ENDERENT || ' - ' || C.NUMEROENT || ' - ' || C.COMPLEMENTOENT || ' - ' || C.BAIRROENT || ' - ' || C.MUNICENT || ' - ' || C.ESTENT ) ENDERECO,
                COALESCE(C.EMAILCOB, C.EMAIL) EMAIL,
                C.TELCOB TELEFONE,
                NVL(SUM(S.VLTOTGER)
                    OVER(PARTITION BY S.CODCLI),
                    0) - NVL(SUM(E.VLTOTAL)
                             OVER(PARTITION BY E.CODFORNEC),
                             0) VLCOMPRA
  FROM PCCLIENT C
  JOIN PCUSUARI U ON U.CODUSUR = C.CODUSUR1
  JOIN PCSUPERV V ON V.CODSUPERVISOR = U.CODSUPERVISOR
  LEFT JOIN PCREDECLIENTE R ON C.CODREDE = R.CODREDE
  LEFT JOIN PCPRACA P ON C.CODPRACA = P.CODPRACA
  LEFT JOIN PCNFSAID S ON S.CODCLI = C.CODCLI
   AND S.DTCANCEL IS NULL
   AND S.CONDVENDA = 1
   AND S.DTSAIDA >= TO_DATE('01/01/2022', 'DD/MM/YYYY')
  LEFT JOIN PCNFENT E ON E.CODFORNEC = C.CODCLI
   AND E.DTCANCEL IS NULL
   AND E.TIPODESCARGA = '6'
   AND E.DTENT >= TO_DATE('01/01/2022', 'DD/MM/YYYY')
 WHERE C.BLOQUEIODEFINITIVO = 'N'
   AND U.CODSUPERVISOR IN ( 1, 2 )
 ORDER BY U.CODSUPERVISOR,
          VENDEDOR,
          CLIENTE_REDE DESC,
          C.CODCLI;