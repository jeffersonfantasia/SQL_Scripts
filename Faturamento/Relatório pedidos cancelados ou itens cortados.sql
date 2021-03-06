WITH PEDIDOS_CANCELADOS AS
 (SELECT P.CODFILIAL,
         P.DTCANCEL AS DATA,
         P.CODUSUR,
         U.NOME,
         P.NUMPED,
         P.POSICAO,
         (P.CODPLPAG || ' - ' || G.DESCRICAO) AS PLANO_PAGTO,
         P.CODCLI,
         C.CLIENTE,
         P.CODCOB,
         I.CODPROD,
         T.DESCRICAO AS PRODUTO,
         I.QTFALTA AS QT,
         UPPER(N.MOTIVO) AS MOTIVO,
         (I.PVENDA * I.QTFALTA) AS VALOR,
         'CANCELADOS' AS STATUS
    FROM PCPEDC P
   INNER JOIN PCPEDI I
      ON P.NUMPED = I.NUMPED
    LEFT JOIN PCUSUARI U
      ON P.CODUSUR = U.CODUSUR
    LEFT JOIN PCCLIENT C
      ON P.CODCLI = C.CODCLI
    LEFT JOIN PCSUPERV V
      ON P.CODSUPERVISOR = V.CODSUPERVISOR
    LEFT JOIN PCPRODUT T
      ON I.CODPROD = T.CODPROD
    LEFT JOIN PCNFCAN N
      ON I.NUMPED = N.NUMPED
    LEFT JOIN PCPLPAG G
      ON P.CODPLPAG = G.CODPLPAG
   WHERE V.CODGERENTE IN (1, 8, 9, 10)
     AND P.POSICAO IN ('C', 'CT')
   ORDER BY DATA, P.NUMPED),

NOTAS_CANCELADAS AS
 (SELECT P.CODFILIAL,
         P.DATACANC AS DATA,
         P.CODUSUR,
         U.NOME,
         P.NUMPED,
         'C' AS POSICAO,
         (P.CODPLPAG || ' - ' || G.DESCRICAO) AS PLANO_PAGTO,
         P.CODCLI,
         C.CLIENTE,
         P.CODCOB,
         I.CODPROD,
         T.DESCRICAO AS PRODUTO,
         I.QT,
         UPPER(N.MOTIVO) AS MOTIVO,
         (I.PVENDA * I.QT) AS VALOR,
         'CANCELADOS' AS STATUS
    FROM PCNFCAN P
   INNER JOIN PCNFCANITEM I
      ON P.NUMPED = I.NUMPED
    LEFT JOIN PCUSUARI U
      ON P.CODUSUR = U.CODUSUR
    LEFT JOIN PCCLIENT C
      ON P.CODCLI = C.CODCLI
    LEFT JOIN PCSUPERV V
      ON P.CODSUPERVISOR = V.CODSUPERVISOR
    LEFT JOIN PCPRODUT T
      ON I.CODPROD = T.CODPROD
    LEFT JOIN PCNFCAN N
      ON I.NUMPED = N.NUMPED
    LEFT JOIN PCPLPAG G
      ON P.CODPLPAG = G.CODPLPAG
   WHERE V.CODGERENTE IN (1, 8, 9, 10)
   ORDER BY DATA, P.NUMPED),

PEDIDOS_CORTE_LOGISTICA AS
 (SELECT P.CODFILIAL,
         P.DATA,
         P.CODUSUR,
         U.NOME,
         P.NUMPED,
         P.POSICAO,
         (P.CODPLPAG || ' - ' || G.DESCRICAO) AS PLANO_PAGTO,
         P.CODCLI,
         C.CLIENTE,
         P.CODCOB,
         I.CODPROD,
         T.DESCRICAO AS PRODUTO,
         R.QTCORTADA AS QT,
         UPPER(R.MOTIVO) AS MOTIVO,
         (I.PVENDA * R.QTCORTADA) AS VALOR,
         'CORTADOS NA LOG�STICA' AS STATUS
    FROM PCPEDC P
   INNER JOIN PCPEDI I
      ON P.NUMPED = I.NUMPED
   INNER JOIN PCCORTEI R
      ON I.NUMPED = R.NUMPED
     AND I.CODPROD = R.CODPROD
    LEFT JOIN PCUSUARI U
      ON P.CODUSUR = U.CODUSUR
    LEFT JOIN PCCLIENT C
      ON P.CODCLI = C.CODCLI
    LEFT JOIN PCSUPERV V
      ON P.CODSUPERVISOR = V.CODSUPERVISOR
    LEFT JOIN PCPRODUT T
      ON I.CODPROD = T.CODPROD
    LEFT JOIN PCPLPAG G
      ON P.CODPLPAG = G.CODPLPAG
   WHERE V.CODGERENTE IN (1, 8, 9, 10)
     AND P.POSICAO NOT IN ('C', 'CT')
   ORDER BY DATA, P.NUMPED),

