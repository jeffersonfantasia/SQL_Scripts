SELECT CODCLI,
       CODUSUR,
       VLATEND
  FROM PCPEDC
 WHERE POSICAO NOT IN (
    'F', 'C'
);
/