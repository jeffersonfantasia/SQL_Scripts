SELECT CODUSUR,
       VENDEDOR,
       SUPERVISOR
  FROM VIEW_JC_VENDEDOR V
 WHERE CODGERENTE IN (
    1, 8, 9, 10
);
/