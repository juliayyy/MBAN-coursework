-- Outline:
-- Create Table
-- Columns
-- Data Types
-- Constraints

-- Insert Data
-- DESC, DROP, ALTER

-- Create Table
CREATE TABLE MUSICIANS (
             MID VARCHAR2(100) PRIMARY KEY,
             NAME VARCHAR2(1000) NOT NULL,
             DOB DATE NOT NULL,
             COUNTRY VARCHAR2(200) NOT NULL,
             AWARDS INT NOT NULL);

-- VARCHAR2:
-- INT Datatype: (-2)^31 to (2^32 -1)
-- Number: number (10,4) - number (p,s): p: total number, s: digits
-- Date:
to_date('2020-05-30','YYYY-MM-DD')
to_date('2020-05-30 00:00:00','YYYY-MM-DD HH24:MI:SS')
to_date('2020-05-30 23:10:30','YYYY-MM-DD HH24:MI:SS')

-- Constraints
-- Not Null
-- Primary Key:
-- Unique identifier
-- 0 / 1 primary key
-- Given any value of the primary key, there is at most one corresponding row in the table.
-- Primary key implies not null.
CREATE TABLE MUSICIANS (
             MID VARCHAR2(100),
             NAME VARCHAR2(1000) NOT NULL,
             DOB DATE NOT NULL,
             COUNTRY VARCHAR2(200) NOT NULL,
             AWARDS INT NOT NULL,
             CONSTRAINT PK_MUSCICIANS primary key (MID));

-- Primary key may contain multiple columns:
-- A primary key may contain multiple columns.
-- The value combination of the columns is a unique identifier.
CREATE TABLE MUSICIANS (
             MID VARCHAR2(100),
             NAME VARCHAR2(1000) NOT NULL,
             DOB DATE NOT NULL,
             COUNTRY VARCHAR2(200) NOT NULL,
             AWARDS INT NOT NULL,
             CONSTRAINT PK_MUSCICIANS primary key (AID,MID));

-- Constraints: Unique Constraints
-- Unique identifier of rows in the table: UNLESS values are NULL for ALL columns in the constraint.
-- Unlike primary keys: Columns in the constraint can have NULL values
--                      Unless there is a NOT NULL constraint on the column
-- “Uniqueness” does not apply when ALL columns in the constraint are NULL
 CREATE TABLE CREATIONS (
       CID   INT PRIMARY KEY,
       AID   VARCHAR(100)  NOT NULL,
       MID   VARCHAR(100)  NOT NULL,
       MROLE VARCHAR(1000) NOT NULL,
       CONSTRAINT uk_creations UNIQUE (AID, MID) );

-- Some details:
-- SQL command is mostly case insensitive: But Varchar2 Values are case sensitive
-- The length must be at least one character, and no more than 128 characters.
-- The first character must be a letter.
-- Names may include letters, numbers and the following special characters:
-- • the dollar sign ($),
--• the underscore (_)
--• and the hash mark (or pound sign) (#)
-- Names cannot be reserved words such as SELECT, CREATE, etc.,

-- Insert Data
CREATE TABLE PLAYED (
    PID INT PRIMARY KEY,
    USERID VARCHAR(100) NOT NULL,
    TID VARCHAR(100) NOT NULL,
    PTS DATE
);

INSERT INTO played VALUES (1999, 'U018', 'T026', to_date('2020-04-01', 'YYYY-MM-DD'));
INSERT INTO played VALUES (2000, 'U018', 'T026', to_date('2020-04-08 21:13:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO played (PID, USERID, TID, PTS) VALUES ( 2000,'U018', 'T026', to_date('2020-04-08 21:13:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO played (PTS, PID, USERID, TID) VALUES ( to_date('2020-04-08 21:13:00', 'YYYY-MM-DD HH24:MI:SS’), 2000, 'U018', 'T026');

-- desc:
desc users:
-- Drop:
drop table MyTable;
-- Alter:
CREATE TABLE MyTable (
    A VARCHAR2(100) NOT NULL,
    B VARCHAR2(100),
    C INT,
    CONSTRAINT uk_ab UNIQUE (A,B) );

ALTER USER user_name IDENTIFIED BY "new_password" REPLACE "old_password";
ALTER TABLE MyTable DROP CONSTRAINT UK_AB;
ALTER TABLE MyTable ADD CONSTRAINT UK_AB UNIQUE (A, B);
ALTER TABLE MyTable MODIFY (A NULL);
ALTER TABLE MyTable MODIFY (B NOT NULL);
ALTER TABLE MyTable RENAME COLUMN A TO AA;
ALTER TABLE MyTable ADD D DATE;

-- EX3:
CREATE TABLE MyTable(
    A VARCHAR2(100) NOT NULL,
    B VARCHAR2(100),
    C INT,
    CONSTRAINT uk_ab UNIQUE (A, B)
);
ALTER TABLE MyTable ADD D VARCHAR2(1000);
ALTER TABLE MyTable ADD CONSTRAINT PK_AB PRIMARY KEY(D);
ALTER TABLE MyTable DROP CONSTRAINT PK_AB;

-- EX4: On Numbers
CREATE TABLE numbert(
    A number(4,2));
INSERT INTO numbert VALUES (10.222);
select * from numbert;
-- 10.22 is inserted. digits after the decimal point are ROUNDED per precision.
INSERT INTO numbert VALUES (10000.22);
-- ORA-01438: value larger than specified precision allowed for this column
-- There is more than 2 digits before decimal point.
INSERT INTO numbert VALUES (0.2);
select * from numbert;
-- Success, 0.2 inserted
INSERT INTO numbert VALUES (0.222222);
select * from numbert;
-- Success, 0.22 inserted
INSERT INTO numbert VALUES (123);
select * from numbert;
-- ORA-01438: value larger than specified precision allowed for this column
-- There is more than 2 digits before decimal point.
INSERT INTO numbert VALUES (9);
select * from numbert;
-- Success, 9
INSERT INTO numbert VALUES (0);
select * from numbert:
-- Success, 0

-- EX5:
CREATE TABLE ThreeIntWithUK1 (
    A INT,
    B INT,
    C INT,
    CONSTRAINT uk_ThreeIntWithUK1 UNIQUE (A,B)
);
INSERT INTO ThreeIntWithUK1 VALUES (0, 1, 1);
-- SUCCESS
INSERT INTO ThreeIntWithUK1 VALUES (1, 0, 2);
-- SUCCESS
INSERT INTO ThreeIntWithUK1 VALUES (0, NULL, 3);
-- SUCCESS
INSERT INTO ThreeIntWithUK VALUES (0, NULL, 4);
-- fails due to unique constraint
INSERT INTO ThreeIntWithUK1 VALUES (NULL, 1, 5);
-- SUCCESS
INSERT INTO ThreeIntWithUK1 VALUES (NULL, 1, 6);
-- fails due to unique constraint
INSERT INTO ThreeIntWithUK1 VALUES (NULL, NULL, 7);
-- SUCCESS
INSERT INTO ThreeIntWithUK VALUES (NULL, NULL, 8);
-- succeeds. When ALL columns in the unique constraint are NULL, the unique constraint does not apply.

