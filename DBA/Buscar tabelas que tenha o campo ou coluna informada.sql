SELECT DISTINCT COLUMN_NAME, TABLE_NAME
  FROM ALL_TAB_COLUMNS C --, ALL_OBJECTS O
 WHERE C.COLUMN_NAME = 'CODCONT'
 ORDER BY TABLE_NAME;
