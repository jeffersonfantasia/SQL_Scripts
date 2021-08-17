CREATE OR REPLACE VIEW VIEW_BI_MARCA AS
    SELECT M.CODMARCA,
           (
               CASE
                   WHEN M.CODMARCA IN (
                       165, 166, 167
                   ) THEN 'DOREL'
                   ELSE UPPER(M.MARCA)
               END
           ) AS MARCA
      FROM PCMARCA M
     WHERE M.ATIVO = 'S'
       AND EXISTS (
        SELECT CODMARCA
          FROM VIEW_BI_PRODUTO
         WHERE CODMARCA = M.CODMARCA
    );
/