/*-----AN�LISE DO CUSTO FINANCEIRO DA MERCADORIA VENDIDA----------*/
SELECT M.CODFILIAL, ROUND(SUM(M.QT * M.CUSTOFINEST), 2) CUSTO_MERC
  FROM PCMOV M, PCNFSAID F
 WHERE M.NUMTRANSVENDA = F.NUMTRANSVENDA
   AND F.CONDVENDA NOT IN (0, 8, 9, 10, 13, 20, 98, 99)
   AND F.TIPOVENDA NOT IN ('1', 'V4', 'SR', 'DF')
   AND F.DTCANCEL IS NULL
   AND M.CODFILIAL = 5
   AND M.DTMOV BETWEEN TO_DATE('01/12/2018', 'DD/MM/YYYY') AND
       TO_DATE('31/12/2018', 'DD/MM/YYYY')
 GROUP BY M.CODFILIAL;
/

/*-----AN�LISE DO VALOR DA MERCADORIA COMPRADA----------*/
  SELECT M.CODFILIAL, ROUND(SUM(M.QT * M.PUNIT), 2) VL_MERC
    FROM PCMOV M, PCNFENT E
   WHERE M.NUMTRANSENT = E.NUMTRANSENT
     AND E.TIPODESCARGA = '1'
     AND E.DTCANCEL IS NULL
     AND M.CODFILIAL = 5
     AND M.DTMOV BETWEEN TO_DATE('01/12/2018', 'DD/MM/YYYY') AND
         TO_DATE('31/12/2018', 'DD/MM/YYYY')
   GROUP BY M.CODFILIAL;
/

/*-----AN�LISE PRODUTOS COM DO VALOR DA MERCADORIA COMPRADA DIFERENTE DO CUSTO VENDIDO----------*/
  SELECT *
    FROM (SELECT M.CODFILIAL,
                 S.DTMOV,
                 M.CODPROD,
                 P.DESCRICAO,
                 S.NUMTRANSVENDA,
                 S.QT,
                 ROUND(S.CUSTO_PROD, 4) CUSTOFIN_VENDA,
                 M.NUMTRANSENT,
                 ROUND(M.PUNIT, 4) VL_PROD,
                 EST.CUSTOFIN CUSTO_1103
            FROM PCMOV M,
                 PCNFENT E,
                 PCPRODUT P,
                 PCEST EST,
                 (SELECT T.CODFILIAL,
                         T.DTMOV,
                         V T.CODPROD,
                         T.NUMTRANSVENDA,
                         T.QT,
                         T.CUSTOFINEST CUSTO_PROD
                    FROM PCMOV T, PCNFSAID F
                   WHERE T.NUMTRANSVENDA = F.NUMTRANSVENDA
                     AND F.CONDVENDA NOT IN (0, 8, 9, 10, 13, 20, 98, 99)
                     AND F.TIPOVENDA NOT IN ('1', 'V4', 'SR', 'DF')
                     AND F.DTCANCEL IS NULL
                     AND T.DTMOV BETWEEN TO_DATE('01/12/2018', 'DD/MM/YYYY') AND
                         TO_DATE('31/12/2018', 'DD/MM/YYYY')) S
           WHERE M.NUMTRANSENT = E.NUMTRANSENT
             AND M.CODFILIAL = S.CODFILIAL
             AND M.CODPROD = S.CODPROD
             AND P.CODPROD = M.CODPROD
             AND EST.CODPROD = M.CODPROD
             AND EST.CODFILIAL = M.CODFILIAL
             AND E.TIPODESCARGA = '1'
             AND E.DTCANCEL IS NULL
             AND M.CODFILIAL = 6
             AND M.DTMOV BETWEEN TO_DATE('01/12/2018', 'DD/MM/YYYY') AND
                 TO_DATE('31/12/2018', 'DD/MM/YYYY'))
   WHERE CODPROD IN (799332, 797055, 797552) -- CUSTOFIN_VENDA <> VL_PROD
   ORDER BY DTMOV, CODPROD;
/

