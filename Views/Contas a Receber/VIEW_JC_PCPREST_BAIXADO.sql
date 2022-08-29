CREATE OR REPLACE VIEW VIEW_JC_PCPREST_BAIXADO AS
    SELECT *
      FROM VIEW_JC_JUROS_RECEBIDOS
    UNION ALL
    SELECT *
      FROM VIEW_JC_DESC_CONCEDIDOS
    UNION ALL
    SELECT *
      FROM VIEW_JC_TAXA_CARTAO_LOJA
    UNION ALL
    SELECT *
      FROM VIEW_JC_PREST_PERDAS
    UNION ALL
    SELECT *
      FROM VIEW_JC_PREST_ESTORNO
    UNION ALL
    SELECT *
      FROM VIEW_JC_PREST_ESTORNO_JUROS
    UNION ALL
    SELECT *
      FROM VIEW_JC_PREST_BAIXA
         UNION ALL
    SELECT *
      FROM VIEW_JC_PCPREST_GERADO_MKT;
/