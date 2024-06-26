----an�lise ultimas queries
WITH SUMMARY_SNAP AS
 (SELECT S.SQL_ID,
         MAX(T.SNAP_TIME) SNAP_TIME
    FROM PERFSTAT.STATS$SQL_SUMMARY S
    JOIN PERFSTAT.STATS$SNAPSHOT T ON T.SNAP_ID = S.SNAP_ID
   GROUP BY S.SQL_ID)
SELECT *
  FROM (SELECT S.SNAP_TIME, V.LAST_ACTIVE_TIME,
               V.SQL_ID,
               V.MODULE,
               V.PARSING_SCHEMA_NAME,
               V.SERVICE,
               V.SQL_TEXT,
               V.SQL_FULLTEXT,
               V.CPU_TIME,
               V.BUFFER_GETS,
               ROUND(((V.ELAPSED_TIME + 1) / (V.EXECUTIONS + 1) / 1000000),2) SEGUNDOS
          FROM V$SQL V
          JOIN SUMMARY_SNAP S ON S.SQL_ID = V.SQL_ID
         WHERE S.SNAP_TIME >= TRUNC(SYSDATE) - 1
           AND V.CHILD_NUMBER = 0)
 ORDER BY LAST_ACTIVE_TIME DESC;

----an�lise das queries mais demoradas
WITH SUMMARY_SNAP AS
 (SELECT S.SQL_ID,
         MAX(T.SNAP_TIME) SNAP_TIME
    FROM PERFSTAT.STATS$SQL_SUMMARY S
    JOIN PERFSTAT.STATS$SNAPSHOT T ON T.SNAP_ID = S.SNAP_ID
   GROUP BY S.SQL_ID),
CONSULTA AS (
 SELECT S.SNAP_TIME,
 V.LAST_ACTIVE_TIME,
               V.SQL_ID,
               V.MODULE,
               V.PARSING_SCHEMA_NAME SCHEMA_NAME,
               V.SERVICE,
               V.SQL_TEXT,
               V.SQL_FULLTEXT,
               V.CPU_TIME,
               V.BUFFER_GETS,
							 V.ELAPSED_TIME,
							 V.EXECUTIONS,
               ROUND(((V.ELAPSED_TIME ) / (V.EXECUTIONS + 1 ) / 1000000),2) SEGUNDOS
          FROM V$SQL V
          JOIN SUMMARY_SNAP S ON S.SQL_ID = V.SQL_ID
         WHERE S.SNAP_TIME >= TRUNC(SYSDATE) - 1
           AND V.CHILD_NUMBER = 0)
 SELECT *
 FROM CONSULTA
 ORDER BY SEGUNDOS DESC;
 
/*   -- Calcula o n�mero de minutos
  v_minutes := FLOOR(v_total_seconds / 60);

  -- Calcula o n�mero de segundos
  v_seconds := FLOOR(MOD(v_total_seconds, 60));

  -- Calcula o n�mero de milissegundos
  v_milliseconds := ROUND((v_total_seconds - TRUNC(v_total_seconds)) * 1000);*/
