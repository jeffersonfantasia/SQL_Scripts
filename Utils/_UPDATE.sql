--UPDATE
BEGIN
 
  BEGIN
    PRC_SINC_PLANO_CONTAS_ESTILO;
    COMMIT;
  END;
	
 
  BEGIN
    PRC_SINC_TABELAS_DW;
    COMMIT;
  END;
	
	
  BEGIN
    PRC_SINC_LANC_PAGAR_BASE;
    COMMIT;
  END;
  
  
  BEGIN
    PRC_SINC_DESPESA_FISCAL; 
    COMMIT;
  END;

  
  BEGIN
    PRC_SINC_DESPESA_FISCAL_BASE; 
    COMMIT;
  END;
    

  BEGIN
    PRC_SINC_MOV_CONTABIL;
    COMMIT;
  END;
  

  BEGIN
    PRC_SINC_CONTABILIDADE;
    COMMIT;
  END;

END;
