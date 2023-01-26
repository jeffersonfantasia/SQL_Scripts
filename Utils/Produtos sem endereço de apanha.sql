/*-------VERIFICAR PRODUTOS SEM ENDERE�O DE APANHA---------*/
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.MODULO,
       E.RUA,
       E.NUMERO,
       E.APTO
  FROM PCEST E, PCPRODUT P
 WHERE E.CODPROD = P.CODPROD
   AND P.DTEXCLUSAO IS NULL
   AND (E.MODULO IS NULL AND E.RUA IS NULL AND E.NUMERO IS NULL AND
       E.APTO IS NULL);

/*-------CORRIGIR PRODUTOS SEM ENDERE�O DE APANHA---------*/
UPDATE PCEST
   SET MODULO = 1, RUA = 1, NUMERO = 1, APTO = 1
 WHERE (MODULO IS NULL AND RUA IS NULL AND NUMERO IS NULL AND APTO IS NULL);
