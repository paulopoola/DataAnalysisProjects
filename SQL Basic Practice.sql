
-- SQL QUERIES CONTAINING BASIC FUNCS  --

-- CREATING TABLES THAT CONTAINS EMPLOYEES DEMOGRAPHICS

Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)


Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
)


Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

-- INSERTING DATA/VALUES TO THE TABLE 

Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')


Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)


Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male')


INSERT INTO ..EmployeeDemographics VALUES
(1007, 'Karen', 'White', 28, 'FEMALE')


Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')


-- TO VIEW THE TABLE

--SELECT *
--FROM [DATABASE]..TableName

SELECT *
FROM ..EmployeeDemographics
ORDER BY 1

SELECT *
FROM ..EmployeeSalary


--UPDATE VALUES IN A TABLE 

UPDATE ..EmployeeDemographics
SET Age = 37
WHERE EmployeeID = 1005


--DELETING VALUES FROM TABLE (NOT STANDARD PRACTISE*)

DELETE
FROM ..EmployeeDemographics
WHERE EmployeeID = 1005


--USING CASE STATEMENTS/WHEN/THEN AND JOINING TABLES--

SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = 'Salesmen' THEN Salary + (Salary* 0.15)
	WHEN JobTitle = 'Teacher' THEN Salary + (Salary* 0.10)
	ELSE Salary + (Salary* 0.05)
END AS SalaryRaise
FROM ..EmployeeDemographics
JOIN ..EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--CREATING A NEW COLUMN FROM EXISTING TABLE DATA

SELECT FirstName + ' ' + LastName AS FullName, Age
FROM ..EmployeeDemographics
ORDER BY 1


SELECT Avg(Age) AS AvgAge
FROM ..EmployeeDemographics


--JOINING TABLES, INNERJOIN, FULL OUTER JOIN, LEFT OUTERJOIN, UNION

SELECT Demo.EmployeeID,Demo.FirstName + ' ' + Demo.LastName AS FullName, Sal.JobTitle, Salary
FROM ..EmployeeDemographics AS Demo
JOIN ..EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID

SELECT *
FROM ..EmployeeDemographics AS Demo


SELECT *
FROM ..WarehouseEmployeeDemographics AS WDemo
full outer JOIN ..EmployeeSalary AS Sal
	ON WDemo.EmployeeID = Sal.EmployeeID



/*-- PARTITION BY (REPEATS GROUP BY IN EACH COLUMN)*/

SELECT FirstName, LastName, Gender, Salary, COUNT(Gender) OVER (PARTITION BY GENDER) AS TotalGender
FROM ..EmployeeDemographics AS Demo
JOIN ..EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID

/* CTE , COMMON TABLE EXPRESSION (its not stored anywhere it creates it
everytime it runs Select statement has to be directly under the CTE call
*/

WITH CTE_Employee as
(SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender,
AVG(Salary) OVER (PARTITION BY Gender) AS AvgSalary
FROM ..EmployeeDemographics AS Demo
JOIN ..EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID
WHERE Salary > '40000')
SELECT *
FROM CTE_Employee


/* TEMP TABLES UNLIKE A CTE ITS STORED 
diffrence btw creating a table is just the # sign before the tname
it saves memory and runtime 
*/

CREATE TABLE #temp_Employee01 (
EmployeeID int,
JobTitle varchar(20),
Salary int
)

SELECT *
FROM #temp_Employee01

INSERT INTO #temp_Employee01 VALUES (
'1001', 'HR', 45000
)

/* INSERTING TABLE IN TABLE */

INSERT INTO #temp_Employee01
SELECT *
FROM ..EmployeeSalary

/*"DROP TABLE IF EXISTS #TABLENAME" HELPS YOU OVERWRITE A TABLE WHEN RUNNING 
MULTIPLE TIMES */

DROP TABLE IF EXISTS #Temp_Employee1
CREATE TABLE #Temp_Employee1 (
JobTitle varchar(20),
EmployeesPerJob int,
AvgAge int,
AvgSalary int,
)

--Select *
--From ..#Temp_Employee1

INSERT INTO #Temp_Employee1
SELECT JobTitle, Count(JobTitle), Avg(Age), Avg(Salary)
FROM ..EmployeeDemographics Demo
JOIN ..EmployeeSalary Sal
	ON Demo.EmployeeID = Sal.EmployeeID
Group by JobTitle

SELECT *
FROM #Temp_Employee1


/* STRING  String Functions - 
TRIM gets rid of blank spaces on LEFT AND RIGHT  SIDE
LTRIM, RTRIM, Replace,
 Substring, Upper, Lower
*/

CREATE TABLE EmployeeErrors (
EmployeeID varchar(20)
,FirstName varchar(20)
,LastName varchar(20)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')


--USING TRIM

SELECT *
From EmployeeErrors

SELECT TRIM(EmployeeID) AS ID_TRIM, *
From EmployeeErrors

SELECT LTRIM(EmployeeID) AS ID_LTRIM, *
From EmployeeErrors

SELECT RTRIM(EmployeeID) AS ID_RTRIM, *
From EmployeeErrors

-- USING REPLACE

SELECT *
From EmployeeErrors

----USING REPLACE(COLUMN WITH VALUE,'VALUE TO BE REPLACED', 'WITH WHAT?') AS XYZ

SELECT LastName, REPLACE(LastName, '- Fired', '') as FixedLName
From EmployeeErrors


--SUBSTRING LETS YOU SPECIFY WHICH CHARCTER OR HOW MANY LETTERS TO REMOVE OR SUBSTITUTE
 
SELECT SUBSTRING(Firstname, 1,3) Short_Fname, FirstName
From EmployeeErrors


--USING UPPER LOWER

Select FirstName, LOWER(FirstName) as lower_fname
from EmployeeErrors

Select Firstname, UPPER(FirstName) upper_fname
from EmployeeErrors


/* STORED PROCEDUREs */

--CREATE PROCEDURE TEST
--AS
--SELECT *
--FROM EmployeeDemographics

--EXEC TEST


CREATE PROCEDURE Temp_Employee
AS
--DROP TABLE IF EXISTS #temp_employee3
CREATE TABLE #temp_employee3 (
JobTitle varchar(28),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)

INSERT INTO #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), Avg(Salary)
FROM EmployeeDemographics Demo
JOIN EmployeeSalary Sal
	on Demo.EmployeeID = Sal.EmployeeID
GROUP BY JobTitle


Select *
from #temp_employee3

EXEC Temp_Employee @JobTitle ='Salesman'


