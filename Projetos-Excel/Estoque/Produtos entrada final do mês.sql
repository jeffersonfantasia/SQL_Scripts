SELECT M.CODPROD, SUM(M.QT) QT_ENTRADA_FIM_MES
  FROM PCMOV M
 WHERE M.NUMTRANSENT IN (305732,
                         305733,
                         305753,
                         305735,
                         305736,
                         305742,
                         305738,
                         305739,
                         305740,
                         305741,
                         305845,
                         305842,
                         305843,
                         305844)
   AND M.NUMBONUS IS NULL
 GROUP BY M.CODPROD;
/
