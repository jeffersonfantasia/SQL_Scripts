SELECT t.numped,
       jt.*
  FROM BROKER.JCWEBMANDAE t,
       JSON_TABLE(t.JSON_GET,
                  '$.events[*]'
                  COLUMNS(id VARCHAR2(100) PATH '$.id',
                          event_date VARCHAR2(100) PATH '$.date',
                          TIMESTAMP VARCHAR2(100) PATH '$.timestamp',
                          NAME VARCHAR2(100) PATH '$.name',
                          description VARCHAR2(500) PATH '$.description')) jt
 WHERE jt.name = 'Entrega realizada';


WITH JSON_CLOB AS
 (SELECT T.JSON_GET COLUNA FROM BROKER.JCWEBMANDAE T),
ler_clob AS
 (SELECT DBMS_LOB.SUBSTR(COLUNA, 4000, 1) coluna FROM JSON_CLOB)

SELECT JSON_VALUE(COLUNA, '$.events[0].name') resultado FROM ler_clob;
