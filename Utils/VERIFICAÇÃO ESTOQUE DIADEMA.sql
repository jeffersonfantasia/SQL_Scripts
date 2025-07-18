/*Estoque contabil menor que zero */
  SELECT E.CODFILIAL, E.CODPROD, P.DESCRICAO, E.QTEST, E.QTESTGER
	       --,e.rowid
    FROM PCEST E, PCPRODUT P
   WHERE E.CODPROD = P.CODPROD
     AND QTEST < 0;

/*-----------VERIFICAÇÃO ESTOQUE DIADEMA--------------*/
SELECT A.CODFILIAL,
       A.CODPROD,
       C.CODPRODMASTER,
       C.DESCRICAO,
       A.QTEST,
       (SELECT SUM(B.QTESTGER)
          FROM PCEST B
         WHERE B.CODFILIAL IN ('2', '3')
           AND B.CODPROD = A.CODPROD) QTESTGERSOMA
  FROM PCEST A, PCPRODUT C
 WHERE A.CODPROD = C.CODPROD
   AND A.CODFILIAL IN ('2')
   AND C.CODEPTO NOT IN (97)
   AND A.QTEST <> (SELECT SUM(B.QTESTGER)
                     FROM PCEST B
                    WHERE B.CODFILIAL IN ('2', '3')
                      AND B.CODPROD = A.CODPROD)
 ORDER BY C.CODPRODMASTER, CODPROD;
/
/*Estoque Contábil diferente que zero - Simples Nacional*/
  SELECT E.CODFILIAL, E.CODPROD, P.DESCRICAO, E.QTEST, E.QTESTGER
    FROM PCEST E, PCPRODUT P
   WHERE E.CODFILIAL IN ('8')
     AND E.CODPROD = P.CODPROD
     AND (QTEST <> 0 OR QTESTGER <> 0)
   ORDER BY E.CODFILIAL;
/
/*Estoque contabil menor que zero - Filial 7*/
  SELECT A.CODFILIAL,
         A.CODPROD,
         C.CODPRODMASTER,
         C.DESCRICAO,
         A.QTEST,
         (SELECT SUM(B.QTESTGER)
            FROM PCEST B
           WHERE B.CODFILIAL IN ('7')
             AND B.CODPROD = A.CODPROD) QTESTGERSOMA
    FROM PCEST A, PCPRODUT C
   WHERE A.CODPROD = C.CODPROD
     AND A.CODFILIAL IN ('7') 
     AND C.CODEPTO NOT IN (97)
     AND A.QTEST <> (SELECT SUM(B.QTESTGER)
                       FROM PCEST B
                      WHERE B.CODFILIAL IN ('7')
                        AND B.CODPROD = A.CODPROD)
   ORDER BY C.CODPRODMASTER, CODPROD;
/
/*-------VERIFICAÇÃO ESTOQUE TRIMAIS--------------*/
  SELECT A.CODFILIAL,
         A.CODPROD,
         C.CODPRODMASTER,
         C.DESCRICAO,
         A.QTEST,
         (SELECT SUM(B.QTESTGER)
            FROM PCEST B
           WHERE B.CODFILIAL IN ('13', '4')
             AND B.CODPROD = A.CODPROD) QTESTGERSOMA
    FROM PCEST A, PCPRODUT C
   WHERE A.CODPROD = C.CODPROD
     AND A.CODFILIAL IN ('13')
     AND C.CODEPTO NOT IN (97)
     AND A.QTEST <> (SELECT SUM(B.QTESTGER)
                       FROM PCEST B
                      WHERE B.CODFILIAL IN ('13', '4')
                        AND B.CODPROD = A.CODPROD)
   ORDER BY C.CODPRODMASTER, CODPROD;
/
/*Estoque contabil menor que zero - LOJAS */
  SELECT E.rowid, E.CODFILIAL, E.CODPROD, P.DESCRICAO, E.QTEST, E.QTESTGER
    FROM PCEST E, PCPRODUT P
   WHERE E.CODPROD = P.CODPROD
	 AND E.CODFILIAL = '2'
     AND QTEST < 0;
/

SELECT ,* FROM PCMOV M WHERE M.CODPROD = 805567;
/*VERIFICAR SE TEVE MOVIMENTACAO COM FILIALRETIRA 1 OU 2   */
  SELECT D.CODFILIAL, M.CODFILIALRETIRA, M.*
    FROM PCMOV M, PCNFSAID D
   WHERE D.NUMTRANSVENDA = M.NUMTRANSVENDA
     AND M.CODFILIALRETIRA IN ('1', '2')
     AND D.CODFILIAL IN ('5', '6')
     AND M.DTMOV = TRUNC(SYSDATE);
/

SELECT A.CODFILIAL,
       A.CODPROD,
       C.CODPRODMASTER,
       C.DESCRICAO,
       A.QTEST,
       (SELECT SUM(B.QTESTGER)
          FROM PCEST B
         WHERE B.CODFILIAL IN ( '11')
           AND B.CODPROD = A.CODPROD) QTESTGERSOMA
  FROM PCEST A, PCPRODUT C
 WHERE A.CODPROD = C.CODPROD
   AND A.CODFILIAL IN ('11') 
   AND C.CODEPTO NOT IN (97)
   AND A.QTEST <> (SELECT SUM(B.QTESTGER)
                     FROM PCEST B
                    WHERE B.CODFILIAL IN ( '11')
                      AND B.CODPROD = A.CODPROD)
 ORDER BY C.CODPRODMASTER, CODPROD;
