SELECT *
  FROM DBA_VIEWS D
 WHERE D.VIEW_NAME LIKE 'VIEW_JC_%'
   AND OWNER = 'BROKER';