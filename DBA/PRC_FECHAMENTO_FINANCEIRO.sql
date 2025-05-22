CREATE OR REPLACE PROCEDURE PRC_FECHAMENTO_FINANCEIRO(P_DTFIM IN DATE) AS

  V_DTINICIO DATE := TO_DATE('01/01/2014', 'DD/MM/YYYY');

BEGIN

  FOR R IN (WITH INTERVALO_DATAS AS
               (SELECT V_DTINICIO + LEVEL - 1 AS DATA FROM dual CONNECT BY V_DTINICIO + LEVEL - 1 <= P_DTFIM),
              FILIAL AS
               (SELECT CODIGO AS CODFILIAL FROM PCFILIAL WHERE CODIGO <> '99')
              SELECT F.CODFILIAL,
                     EXTRACT(YEAR FROM I.DATA) AS ANO,
                     EXTRACT(MONTH FROM I.DATA) AS MES,
                     EXTRACT(DAY FROM I.DATA) AS DIA,
                     'FECHAMENTO MENSAL CONTABILIDADE' AS HISTORICO
                FROM INTERVALO_DATAS I
               CROSS JOIN FILIAL F)
  LOOP
    BEGIN
      -- Tenta atualizar
      UPDATE PCENCERRAMENTOFINANCEIRO
         SET HISTORICO = R.HISTORICO
       WHERE CODFILIAL = R.CODFILIAL
         AND ANO = R.ANO
         AND MES = R.MES
         AND DIA = R.DIA;
    
      IF SQL%NOTFOUND THEN
        -- Se não atualizou, insere
        INSERT INTO PCENCERRAMENTOFINANCEIRO
          (CODFILIAL,
           ANO,
           MES,
           DIA,
           HISTORICO)
        VALUES
          (R.CODFILIAL,
           R.ANO,
           R.MES,
           R.DIA,
           R.HISTORICO);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro encontrado: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20000, 'Erro durante a insercao na tabela: ' || SQLERRM);
    END;
  END LOOP;

  COMMIT;

END;
