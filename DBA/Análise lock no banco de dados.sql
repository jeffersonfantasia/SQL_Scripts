/*-----------VERIFICAR LOCK NO BANCO-----------------*/
SELECT LPAD (' ', (LEVEL - 1) * 2, ' ') || NVL (S.USERNAME, '(ORACLE)') AS USERNAME,
       S.OSUSER,
       S.SID,
       S.SERIAL#,
       P.SPID,
       S.LOCKWAIT,
       S.STATUS,
       S.MODULE,
       S.MACHINE,
       S.PROGRAM,
       TO_CHAR (S.LOGON_TIME, 'DD-MON-YYYY HH24:MI:SS') AS LOGON_TIME
  FROM V$SESSION S,
       V$PROCESS P
 WHERE P.ADDR = S.PADDR
/*AND OSUSER = 'usuario002'*/
  CONNECT BY
    PRIOR S.SID = S.BLOCKING_SESSION
START WITH S.BLOCKING_SESSION IS NULL
 ORDER BY S.LOCKWAIT,
          OSUSER;
/


/*-----------VERIFICAR LOCK NO BANCO COMO SYS-----------------*/
SELECT (
    SELECT SERIAL#
      FROM V$SESSION S
     WHERE S.SID = L.SID
) SERIAL,
       SUBSTR (OS_USER_NAME, 1, 10) "OS User",
       SUBSTR (PROCESS, 1, 8) "OS Pid",
       SUBSTR (ORACLE_USERNAME, 1, 10) "Oracle User",
       SUBSTR (L.SID, 1, 6) "SID",
       SUBSTR (DECODE (TYPE, 'MR', 'Media Recovery', 'RT', 'Redo Thread',
                       'UN', 'User Name', 'TX', 'Transaction', 'TM',
                       'DML', 'UL', 'PL/SQL User Lock', 'DX', 'Distributed Xaction',
                       'CF', 'Control File', 'IS', 'Instance State', 'FS',
                       'File Set', 'IR', 'Instance Recovery', 'ST', 'Disk Space Transaction',
                       'TS', 'Temp Segment', 'IV', 'Library Cache Invalidation', 'LS',
                       'Log Start or Switch', 'RW', 'Row Wait', 'SQ', 'Sequence Number',
                       'TE', 'Extend Table', 'TT', 'Temp Table', TYPE), 1, 15) "Lock Type",
       SUBSTR (DECODE (LMODE, 0, 'None', 1, 'Null',
                       2, 'Row-S (SS)', 3, 'Row-X (SX)', 4,
                       'Share', 5, 'S/Row-X (SSX)', 6, 'Exclusive',
                       LMODE), 1, 10) "Lock Held",
       SUBSTR (DECODE (REQUEST, 0, 'None', 1, 'Null',
                       2, 'Row-S (SS)', 3, 'Row-X (SX)', 4,
                       'Share', 5, 'S/Row-X (SSX)', 6, 'Exclusive',
                       REQUEST), 1, 15) "Lock Requested",
       SUBSTR (DECODE (BLOCK, 0, 'Not Blocking', 1, 'Blocking',
                       2, 'Global', BLOCK), 1, 20) "Status",
       SUBSTR (OWNER, 1, 10) "Owner",
       SUBSTR (OBJECT_NAME, 1, 10) "Object name"
  FROM V$LOCKED_OBJECT LO,
       DBA_OBJECTS DO,
       V$LOCK L
 WHERE LO.OBJECT_ID = DO.OBJECT_ID
   AND L.SID = LO.SESSION_ID;
/
