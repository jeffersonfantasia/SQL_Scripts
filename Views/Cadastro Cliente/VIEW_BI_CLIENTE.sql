CREATE OR REPLACE VIEW VIEW_BI_CLIENTE AS
    SELECT C.CODCLI,
           (
               CASE
                   WHEN R.DESCRICAO IS NULL THEN ('C' || C.CODCLI)
                   ELSE ('R' || C.CODREDE)
               END
           ) AS CODCLIREDE,
           (
               CASE
                   WHEN R.DESCRICAO IS NULL THEN ('C' || C.CODCLI || ' - ' || C.CLIENTE)
                   ELSE ('R' || C.CODREDE || ' - ' || UPPER (R.DESCRICAO))
               END
           ) AS CLIENTE_REDE,
           C.CGCENT AS CGC,
           REPLACE (C.CEPENT, '-', '') AS CEP,
           C.ESTENT AS UF,
           P.PRACA,
           C.BLOQUEIODEFINITIVO AS BLOQUEADO,
           C.CODUSUR1 AS CODUSUR,
           C.DTCADASTRO AS DTCADASTROCLI,
           C.DTULTALTER AS DTULTALTERCLI
      FROM PCCLIENT C
      LEFT JOIN PCREDECLIENTE R ON C.CODREDE = R.CODREDE
      LEFT JOIN PCPRACA P ON C.CODPRACA = P.CODPRACA
     WHERE EXISTS (
        SELECT S.CODCLI
          FROM PCNFSAID S
         WHERE S.CODCLI = C.CODCLI
    )
        OR EXISTS (
        SELECT E.CODFORNEC
          FROM PCNFENT E
         WHERE E.CODFORNEC = C.CODCLI
           AND E.TIPODESCARGA = 'DF'
    );
/