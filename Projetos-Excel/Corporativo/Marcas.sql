SELECT DISTINCT M.CODMARCA,
                M.MARCA
  FROM PCMARCA M
 INNER JOIN PCPRODUT P ON M.CODMARCA = P.CODMARCA
 WHERE P.DTEXCLUSAO IS NULL;
/