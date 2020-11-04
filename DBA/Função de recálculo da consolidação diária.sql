/*------ Primeiro argumento = codfilial / segund argumento = codprod / terceiro argumento = data--------------*/
BEGIN
    PKG_ANALISAR_ESTOQUE.PRC_RECALCULO ('2', 1882, '31-OCT-2018', NULL);
    COMMIT;
END;