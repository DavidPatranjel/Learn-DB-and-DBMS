SET SERVEROUTPUT ON;
DECLARE 
    d1 DATE; 
    d2 DATE;
BEGIN
    d1 := TO_DATE('&d1','DD-MM-YYYY');
    d2 := TO_DATE('&d2','DD-MM-YYYY');
    WHILE d1 <= d2
    LOOP
        DBMS_OUTPUT.PUT_LINE(d1);
        d1 := d1 + 1;
    END LOOP;
END;