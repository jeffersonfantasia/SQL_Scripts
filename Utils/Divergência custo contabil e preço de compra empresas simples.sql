WITH MOVENTRADA AS
 (SELECT M.CODFILIAL,
         M.DTMOV,
         M.CODPROD,
         M.PUNITCONT,
         M.CUSTOCONT,
         M.CODFISCAL,
         M.QTCONT
    FROM PCMOV M
   WHERE M.DTCANCEL IS NULL
     AND M.STATUS IN ('A', 'AB')
     AND M.CODFILIAL IN ('5','6')
     AND M.CODOPER LIKE 'E%'
     AND M.CODOPER NOT IN ('ED')
     AND M.DTMOV BETWEEN TO_DATE('01/01/2021', 'DD/MM/YYYY') AND
         TO_DATE('31/12/2021', 'DD/MM/YYYY'))
SELECT T.CODFILIAL,
       T.NUMTRANSITEM,
       T.DTMOV,
       T.DTCOMPRA,
       T.CODFISCAL,
       T.CODCOMPRA,
       T.CODPROD,
       T.DESCRICAO,
       T.QTCONT,
       T.CUSTOCONT,
       A.PUNITCONT
  FROM (SELECT M.CODFILIAL,
               M.NUMTRANSITEM,
               M.DTMOV,
               MIN(E.DTMOV) AS DTCOMPRA,
               M.CODFISCAL,
               E.CODFISCAL AS CODCOMPRA,
               M.CODPROD,
               P.DESCRICAO,
               M.QTCONT,
               M.CUSTOCONT
          FROM PCMOV M
          LEFT JOIN PCPRODUT P
            ON M.CODPROD = P.CODPROD
          LEFT JOIN MOVENTRADA E
            ON E.CODFILIAL = M.CODFILIAL
           AND E.CODPROD = M.CODPROD
           AND E.DTMOV >= M.DTMOV
         WHERE M.DTCANCEL IS NULL
           AND M.DTMOV BETWEEN TO_DATE('01/01/2021', 'DD/MM/YYYY') AND
                  TO_DATE('31/12/2021', 'DD/MM/YYYY')
           AND M.STATUS IN ('A', 'AB')
           AND M.CODFILIAL IN ('5','6')
           AND M.CODOPER LIKE 'S%'
           AND M.CODOPER NOT IN ('SD')
           AND M.CODFISCAL NOT IN (5117, 6117, 5923, 6923)
         GROUP BY M.CODFILIAL,
                  M.NUMTRANSITEM,
                  M.DTMOV,
                  M.CODFISCAL,
                  E.CODFISCAL,
                  M.CODPROD,
                  P.DESCRICAO,
                  M.QTCONT,
                  M.CUSTOCONT
         ORDER BY M.CODPROD, M.DTMOV) T
  LEFT JOIN MOVENTRADA A
    ON T.CODFILIAL = A.CODFILIAL
   AND T.CODPROD = A.CODPROD
   AND T.DTCOMPRA = A.DTMOV
 WHERE T.CUSTOCONT <> A.PUNITCONT
 ;

--CUSTO DAS DEVOLUCOES DE CLIENTES--
WITH MOVENTRADA AS
 (SELECT CODFILIAL, DTMOV, CODPROD, PUNITCONT, CODFISCAL, QTCONT
    FROM PCMOV M
   WHERE M.DTCANCEL IS NULL
     AND M.STATUS IN ('A', 'AB')
     AND M.CODFILIAL = '5'
     AND M.CODOPER LIKE 'E%'
     AND M.CODOPER NOT IN ('ED')
     AND M.DTMOV BETWEEN TO_DATE('01/01/2020', 'DD/MM/YYYY') AND
               TO_DATE('31/12/2021', 'DD/MM/YYYY'))
