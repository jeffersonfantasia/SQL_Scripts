SET SERVEROUTPUT ON;
BEGIN
   DBMS_OUTPUT.put_line ('Hello World!');
END;
/*---------------------------------------------------*/

DECLARE
  l_message VARCHAR2( 255 ) := 'Hello Broker!';
BEGIN
  DBMS_OUTPUT.PUT_LINE( l_message );
END;
/*---------------------------------------------------*/

DECLARE
      v_result NUMBER;
BEGIN
   v_result := 1 / 0;
   EXCEPTION
      WHEN ZERO_DIVIDE THEN
         DBMS_OUTPUT.PUT_LINE( SQLERRM );
END;
/*---------------------------------------------------*/

DECLARE
  VNOMECLIENTE VARCHAR (60);
BEGIN
  SELECT C.CLIENTE
    INTO VNOMECLIENTE
    FROM PCCLIENT C
   WHERE C.CODCLI = 8630;

  DBMS_OUTPUT.PUT_LINE (VNOMECLIENTE);
END;
/*---------------------------------------------------*/

declare
    l_today date := sysdate;
begin
    if to_char(l_today,'D') < 4 then
        dbms_output.put_line(
           'Have a wonderful week');
    else
         dbms_output.put_line(
            'Enjoy the rest of the week');
     end if;
    dbms_output.put_line('today is '||
         to_char(l_today,'Day')||
         ' day '||to_char(l_today,'D')||
         ' of the week.');
end;

SET SERVEROUTPUT ON;
DECLARE
  howmany     INTEGER;
  num_tables  INTEGER;
BEGIN
  -- Begin processing
  SELECT COUNT(*) INTO howmany
  FROM USER_OBJECTS
  WHERE OBJECT_TYPE = 'TABLE'; -- Check number of tables
  num_tables := howmany;       -- Compute another value
  return NUM_TABLES;
END;