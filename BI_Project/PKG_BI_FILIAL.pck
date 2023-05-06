CREATE OR REPLACE PACKAGE PKG_BI_FILIAL IS

  -- Author  : JEFFERSON
  -- Created : 06/05/2023 16:48:38
  -- Purpose : Criacao e atualizacao da tabela filial

  TYPE JF_CURSOR IS REF CURSOR;
	
	PROCEDURE PCR_ATUALIZA_TABELA;

END PKG_BI_FILIAL;
/
CREATE OR REPLACE PACKAGE BODY PKG_BI_FILIAL IS

  PROCEDURE PCR_ATUALIZA_TABELA IS
    cFILIAL JF_CURSOR;
    vCODFILIAL FILIAL.CODFILIAL%TYPE;
    vFILIAL FILIAL.FILIAL%TYPE;
    vEMPRESA FILIAL.EMPRESA%TYPE;
    vORDEM FILIAL.ORDEM%TYPE;
  
  BEGIN
    FOR cFILIAL IN (SELECT CODIGO, FANTASIA, NOMEREMETENTE FROM PCFILIAL)
    LOOP
      vCODFILIAL := cFILIAL.CODIGO;
      vFILIAL := cFILIAL.FANTASIA;
      vEMPRESA := cFILIAL.NOMEREMETENTE;
      vORDEM := TO_NUMBER(cFILIAL.CODIGO);
    
      IF cFILIAL.CODIGO = vCODFILIAL
      THEN
        UPDATE FILIAL
           SET FILIAL = vFILIAL, EMPRESA = vEMPRESA, ORDEM = vORDEM;
        DBMS_OUTPUT.PUT_LINE('CODFILIAL ' || vCODFILIAL ||
                             ' ATUALIZADO COM SUCESSO!');
      ELSE
        INSERT INTO FILIAL
          (CODFILIAL, FILIAL, EMPRESA, ORDEM)
        VALUES
          (vCODFILIAL, vFILIAL, vEMPRESA, vORDEM);
        DBMS_OUTPUT.PUT_LINE('CODFILIAL ' || vCODFILIAL ||
                             ' INSERIDO COM SUCESSO!');
      END IF;
    END LOOP;
  END; --PCR_ATUALIZA_TABELA

--  PROCEDURE PCR_VISUALIZA_TABELA

END PKG_BI_FILIAL;
/
