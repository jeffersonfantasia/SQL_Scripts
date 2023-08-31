SELECT A.NUMCAR,
       A.NUMPED,
       (C.CODCLI || ' - ' || C.CLIENTE) CLIENTE,
       (CASE
         WHEN A.VLATEND = 0 THEN
          A.VLBONIFIC
         ELSE
          A.VLATEND
       END) VLATEND,
       (SELECT COUNT(CODPROD) FROM PCPEDI I WHERE I.NUMPED = A.NUMPED) ITENS,
       (SELECT SUM(QT) FROM PCPEDI I WHERE I.NUMPED = A.NUMPED) QTD,
       A.DATA,
       P.DT_SINC AS DTENVIO_PED,
       D.DT_CONF AS DTCONF,
       A.NUMVOLUME VOLUMES,
       S.DTA_HORAENVIOSEFAZ AS DTFAT,
       F.DT_SINC AS DT_ENVIO_NF,
       E.DTEVENTO AS DT_EMBARQUE,
       S.TRANSPORTADORA,
       (CASE
         WHEN E.DTEVENTO IS NOT NULL THEN
          'COLETADO'
				 WHEN F.DT_SINC IS NOT NULL THEN
          'FALTA COLETA'
         WHEN S.DTA_HORAENVIOSEFAZ IS NOT NULL THEN
          'FALTA ENVIO NF'
         WHEN D.DT_CONF IS NOT NULL THEN
          'FALTA FATURAMENTO'
         WHEN P.DT_SINC IS NOT NULL THEN
          'FALTA SEPARACAO'
         ELSE
          NULL
       END) STATUS
  FROM PCPEDC A
  JOIN PCCLIENT C ON C.CODCLI = A.CODCLI
  JOIN JCEUROLOGPEDIDO P ON P.NUMPED = A.NUMPED
  LEFT JOIN JCEUROLOGCONFSEPARACAOC D ON A.NUMPED = D.NUMPED
  LEFT JOIN PCNFSAID S ON A.NUMTRANSVENDA = S.NUMTRANSVENDA
  LEFT JOIN JCEUROLOGNFSAID F ON F.NUMPED = A.NUMPED
  LEFT JOIN JCEUROLOGCONFEMBARQUE E ON E.NUMPED = A.NUMPED
 WHERE P.DT_SINC IS NOT NULL
   AND NOT (D.DT_CONF IS NOT NULL AND F.DT_SINC IS NOT NULL AND E.DTEVENTO IS NOT NULL)
 ORDER BY P.DT_SINC, D.DT_CONF, F.DT_SINC;
