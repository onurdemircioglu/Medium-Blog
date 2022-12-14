DECLARE
    V_DATE_01 DATE := TO_DATE('17072021' ,'DDMMYYYY'); -- TEST DATE
    V_START_DATE DATE;
    V_END_DATE DATE;
    V_RESULT_DATE DATE; -- END OF NEXT MONTH IS INCLUDED
    V_RESULT_DATE2 DATE; -- END OF NEXT MONTH IS NOT INCLUDED
    V_WEEKDAY_INPUT VARCHAR2(9) := 'TUESDAY'; -- THIS VARIABLE SHOULD BE FILLED BY USER
BEGIN
    V_START_DATE := TRUNC(ADD_MONTHS(V_DATE_01,1),'MONTH');
    V_END_DATE := LAST_DAY(ADD_MONTHS(V_DATE_01,1));
 
    WHILE V_START_DATE <= V_END_DATE -- BEGINS FROM FIRST DAY OF NEXT MONTH (ALSO IT IS POSSIBLE TO START 3RD WEEK START)
    LOOP

        IF TRIM(TO_CHAR(V_START_DATE, 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH')) = V_WEEKDAY_INPUT THEN -- IT STARTS COUNTING FROM SUNDAY
            V_RESULT_DATE := V_START_DATE; -- WHEN IT FINDS IT ASSIGNS VALUE TO V_RESULT_DATE
        END IF;
         
        IF TRIM(TO_CHAR(V_START_DATE, 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH')) = V_WEEKDAY_INPUT AND V_START_DATE != LAST_DAY(V_START_DATE) THEN
            V_RESULT_DATE2 := V_START_DATE; -- WHEN IT FINDS IT ASSIGNS VALUE TO V_RESULT_DATE2
        END IF;
         
        V_START_DATE := V_START_DATE + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('INPUT DATE >> ' || V_DATE_01);
    DBMS_OUTPUT.PUT_LINE('V_RESULT_DATE >> ' || V_RESULT_DATE);
    DBMS_OUTPUT.PUT_LINE('V_RESULT_DATE2 >> ' || V_RESULT_DATE2);
END;
/
