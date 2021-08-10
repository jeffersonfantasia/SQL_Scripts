SELECT CODPROD,
       SUM (QTPENDENTE) QTPENDENTE,
       SUM (VLPENDENTE) VLPENDENTE,
       (SUM (VLPENDENTE) / SUM (QTPENDENTE)) VLMEDIO
  FROM (
    SELECT I.CODPROD,
           I.QT AS QTPENDENTE,
           (I.PVENDA * I.QT) AS VLPENDENTE
      FROM PCPEDI I
     INNER JOIN PCPEDC C ON I.NUMPED = C.NUMPED
      LEFT JOIN PCSUPERV V ON C.CODSUPERVISOR = V.CODSUPERVISOR
     WHERE C.POSICAO NOT IN (
        'F', 'C'
    )
       AND V.CODGERENTE IN (
        1, 8, 9, 10
    )
)
 GROUP BY CODPROD;
/