SELECT T.CODFILIAL,
       T.NUMTRANSITEM,
       T.DTMOV,
       T.DTCOMPRA,
       T.CODFISCAL,
       T.CODCOMPRA,
       T.CODPROD,
       T.DESCRICAO,
       T.QTCONT,
       T.CUSTOCONT,
       A.PUNITCONT
  FROM (SELECT M.CODFILIAL,
               M.NUMTRANSITEM,
               M.DTMOV,
               MAX(E.DTMOV) AS DTCOMPRA,
               M.CODFISCAL,
               E.CODFISCAL AS CODCOMPRA,
               M.CODPROD,
               P.DESCRICAO,
               M.QTCONT,
               M.CUSTOCONT
          FROM PCMOV M
          LEFT JOIN PCPRODUT P
            ON M.CODPROD = P.CODPROD
          LEFT JOIN MOVENTRADA E
            ON E.CODFILIAL = M.CODFILIAL
           AND E.CODPROD = M.CODPROD
           AND E.DTMOV <= M.DTMOV
         WHERE M.DTCANCEL IS NULL
           AND M.DTMOV BETWEEN TO_DATE('01/01/2020', 'DD/MM/YYYY') AND
               TO_DATE('31/12/2021', 'DD/MM/YYYY')
           AND M.STATUS IN ('A', 'AB')
           AND M.CODFILIAL = '5'
           AND M.CODOPER IN ('ED')
           AND M.CODFISCAL NOT IN (1117, 2117, 1923, 2923)
         GROUP BY M.CODFILIAL,
                  M.NUMTRANSITEM,
                  M.DTMOV,
                  M.CODFISCAL,
                  E.CODFISCAL,
                  M.CODPROD,
                  P.DESCRICAO,
                  M.QTCONT,
                  M.CUSTOCONT
         ORDER BY M.CODPROD, M.DTMOV) T
  LEFT JOIN MOVENTRADA A
    ON T.CODFILIAL = A.CODFILIAL
   AND T.CODPROD = A.CODPROD
   AND T.DTCOMPRA = A.DTMOV
 WHERE T.CUSTOCONT <> A.PUNITCONT
--WHERE T.CODPROD IN (795556, 799277)
;

--CUSTO DEVOLUCAO FORNECEDORES--

WITH MOVENTRADA AS
 (SELECT CODFILIAL, DTMOV, CODPROD, PUNITCONT, CUSTOCONT, CODFISCAL, QTCONT
    FROM PCMOV M
   WHERE M.DTCANCEL IS NULL
     AND M.STATUS IN ('A', 'AB')
     AND M.CODFILIAL = '5'
     AND M.CODOPER LIKE 'E%'
     AND M.CODOPER NOT IN ('ED')
     AND M.DTMOV BETWEEN TO_DATE('01/01/2020', 'DD/MM/YYYY') AND
               TO_DATE('31/12/2021', 'DD/MM/YYYY'))
SELECT T.CODFILIAL,
       T.NUMTRANSITEM,
       T.DTMOV,
       T.DTCOMPRA,
       T.CODFISCAL,
       T.CODCOMPRA,
       T.CODPROD,
       T.DESCRICAO,
       T.QTCONT,
       T.CUSTOCONT,
       A.PUNITCONT
  FROM (SELECT M.CODFILIAL,
               M.NUMTRANSITEM,
               M.DTMOV,
               MAX(E.DTMOV) AS DTCOMPRA,
               M.CODFISCAL,
               E.CODFISCAL AS CODCOMPRA,
               M.CODPROD,
               P.DESCRICAO,
               M.QTCONT,
               M.CUSTOCONT
          FROM PCMOV M
          LEFT JOIN PCPRODUT P
            ON M.CODPROD = P.CODPROD
          LEFT JOIN MOVENTRADA E
            ON E.CODFILIAL = M.CODFILIAL
           AND E.CODPROD = M.CODPROD
           AND E.DTMOV <= M.DTMOV
         WHERE M.DTCANCEL IS NULL
           AND M.DTMOV BETWEEN TO_DATE('01/01/2020', 'DD/MM/YYYY') AND
               TO_DATE('31/12/2021', 'DD/MM/YYYY')
           AND M.STATUS IN ('A', 'AB')
           AND M.CODFILIAL = '5'
              --AND M.CODOPER LIKE 'S%'
           AND M.CODOPER IN ('SD')
           AND M.CODFISCAL NOT IN (5117, 6117, 5923, 6923)
         GROUP BY M.CODFILIAL,
                  M.NUMTRANSITEM,
                  M.DTMOV,
                  M.CODFISCAL,
                  E.CODFISCAL,
                  M.CODPROD,
                  P.DESCRICAO,
                  M.QTCONT,
                  M.CUSTOCONT
         ORDER BY M.CODPROD, M.DTMOV) T
  LEFT JOIN MOVENTRADA A
    ON T.CODFILIAL = A.CODFILIAL
   AND T.CODPROD = A.CODPROD
   AND T.DTCOMPRA = A.DTMOV
 WHERE T.CUSTOCONT <> A.PUNITCONT
 ORDER BY DTMOV;
