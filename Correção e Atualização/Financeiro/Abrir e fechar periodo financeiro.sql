--PCENCERRAMENTOFINANCEIRO TRABALHA COM INSERT E DELETE DOS REGISTROS
SELECT * FROM PCENCERRAMENTOFINANCEIRO WHERE CODFILIAL = '7' AND ANO = 2018 ORDER BY MES, DIA;
   
INSERT INTO PCENCERRAMENTOFINANCEIRO
  (CODFILIAL, ANO, MES, DIA, HISTORICO)
VALUES
  (&CODFILIAL, &ANO, &MES, &DIA, &HISTORICO);


DELETE FROM PCENCERRAMENTOFINANCEIRO
 WHERE CODFILIAL = &CODFILIAL
   AND ANO = &ANO
   AND MES = &MES
   AND DIA = &DIA;
