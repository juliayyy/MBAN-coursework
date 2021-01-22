-- Cross Join
-- Inner Join
-- Outer join

-- Cross join

SELECT
Professor.Professor, Professor.Dept AS Prof_DEPT, D.Dept,
D.Address
FROM Professor
CROSS JOIN Department AS D;

SELECT
Professor.Professor, Professor.Dept AS Prof_DEPT, D.Dept,
D.Address
FROM Professor, Department AS D;

SELECT
a.AID, b.BID, c.CID
FROM A, B, C;

SELECT
a.AID, b.BID, c.CID
FROM A
CROSS JOIN B
CROSS JOIN C;


SELECT
    c.CustomerID,
    p.ProductID,
    Predict_Purchase(c.age, c.gender, p.category)
        AS prediction_score
FROM Customers c, Products p
WHERE c.City = 'Vancouver'
  AND c.age BETWEEN p.Min_TargetAge AND p.Max_TargetAge

-- Inner join
-- Definition:
-- First, compute L x R (i.e., cross join)
-- Second, remove rows where the criteria is not met.
-- Third, output the remaining rows.

SELECT
P.Professor, P.Dept PDEPT, D.Dept, D.Address
FROM Professor P
JOIN Department D
  ON P.Dept = D.Dept;

SELECT
P.Professor, P.Dept PDEPT, D.Dept, D.Address
FROM Professor P
INNER JOIN Department D
  ON P.Dept = D.Dept;

SELECT
P.Professor, P.Dept PDEPT, D.Dept, D.Address
FROM Professor P, Department D
WHERE P.Dept = D.Dept;
Comment: You can use a cross join with WHERE conditions to achieve the equivalent of an inner join


SELECT
    A.x, B.y, C.z
FROM A
JOIN B ON A.key1=B.key1
JOIN C ON B.key2=C.key2;

-- Outer joins
-- Full Outer Join
SELECT
    L.Prof,
    L.Dept LDept,
    R.Dept,
    R.Address
FROM L
FULL OUTER JOIN R ON L.Dept = R.Dept;

-- Left Outer Join
SELECT
    L.Prof,
    L.Dept LDept,
    R.Dept,
    R.Address
FROM L
LEFT OUTER JOIN R ON L.Dept = R.Dept;

-- Right Outer Join
SELECT
    L.Prof,
    L.Dept LDept,
    R.Dept,
    R.Address
FROM L
RIGHT OUTER JOIN R ON L.Dept = R.Dept;

-- Example applications: LEFT JOIN
-- Find all customers who have not made a purchase.
-- Find all products that have not been purchased by anyone.
SELECT
CustomerID,
CustomerName FROM Customers C
 LEFT JOIN Orders O
 ON C.CustomerID = O.CustomerID
 WHERE O.OrderID IS NULL;

-- lab activity 1
SELECT
    M.MID,
    M.NAME,
    C.AID AS CAID,
    C.MID AS CMID,
    C.MROLE
FROM Musicians M
JOIN Creations C
ON ( M.NAME like 'L%' AND M.MID = C.MID );

SELECT
    M.MID,
    M.NAME,
    C.AID AS CAID,
    C.MID AS CMID,
    C.MROLE
FROM Musicians M
JOIN Creations C
ON ( M.MID = C.MID ) WHERE M.NAME like 'L%';

-- lab activity 2
SELECT
    M.MID,
    M.NAME,
    C.AID AS CAID,
    C.MID AS CMID,
    C.MROLE
FROM Musicians M
LEFT JOIN Creations C
ON ( M.NAME like 'L%' AND M.MID = C.MID );

SELECT
M.MID, M.NAME,
C.AID AS CAID, C.MID AS CMID, C.MROLE
FROM Musicians M
LEFT JOIN Creations C
ON ( M.MID = C.MID )
WHERE M.NAME like 'L%';

-- Lab Activity Goal
-- • First
--• Think about how does INNER JOIN work.
--• Try to predict whether the two SQL queries would return the same or different results. Explain why.
--• Run the queries to compare with your prediction.
--• Second
--• Do the same for LEFT JOIN.