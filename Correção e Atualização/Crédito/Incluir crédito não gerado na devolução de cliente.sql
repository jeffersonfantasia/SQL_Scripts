/*
  PREENCHER INFORMACOES CORRESPONDENTE AO CLIENTE
  NUMNOTA, NUMTRANSENT, VALOR, FUNCIONARIO, DATA, HISTORICO...
  EXCLUIR LANCAMENTO DA PCLANC
*/
INSERT INTO PCCRECLI  
	(	CODCLI       	      
	,	DTLANC	            
	,	CODFILIAL	          
	,	NUMNOTA	            
	,	NUMTRANSVENDA	      
	,	SERIE	              
	,	VALOR        	      
	,	DTDESCONTO	        
	,	CODFILIALDESC	      
	,	NUMNOTADESC	        
	,	SERIEDESC	          
	,	CODFUNC	            
	,	HORA	              
	,	MINUTO           	  
	,	ORIGEM           	  
	,	NUMTRANSVENDADESC   
	,	NUMTRANSENTDEVCLI	  
	,	HISTORICO	          
	,	CODFUNCLANC	        
	,	NUMPED	            
	,	NUMERARIO           
	,	CODMOVIMENTO	      
	,	NUMLANCBAIXA	      
	,	NUMTRANSBAIXA	      
	,	NUMLANC	            
	,	NUMTRANS	          
	,	NUMPEDECF	          
	,	NUMCAIXA	          
	,	CODFUNCCX	          
	,	NUMSERIEEQUIP	      
	,	CODROTINA	          
	,	PRESTRESTCLI	      
	,	SITUACAO   	        
	,	NUMINDENIZ	        
	,	OBS	                
	,	CODADMCARTAO	      
	,	NUMCUPOM	          
	,	NSUTEF      	      
	,	BIN	                
	--,	CODIGO             	
	,	VALORESTORNOLIBERADO
	,	CODCLIORIG	        
	,	NUMGIFTCARD   	    
	,	DTEMISSAOTITULO	    
	,	NUMCRED	            
	,	DTESTORNO     	    
	,	PRESTORIG     	    
	,	CODPLPAG    	    
		)    	              
	VALUES        	      
	(166162 --:CODCLI       	      
	,TRUNC(SYSDATE)       
	,'5'  --:CODFILIAL	          
	,2212 --:NUMNOTA	            
	,NULL --:NUMTRANSVENDA	      
	,'2' --:SERIE	              
	,1641.70 --:VALOR        	      
	,NULL --:DTDESCONTO	        
	,NULL --:CODFILIALDESC	      
	,NULL --:NUMNOTADESC	        
	,NULL --:SERIEDESC	          
	,8890 --:CODFUNC	            
	,TO_NUMBER(TO_CHAR(SYSDATE,'hh24'))
	,TO_NUMBER(TO_CHAR(SYSDATE,'mi'))  
	,NULL --:ORIGEM           	  
	,NULL --:NUMTRANSVENDADESC   
	,496644 --:NUMTRANSENTDEVCLI	  
	,'ALTERACAO NO PEDIDO DE VENDA JA FATURADO'--:HISTORICO	          
	,8890 --:CODFUNCLANC	        
	,NULL --:NUMPED	            
	,NULL --:NUMERARIO           
	,NULL --:CODMOVIMENTO	      
	,NULL --:NUMLANCBAIXA	      
	,NULL --:NUMTRANSBAIXA	      
	,NULL --:NUMLANC	            
	,NULL --:NUMTRANS	          
	,NULL --:NUMPEDECF	          
	,NULL --:NUMCAIXA	          
	,NULL --:CODFUNCCX	          
	,NULL --:NUMSERIEEQUIP	      
	,1346 --:CODROTINA	          
	,NULL --:PRESTRESTCLI	      
	,NULL --:SITUACAO   	        
	,NULL --:NUMINDENIZ	        
	,NULL --:OBS	                
	,NULL --:CODADMCARTAO	      
	,NULL --:NUMCUPOM	          
	,NULL --:NSUTEF      	      
	,NULL --:BIN	                
	--,:CODIGO             	
	,NULL --:VALORESTORNOLIBERADO
	,NULL --:CODCLIORIG	        
	,NULL --:NUMGIFTCARD   	    
	,TO_DATE('23/11/2022', 'DD/MM/YYYY') --:DTEMISSAOTITULO	    
	,NULL --:NUMCRED	            
	,NULL --:DTESTORNO     	    
	,NULL --:PRESTORIG     	    
	,NULL --:CODPLPAG            
		)
