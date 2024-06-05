CREATE OR REPLACE VIEW BROKER.DITO_VENDEDORES AS
/**********************************************************
Trazer vendedores que são:
1. Do Gerente 3 LOJA ou vendedor 37 ECOMMERCE
2. Que não possuem DIRETORIA no nome
3. Que estão ativos ou estão inativo a partir de 01/01/2022
4. Retirar o vendedor TI - CODUSUR = 81
**********************************************************/

SELECT U.NOME NOME_VENDEDOR,
       U.CODUSUR CODIGO_VENDEDOR,
       U.CPF CPF_VENDEDOR,
       TO_NUMBER(U.CODFILIAL) ID_LOJA,
       F.FANTASIA LOJA,
       DECODE(U.BLOQUEIO, 'S', 'INATIVO', 'ATIVO') STATUS,
       (CASE
         WHEN U.CODUSUR = S.COD_CADRCA THEN
          'GERENTE'
         ELSE
          'VENDEDOR'
       END) CARGO
  FROM PCUSUARI U
  LEFT JOIN PCFILIAL F ON F.CODIGO = U.CODFILIAL
  LEFT JOIN PCSUPERV S ON S.CODSUPERVISOR = U.CODSUPERVISOR
 WHERE (U.CODUSUR = 37 OR S.CODGERENTE = 3)
   AND INSTR(U.NOME, 'DIRETORIA') = 0
   AND U.CODUSUR <> 81
   AND NVL(U.DTTERMINO, TO_DATE('01/01/2022','DD/MM/YYYY')) >= TO_DATE('01/01/2022','DD/MM/YYYY');

