SELECT TO_DATE(T.DTCADASTRO, 'DD/MM/YY') DTCADASTRO, T.CODCLI, T.CLIENTE
  FROM PCCLIENT T
  JOIN PCUSUARI U ON T.CODUSUR1 = U.CODUSUR
 WHERE (T.DTEXCLUSAO IS NULL AND T.BLOQUEIODEFINITIVO = 'N')
   AND U.CODSUPERVISOR IN (1, 2, 4, 11, 12)
   AND (NOT EXISTS (SELECT CODCLI
                      FROM PCTABPRCLI
                     WHERE CODCLI = T.CODCLI
                       AND CODFILIALNF IN ('2', '11')))
 ORDER BY DTCADASTRO DESC;

MERGE INTO PCTABPRCLI C
USING (SELECT T.CODCLI, T.CLIENTE
         FROM PCCLIENT T
         JOIN PCUSUARI U ON T.CODUSUR1 = U.CODUSUR
        WHERE (T.DTEXCLUSAO IS NULL AND T.BLOQUEIODEFINITIVO = 'N')
          AND U.CODSUPERVISOR IN (1, 2, 4, 11, 12)) X
ON (C.CODCLI = X.CODCLI)
WHEN NOT MATCHED THEN
  INSERT
    (CODCLI, CODFILIALNF, NUMREGIAO, DTULTALTER, CODFUNCULTALTER)
  VALUES
    (X.CODCLI, '11', 4, TRUNC(SYSDATE), 45);

MERGE INTO PCTABPRCLI C
USING (SELECT T.CODCLI, T.CLIENTE
         FROM PCCLIENT T
         JOIN PCUSUARI U ON T.CODUSUR1 = U.CODUSUR
        WHERE (T.DTEXCLUSAO IS NULL AND T.BLOQUEIODEFINITIVO = 'N')
          AND U.CODSUPERVISOR IN (1, 2, 4, 11, 12)) X
ON (C.CODCLI = X.CODCLI AND C.CODFILIALNF = '2')
WHEN NOT MATCHED THEN
  INSERT
    (CODCLI, CODFILIALNF, NUMREGIAO, DTULTALTER, CODFUNCULTALTER)
  VALUES
    (X.CODCLI, '2', 1, TRUNC(SYSDATE), 45);
