------- A ROTINA VALIDA O CODCONTA ENT�O DEVEMOS ALTERAR PARA 680105--------
SELECT ROWID,
       DTAPURACAO,
       CODFILIAL,
       NUMVERBA,
       TIPO,
       FORMAPGTO,
       CODCONTA,
       ORIGEM,
       DTVENC,
       VALOR,
       REFERENCIA,
       REFERENCIA1
  FROM PCVERBA
 WHERE NUMVERBA = 1615;


------- PARA DEIXAR A MOVIMENTA��O CORRETA DEVEMOS ALTERAR PARA 680105--------
SELECT ROWID, CODCONTA, C. * FROM PCMOVCRFOR C WHERE NUMVERBA = 1615;
