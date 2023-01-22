--NOVO MODELO REBAIXA
SELECT E.CODFILIAL,
       P.CODFAB,
       E.CODPROD,
       P.DESCRICAO,
       CASE
         WHEN P.NBM = '49019900' THEN
          'L'
         ELSE
          P.IMPORTADO
       END IMPORTANDO,
       NVL(E.QTESTGER, 0) AS QTESTGER,
       NVL(E.VALORULTENT, 0) AS VALORULTENT,
       NVL(E.CUSTOFIN, 0) AS CUSTOFIN
  FROM PCEST E
  JOIN PCPRODUT P ON P.CODPROD = E.CODPROD
 WHERE E.CODFILIAL IN ('1', '2', '3', '4', '7', '8')
   AND P.CODPRODMASTER IN
       (SELECT T.CODPRODMASTER
          FROM PCPRODUT T
         WHERE T.CODFAB IN ('1001109000048',
                            '1001603100152',
                            '1001001500003',
                            '1302956000001',
                            '1001603100150',
                            '1001101400027',
                            '1001001100023',
                            '1001001100022',
                            '1001001100019',
                            '1001001100021',
                            '1001001100020',
                            '1001005700035',
                            '1001109000046',
                            '1001603100155',
                            '1001607100048',
                            '1001000800035',
                            '1001000800034',
                            '1001000800033',
                            '1001602300053',
                            '1001603100135',
                            '1001108000036',
                            '1001602300040',
                            '1201602000136',
                            '1001602300039',
                            '1001607100051',
                            '1001603100128',
                            '1001602300051',
                            '1001902200030',
                            '1001902200029',
                            '1001902200028',
                            '1001902200025',
                            '1001603100153',
                            '3005101300029',
                            '3005101300034',
                            '1001602300054',
                            '1001301400224',
                            '1001301400220',
                            '1001301400223',
                            '1001301400222',
                            '1001603100154',
                            '1001612800032',
                            '1001005700013',
                            '1001603100156',
                            '1201602900070',
                            '1001603100125',
                            '1001603100122',
                            '1001609900069',
                            '1001108000033',
                            '1001603100118'))
 ORDER BY TO_NUMBER(E.CODFILIAL), P.CODPRODMASTER;

/*---------------------VALOR DA ULTIMA ENTRADA DE COMPRA----------------*/
WITH ULTIMAENTRADA_ESTRELA AS (
    SELECT MAX (M.DTMOV) AS MAX_DTMOV,
           M.CODPROD,
           M.PUNIT
      FROM PCMOV M
     INNER JOIN PCNFENT E ON M.NUMTRANSENT = E.NUMTRANSENT
     WHERE M.CODFILIAL = 2
       AND E.CODFORNEC = 9720
       AND M.CODPROD IN (
        811630,
814408,
811431,
811432,
814345,
811191,
811399,
811423,
811387,
811424,
811389,
811398,
811401,
811386,
811433,
814174,
815169,
811447,
814352,
809260
    )
     GROUP BY M.CODPROD,
              M.PUNIT
)
SELECT DISTINCT M.DTMOV,
                M.CODFILIAL,
                M.CODPROD,
                P.DESCRICAO,
                M.NUMNOTA,
                M.PUNIT
  FROM PCMOV M
  LEFT JOIN PCPRODUT P ON M.CODPROD = P.CODPROD
 INNER JOIN PCNFENT E ON M.NUMTRANSENT = E.NUMTRANSENT
 INNER JOIN ULTIMAENTRADA_ESTRELA U ON M.CODPROD = U.CODPROD
   AND M.DTMOV = U.MAX_DTMOV
 WHERE M.CODFILIAL = 2
   AND E.CODFORNEC = 9720
 ORDER BY M.CODPROD,
          M.DTMOV
/

/*-----------------------------------ANÁLISE DE PEÇAS VENDIDAS POR REDE DE CLIENTES OU CLIENTES----------------------------------*/
SELECT *
  FROM (
    SELECT M.CODPROD,
     /*C.CODREDE, */
           S.CODCLI,
           QT
      FROM PCMOV M,
           PCNFSAID S,
           PCCLIENT C
     WHERE M.NUMTRANSVENDA = S.NUMTRANSVENDA
       AND C.CODCLI = S.CODCLI
       AND S.CONDVENDA = 1
       AND S.DTSAIDA > TO_DATE ('01/01/2019', 'DD/MM/YYYY')
       AND M.CODPROD IN (
        803135, 803134, 803133, 803132, 802852, 804032, 806620
    )
) PIVOT (
    SUM (QT)
        /* FOR CODREDE IN (272, 254, 459, 285, 248, 384, 457, 455, 249, 300, 474, 599, 445, 583, 314, 584, 250, 588, 554, 429, 471, 415)*/
    FOR CODCLI
    IN (7354, 410, 386, 388, 4358, 7644, 8645, 7831)
)
 ORDER BY CODPROD;
/