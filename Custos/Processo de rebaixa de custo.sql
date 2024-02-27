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
       END IMPORTADO,
       NVL(E.QTESTGER, 0) AS QTESTGER,
       NVL(E.VALORULTENT, 0) AS VALORULTENT,
       NVL(E.CUSTOFIN, 0) AS CUSTOFIN
  FROM PCEST E
  JOIN PCPRODUT P ON P.CODPROD = E.CODPROD
 WHERE E.CODFILIAL NOT IN ('5', '6', '9','10')
   AND P.CODPRODMASTER IN
       (SELECT T.CODPRODMASTER
          FROM PCPRODUT T
         WHERE T.CODFAB IN ('1001602300055',
'1001603100171',
'1003105800039',
'1003105800038',
'1003105800040',
'1001607100057',
'1001603100177',
'3005100100100',
'1001109000059',
'3005101300032',
'1001602300050',
'1001609900078',
'1001602300056',
'1001603100169',
'1001603100117',
'3005101300033',
'1001607100052',
'1201602900131',
'1001603100128',
'1001603100119',
'1001603100118',
'1001611300027'))
 ORDER BY TO_NUMBER(E.CODFILIAL), P.CODPRODMASTER;
 
 
 
 

/*---------------------VALOR DA ULTIMA ENTRADA DE COMPRA----------------*/
WITH ULTIMAENTRADA_ESTRELA AS
 (SELECT MAX(M.DTMOV) AS MAX_DTMOV, M.CODPROD, M.PUNIT
    FROM PCMOV M
   INNER JOIN PCNFENT E ON M.NUMTRANSENT = E.NUMTRANSENT
   WHERE M.CODFILIAL = '2'
     AND E.CODFORNEC = 9720
     AND M.CODPROD IN
         (811630, 814408, 811431, 811432, 814345, 811191, 811399)
   GROUP BY M.CODPROD, M.PUNIT)
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
          M.DTMOV /
          
/*-----------------------------------AN�LISE DE PE�AS VENDIDAS POR REDE DE CLIENTES OU CLIENTES----------------------------------*/
            SELECT *
              FROM (SELECT M.CODPROD,
                           /*C.CODREDE, */
                           S.CODCLI,
                           QT
                      FROM PCMOV M, PCNFSAID S, PCCLIENT C
                     WHERE M.NUMTRANSVENDA = S.NUMTRANSVENDA
                       AND C.CODCLI = S.CODCLI
                       AND S.CONDVENDA = 1
                       AND S.DTSAIDA > TO_DATE('01/01/2019', 'DD/MM/YYYY')
                       AND M.CODPROD IN (803135,
                                         803134,
                                         803133,
                                         803132,
                                         802852,
                                         804032,
                                         806620))
            PIVOT(SUM(QT)
            /* FOR CODREDE IN (272, 254, 459, 285, 248, 384, 457, 455, 249, 300, 474, 599, 445, 583, 314, 584, 250, 588, 554, 429, 471, 415)*/
               FOR CODCLI IN(7354, 410, 386, 388, 4358, 7644, 8645, 7831))
             ORDER BY CODPROD;
/