--PARA TERMOS OS PEDIDOS QUE DEVEM SER RETIRADOS
--DA RELA��O DE PEDIDOS COM FALTA
PEDIDOS_FALTA_SOMADO AS
(SELECT R.NUMPED, SUM(R.PVENDA * R.QT) AS VL_TOTAL
  FROM PCFALTA R
  LEFT JOIN PCPEDC P
    ON R.NUMPED = P.NUMPED
  LEFT JOIN PCSUPERV V
    ON P.CODSUPERVISOR = V.CODSUPERVISOR
 WHERE V.CODGERENTE IN (1, 8, 9, 10)
   AND P.POSICAO NOT IN ('C', 'CT') 
HAVING SUM(R.PVENDA * R.QT) >= 700
 GROUP BY R.NUMPED),

PEDIDOS_FALTA_LIBERACAO AS
 (SELECT P.CODFILIAL,
         P.DATA,
         P.CODUSUR,
         U.NOME,
         P.NUMPED,
         P.POSICAO,
         (P.CODPLPAG || ' - ' || G.DESCRICAO) AS PLANO_PAGTO,
         P.CODCLI,
         C.CLIENTE,
         P.CODCOB,
         R.CODPROD,
         T.DESCRICAO AS PRODUTO,
         R.QT AS QT,
         'FALTA DE MERCADORIA' AS MOTIVO,
         (R.PVENDA * R.QT) AS VALOR,
         'CORTADOS NA LIBERACAO DO PEDIDO' AS STATUS
    FROM PCFALTA R
    LEFT JOIN PCPEDC P
      ON R.NUMPED = P.NUMPED
    LEFT JOIN PCPEDI I
      ON R.NUMPED = I.NUMPED
     AND R.CODPROD = I.CODPROD
    LEFT JOIN PCUSUARI U
      ON P.CODUSUR = U.CODUSUR
    LEFT JOIN PCCLIENT C
      ON P.CODCLI = C.CODCLI
    LEFT JOIN PCSUPERV V
      ON P.CODSUPERVISOR = V.CODSUPERVISOR
    LEFT JOIN PCPRODUT T
      ON R.CODPROD = T.CODPROD
    LEFT JOIN PCPLPAG G
      ON P.CODPLPAG = G.CODPLPAG
    LEFT JOIN PEDIDOS_FALTA_SOMADO FS
      ON R.NUMPED = FS.NUMPED   
   WHERE V.CODGERENTE IN (1, 8, 9, 10)
     AND P.POSICAO NOT IN ('C', 'CT')
     AND FS.NUMPED IS NULL
   ORDER BY DATA, P.NUMPED)
          
SELECT *
  FROM (SELECT *
          FROM PEDIDOS_CANCELADOS
        UNION ALL
        SELECT *
          FROM NOTAS_CANCELADAS
        UNION ALL    
        SELECT *
          FROM PEDIDOS_CORTE_LOGISTICA
        UNION ALL
        SELECT *
          FROM PEDIDOS_FALTA_LIBERACAO)
 WHERE CODUSUR = 1   -- NUMPED = 9004400 
   AND DATA BETWEEN TO_DATE('01/08/2020', 'DD/MM/YYYY') AND
       TO_DATE('13/08/2020', 'DD/MM/YYYY')
 ORDER BY DATA, NUMPED, STATUS, CODPROD
