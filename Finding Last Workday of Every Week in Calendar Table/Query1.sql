-- Settings update
ALTER SESSION SET NLS_TERRITORY = 'TURKEY';
ALTER SESSION set NLS_DATE_FORMAT = 'DD.MM.YYYY';
ALTER SESSION set NLS_TIME_FORMAT = 'HH24:MI:SSXFF';


CREATE TABLE CALENDAR (
  CALENDAR_DATE DATE PRIMARY KEY,
  CALENDAR_DAY NUMBER(1,0),
  CALENDAR_MONTH NUMBER(2,0),
  CALENDAR_YEAR NUMBER(4,0),
  DAY_NAME VARCHAR2(10),
  MONTH_NAME VARCHAR2(10),
  QUARTER NUMBER(1,0),
  IS_WORKDAY NUMBER(1,0)
);

DECLARE
  START_DATE DATE := TO_DATE('01-JAN-2021', 'DD-MON-YYYY');
  END_DATE DATE := TO_DATE('31-DEC-2022', 'DD-MON-YYYY');
BEGIN
  FOR i IN 0..(END_DATE-START_DATE)
  LOOP
    INSERT INTO CALENDAR (CALENDAR_DATE, CALENDAR_DAY, CALENDAR_MONTH, CALENDAR_YEAR, DAY_NAME, MONTH_NAME, QUARTER, IS_WORKDAY)
    VALUES (
      START_DATE + i,
      TO_NUMBER(TO_CHAR(START_DATE + i, 'D')),
      TO_NUMBER(TO_CHAR(START_DATE + i, 'MM')),
      TO_NUMBER(TO_CHAR(START_DATE + i, 'YYYY')),
      TO_CHAR(START_DATE + i, 'DAY'),
      TO_CHAR(START_DATE + i, 'MONTH'),
      CEIL(TO_NUMBER(TO_CHAR(START_DATE + i, 'MM')) / 3),
      CASE WHEN TO_CHAR(START_DATE + i, 'D') NOT IN (6, 7) THEN 1 ELSE 0 END
    );
  END LOOP;
END;
/


UPDATE CALENDAR 
SET IS_WORKDAY = 0
WHERE 1=1
  AND CALENDAR_DATE IN ('07.01.2022', '21.01.2022')
;
COMMIT;


SELECT A.*
    	,TO_CHAR(CALENDAR_DATE,'IW') AS WEEK_BUCKET
FROM CALENDAR A
;


SELECT A.*
    	,TO_CHAR(CALENDAR_DATE,'IW') AS WEEK_BUCKET
FROM CALENDAR A
WHERE 1=1
    	AND IS_WORKDAY = 1
ORDER BY CALENDAR_DATE
;


-- Complete Code
SELECT WEEK_BUCKET
    	,MAX(CALENDAR_DATE) AS LAST_WORKDAY_OF_WEEK
FROM
    (
    SELECT A.*
        	,TO_CHAR(CALENDAR_DATE,'IW') AS WEEK_BUCKET
        	,ROW_NUMBER() OVER (PARTITION BY TO_CHAR(CALENDAR_DATE, 'IW') ORDER BY CALENDAR_DATE) AS MY_RANKING
    FROM CALENDAR A
    WHERE 1=1
        	AND IS_WORKDAY = 1
    ) A
GROUP BY WEEK_BUCKET
ORDER BY WEEK_BUCKET
;


-- Alternative usage
...
...
	AND TRUNC(SYDATE) IN
        (
        SELECT MAX(CALENDAR_DATE) AS LAST_WORKDAY_OF_WEEK
        FROM
            (
            SELECT A.*
                	,TO_CHAR(CALENDAR_DATE,'IW') AS WEEK_BUCKET
                	,ROW_NUMBER() OVER (PARTITION BY TO_CHAR(CALENDAR_DATE, 'IW') ORDER BY CALENDAR_DATE) AS MY_RANKING
            FROM CALENDAR A
            WHERE 1=1
                	AND IS_WORKDAY = 1
            ) A
        GROUP BY WEEK_BUCKET
        )
;
