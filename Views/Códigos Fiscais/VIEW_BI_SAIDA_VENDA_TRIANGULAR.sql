CREATE OR REPLACE VIEW VIEW_BI_SAIDA_VENDA_TRIANGULAR AS
    SELECT CODFISCAL,
           DESCCFO AS DESCRICAO
      FROM PCCFO
     WHERE CODFISCAL IN ( 5120, 6120 );
/