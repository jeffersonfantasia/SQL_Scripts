/*Guias GNRE na conta errada*/
SELECT CODFILIAL,
       RECNUM,
       DTLANC,
       CODCONTA,
       CODFORNEC,
       HISTORICO
  FROM PCLANC L
 WHERE L.CODCONTA = 140101
   AND CODROTINACAD = 'Integradora.Servico.exe'
 ORDER BY L.CODFILIAL,
          L.DTLANC DESC;
/
UPDATE PCLANC
   SET
    CODCONTA = 140105
 WHERE CODCONTA = 140101
   AND CODROTINACAD = 'Integradora.Servico.exe';
/