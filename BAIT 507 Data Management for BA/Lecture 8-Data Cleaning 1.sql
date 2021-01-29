-- Handling NULL
-- Advanced Text Data Processing
create table null_or_not (s varchar2(100), comments varchar2(100));
insert into null_or_not values ('', 'empty string');
insert into null_or_not values (' ', 'A string that contains a sing le space character');
insert into null_or_not values ('hello', 'hello');
insert into null_or_not values (NULL, 'NULL without quote');
insert into null_or_not values (Null, 'Null without quote');
insert into null_or_not values (null, 'null without quote');
insert into null_or_not values ('NULL', 'NULL with quote');
insert into null_or_not values ('Null', 'NULL with quote');
insert into null_or_not values ('null', 'null with quote');
commit;
SELECT * FROM null_or_not WHERE s IS NULL; SELECT * FROM null_or_not WHERE s IS NOT NULL;

-- IS NULL
SELECT CASE
    WHEN '' IS NULL THEN 'IS NULL'
        ELSE 'NOT NULL'
    END AS RES
FROM DUAL;

-- IS NOT NULL
SELECT CASE
        WHEN 'a' IS NULL THEN 'IS NULL'
        ELSE 'IS NULL'
    END AS RES
FROM DUAL;

-- Quickly test if something is null: where
select * from dual where '' IS NULL;
select * from dual where '' IS NOT NULL;

-- COALESCE
SELECT * FROM dual WHERE COALESCE('', 'NULL') = 'NULL'; -- return null
SELECT COALESCE(NULL, NULL, 1, NULL, 2) ans FROM DUAL; -- return 1
SELECT COALESCE('A', NULL, NULL, 'B') ans FROM DUAL; -- return A
SELECT COALESCE(NULL, NULL) ans FROM DUAL; -- return null

select 1+2+NULL ans from dual; -- return null

select 'Sauder' || '' || 'School' ans from dual; -- SauderSchool
select 'Sauder' || null || 'School' ans from dual; -- SauderSchool

SELECT CASE
        WHEN   1 = null THEN 'true'
 WHEN NOT ( 1 = null) then 'false'
ELSE 'null'
END AS BOOLEAN_VALUE
FROM
DUAL;

 1 IN (1, NULL) -- True
 1 NOT IN (1, NULL) -- False
 NULL IN (1, 2) -- Null
 Null in (Null) -- Null

-- Null in NULL In “WHERE” and “Check Constraints”
SELECT * FROM table_name WHERE logical_expression
--  For a row to be included in the result, the expression must be True for the row.
-- If the condition is False or Null, then the row is filtered out from the result.


CREATE TABLE MYDB_USERS (
username VARCHAR2(100) PRIMARY KEY,
gender VARCHAR(10),
age_at_signup INT,
CONSTRAINT ck_gender CHECK (gender IN ('MALE', 'FEMALE'))
);

ALTER TABLE MYDB_USERS ADD CONSTRAINT ck_age
CHECK (age_at_signup BETWEEN 18 AND 100);

-- CHECK (logical_expression)
-- When the logical_expression evaluates to False, the check constraint rejects the row to be inserted or updated.
-- When the logical_expression evaluates to True or Null, the check constraint accepts the row to be inserted or updated.