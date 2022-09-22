CREATE OR REPLACE VIEW VIEW_JC_LOGISTICA AS
 WITH SEPARACAO AS
  (SELECT NUMPED,
          ROUND((CASE
                  WHEN COUNT(NUMPED) > 0 THEN
                   (SUM(PERC) / COUNT(NUMPED))
                  ELSE
                   0
                END),
                0) PERCSEP,
          (SELECT MIN(JCENDOS.DT_INICIO)
             FROM JCENDOS, JCENDOSITEM
            WHERE JCENDOS.ID = JCENDOSITEM.OS_ID
              AND NUMPED = JCENDOSITEM.PEDIDO_ID) DTINICIOSEP,
          (SELECT MAX(JCENDOS.DT_FIM)
             FROM JCENDOS, JCENDOSITEM
            WHERE JCENDOS.ID = JCENDOSITEM.OS_ID
              AND NUMPED = JCENDOSITEM.PEDIDO_ID) DTFIMSEP
     FROM (SELECT I.NUMPED,
                  I.CODPROD,
                  P.DESCRICAO,
                  (CASE
                    WHEN (COUNT(I.CODPROD) > 0 AND SUM(I.QT) > 0) THEN
                     (ROUND(((SUM(S.QTSEPARADA) /
                            (SUM(I.QT) / COUNT(I.CODPROD))) * 100),
                            0))
                    ELSE
                     0
                  END) PERC
             FROM PCPEDI I
             JOIN JCITEMSEPARACAO S ON I.NUMPED = S.NUMPED
                                   AND I.CODPROD = S.CODPROD
             LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
            GROUP BY I.NUMPED, I.CODPROD, P.DESCRICAO)
    GROUP BY NUMPED),
 CONFERENCIA AS
  (SELECT NUMPED,
          (CASE
            WHEN COUNT(NUMPED) > 0 THEN
             (SUM(PERC) / COUNT(NUMPED))
            ELSE
             0
          END) AS PERCCONF,
          MIN(DTINICIOCONF) DTINICIOCONF,
          MAX(DTFIMCONF) DTFIMCONF
     FROM (SELECT I.NUMPED,
                  I.CODPROD,
                  P.DESCRICAO,
                  MIN(C.DATACONF) DTINICIOCONF,
                  MAX(C.DATACONF) DTFIMCONF,
                  (CASE
                    WHEN (COUNT(I.CODPROD) > 0 AND SUM(I.QT) > 0) THEN
                     (ROUND(((SUM(C.QTCONF) / (SUM(I.QT) / COUNT(I.CODPROD))) * 100),
                            0))
                    ELSE
                     0
                  END) AS PERC
             FROM PCPEDI I
             LEFT JOIN PCITEMLOTECONFERIDO C ON I.NUMPED = C.NUMPED
                                            AND I.CODPROD = C.CODPROD
             LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
            GROUP BY I.NUMPED, I.CODPROD, P.DESCRICAO)
    GROUP BY NUMPED),
 FATURAMENTO AS
  (SELECT A.NUMNOTA, A.NUMVOLUME, A.NUMPED, DTHORAAUTORIZACAOSEFAZ AS DTFAT, A.TRANSPORTADORA
     FROM PCNFSAID A),
 EXPEDICAO AS
  (SELECT B.PEDIDO_ID NUMPED, MAX(B.VOLUME) VOLCONF, MAX(B.DT_CONF) DTEXPED
     FROM JCROMANEIOPEDVOL B
     JOIN JCROMANEIOC C ON B.ROMANEIO_ID = C.ID
     WHERE C.DT_CANCEL IS NULL
    GROUP BY B.PEDIDO_ID, B.ROMANEIO_ID)
 SELECT P.NUMPED,
        S.PERCSEP,
        S.DTINICIOSEP,
        S.DTFIMSEP,
        C.PERCCONF,
        C.DTINICIOCONF,
        C.DTFIMCONF,
        F.NUMNOTA,
        F.DTFAT,
        F.NUMVOLUME,
        F.TRANSPORTADORA,
        E.DTEXPED,
        E.VOLCONF,
        (CASE
          WHEN NVL(F.NUMVOLUME, 0) > 0 THEN
           (NVL(E.VOLCONF, 0) / NVL(F.NUMVOLUME, 0)) * 100
          ELSE
           0
        END) PERCEXP
   FROM PCPEDC P
   JOIN SEPARACAO S ON P.NUMPED = S.NUMPED
   LEFT JOIN CONFERENCIA C ON P.NUMPED = C.NUMPED
   LEFT JOIN FATURAMENTO F ON P.NUMPED = F.NUMPED
   LEFT JOIN EXPEDICAO E ON P.NUMPED = E.NUMPED
  WHERE P.CONDVENDA IN (1, 5, 8, 9, 10)
    AND P.DATA >= TO_DATE('01/01/2021', 'DD/MM/YYYY');
 /
