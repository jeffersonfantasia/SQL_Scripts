/*-----------VERIFICAÇÃO ESTOQUE DIADEMA--------------*/
SELECT A.CODFILIAL,
       A.CODPROD,
       C.CODPRODMASTER,
       C.DESCRICAO,
       A.QTEST,
       (
         SELECT SUM (B.QTESTGER)
           FROM PCEST B
          WHERE B.CODFILIAL IN (
           2, 3
         ) 
            AND B.CODPROD = A.CODPROD
       ) QTESTGERSOMA   
  FROM PCEST A,
       PCPRODUT C
 WHERE A.CODPROD = C.CODPROD
   AND A.CODFILIAL IN (
  2
)
   AND C.CODEPTO NOT IN (
  97
)
   AND A.QTEST <> (
  SELECT SUM (B.QTESTGER)
    FROM PCEST B
   WHERE B.CODFILIAL IN (
    2, 3
  )
     AND B.CODPROD = A.CODPROD
)
 ORDER BY C.CODPRODMASTER,
          CODPROD;
/

/*-------VERIFICAÇÃO ESTOQUE JABAQUARA--------------*/
SELECT A.CODFILIAL,
       A.CODPROD,
       C.CODPRODMASTER,
       C.DESCRICAO,
       A.QTEST,
       (
         SELECT SUM (B.QTESTGER)
           FROM PCEST B
          WHERE B.CODFILIAL IN (
           1, 4
         )
            AND B.CODPROD = A.CODPROD
       ) QTESTGERSOMA
  FROM PCEST A,
       PCPRODUT C
 WHERE A.CODPROD = C.CODPROD
   AND A.CODFILIAL IN (
  1
)
   AND C.CODEPTO NOT IN (
  97
)
   AND A.QTEST <> (
  SELECT SUM (B.QTESTGER)
    FROM PCEST B
   WHERE B.CODFILIAL IN (
    1, 4
  )
     AND B.CODPROD = A.CODPROD
)
 ORDER BY C.CODPRODMASTER,
          CODPROD;
/

/*Estoque contabil menor que zero - Filial 7*/
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTEST,
       E.QTESTGER
  FROM PCEST E,
       PCPRODUT P
 WHERE E.CODFILIAL IN (
  '7'
)
   AND E.CODPROD = P.CODPROD
   AND QTEST < 0;
/

/*Estoque contabil menor que zero - Filial 8*/
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTEST,
       E.QTESTGER
  FROM PCEST E,
       PCPRODUT P
 WHERE E.CODFILIAL IN (
  '8'
)
   AND E.CODPROD = P.CODPROD
   AND QTEST < 0;
/

/*Estoque Contábil diferente que zero - Simples Nacional*/
SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTEST,
       E.QTESTGER
  FROM PCEST E,
       PCPRODUT P
 WHERE E.CODFILIAL IN (
  '5', '6', '9', '10'
)
   AND E.CODPROD = P.CODPROD
   AND (QTEST <> 0
    OR QTESTGER <> 0);
/


/*VERIFICAR SE TEVE MOVIMENTACAO COM FILIALRETIRA 1 OU 2   */
SELECT D.CODFILIAL,
       M.CODFILIALRETIRA,
       M.*
  FROM PCMOV M,
       PCNFSAID D
 WHERE D.NUMTRANSVENDA = M.NUMTRANSVENDA
   AND M.CODFILIALRETIRA IN (
  1, 2
)
   AND D.CODFILIAL IN (
  5, 6
)
   AND M.DTMOV = TRUNC (SYSDATE);
/