/*-----AN�LISE AGRUPADA PRODUTOS COM DO VALOR DA MERCADORIA COMPRADA DIFERENTE DO CUSTO VENDIDO----------*/
  SELECT CODFILIAL,
         /* DTMOV,*/
         CODPROD,
         DESCRICAO,
         SUM(QT) QT_TOTAL,
         CUSTOFIN_VENDA,
         VL_PROD_COMPRA,
         CUSTO_1103
    FROM (SELECT M.CODFILIAL,
                 S.DTMOV,
                 M.CODPROD,
                 P.DESCRICAO,
                 S.NUMTRANSVENDA,
                 S.QT,
                 ROUND(S.CUSTO_PROD, 4) CUSTOFIN_VENDA,
                 M.NUMTRANSENT,
                 ROUND(M.PUNIT, 4) VL_PROD_COMPRA,
                 EST.CUSTOFIN CUSTO_1103
            FROM PCMOV M,
                 PCNFENT E,
                 PCPRODUT P,
                 PCEST EST,
                 (SELECT T.CODFILIAL,
                         T.DTMOV,
                         T.CODPROD,
                         T.NUMTRANSVENDA,
                         T.QT,
                         T.CUSTOFINEST CUSTO_PROD
                    FROM PCMOV T, PCNFSAID F
                   WHERE T.NUMTRANSVENDA = F.NUMTRANSVENDA
                     AND F.CONDVENDA NOT IN (0, 8, 9, 10, 13, 20, 98, 99)
                     AND F.TIPOVENDA NOT IN ('1', 'V4', 'SR', 'DF')
                     AND F.DTCANCEL IS NULL
                     AND T.DTMOV BETWEEN TO_DATE('01/12/2018', 'DD/MM/YYYY') AND
                         TO_DATE('31/12/2018', 'DD/MM/YYYY')) S
           WHERE M.NUMTRANSENT = E.NUMTRANSENT
             AND M.CODFILIAL = S.CODFILIAL
             AND M.CODPROD = S.CODPROD
             AND P.CODPROD = M.CODPROD
             AND EST.CODPROD = M.CODPROD
             AND EST.CODFILIAL = M.CODFILIAL
             AND E.TIPODESCARGA = '1'
             AND E.DTCANCEL IS NULL
             AND M.CODFILIAL = 6
             AND M.DTMOV BETWEEN TO_DATE('01/12/2018', 'DD/MM/YYYY') AND
                 TO_DATE('31/12/2018', 'DD/MM/YYYY'))
   WHERE
  /*CODPROD IN (799332, 797055, 797552)*/
   CUSTOFIN_VENDA <> VL_PROD_COMPRA
   GROUP BY CODFILIAL,
            /*  DTMOV,*/
            CODPROD,
            DESCRICAO,
            CUSTOFIN_VENDA,
            VL_PROD_COMPRA,
            CUSTO_1103
   ORDER BY CODPROD;
/

/*-----AN�LISE HIST�RICO DE CUSTOS----------*/
  SELECT CODFILIAL,
         DATA,
         CODPROD,
         VALORULTENT_ANT,
         VALORULTENT,
         CUSTOFIN_ANT,
         CUSTOFIN,
         PROGRAMA,
         USUARIO,
         MAQUINA
    FROM PCLOGESTOQUE
   WHERE CODPROD = 1913
     AND CODFILIAL = 5
     AND DATA BETWEEN TO_DATE('01/12/2018', 'DD/MM/YYYY') AND
         TO_DATE('31/12/2018', 'DD/MM/YYYY')
   ORDER BY DATA DESC;
/

/*-----AN�LISE CUSTOS NO PEDIDO DE VENDA----------*/
  SELECT C.DATA,
         C.DTFAT,
         C.CODFILIAL,
         C.NUMTRANSVENDA,
         I.CODPROD,
         P.DESCRICAO,
         I.CUSTOFINEST
    FROM PCPEDC C, PCPEDI I, PCPRODUT P
   WHERE C.NUMPED = I.NUMPED
     AND P.CODPROD = I.CODPROD
     AND C.NUMTRANSVENDA = 10131569;
/
