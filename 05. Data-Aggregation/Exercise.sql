USE Gringotts

---===Pr. 1===---

SELECT COUNT(Id) AS [Count]
  FROM WizzardDeposits

---===Pr. 2===---

SELECT MAX(MagicWandSize) AS [LongestMagicWand] 
  FROM WizzardDeposits
  
---===Pr. 3===---

SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand] 
  FROM WizzardDeposits
 GROUP BY DepositGroup
   
---===Pr. 4===---
SELECT * FROM WizzardDeposits

SELECT DepositGroup FROM WizzardDeposits
 GROUP BY DepositGroup
HAVING AVG(MagicWandSize) =	(
								SELECT MIN(WizardAvgWandSizes.AvgMagicWandSize) FROM 	
								(
									SELECT DepositGroup, AVG(MagicWandSize) AS AvgMagicWandSize 
									  FROM WizzardDeposits
									 GROUP BY DepositGroup
								) AS WizardAvgWandSizes
							)

--Another Solution-- 

SELECT TOP 1 WITH TIES DepositGroup
  FROM WizzardDeposits
 GROUP BY DepositGroup
 ORDER BY AVG(MagicWandSize)

SELECT TOP 5 WITH TIES ColumnName
  FROM MyTable 
 ORDER BY ID

---===Pr. 5===---

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
  FROM WizzardDeposits
 GROUP BY DepositGroup

---===Pr. 6===---

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
  FROM WizzardDeposits
 GROUP BY DepositGroup, MagicWandCreator
HAVING MagicWandCreator = 'Ollivander family'

--Another Solution--

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family'
 GROUP BY DepositGroup

---===Pr. 7===---

SELECT * FROM WizzardDeposits

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
  FROM WizzardDeposits
 GROUP BY DepositGroup, MagicWandCreator
HAVING MagicWandCreator = 'Ollivander family' AND SUM(DepositAmount) < 150000
 ORDER BY TotalSum DESC
  
---===Pr. 8===---

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS [MinDepositCharge]
  FROM WizzardDeposits
 GROUP BY DepositGroup, MagicWandCreator
 ORDER BY MagicWandCreator, DepositGroup
   
---===Pr. 9===---

SELECT * FROM WizzardDeposits

SELECT 
	CASE 
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 31 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age > 60 THEN '[61+]'
	END AS [AgeGroup], 
	COUNT(Id) AS [WizzardCount]
FROM WizzardDeposits
GROUP BY 
	CASE 
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 31 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age > 60 THEN '[61+]'
	END

--Another Solution--

SELECT [Groups Of Age].AgeGroup, COUNT([Groups Of Age].AgeGroup) AS [WizzardCount] FROM 
--SELECT [Groups Of Age].AgeGroup, COUNT(*) AS [WizzardCount] FROM 
(
	SELECT 
	CASE 
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 31 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age > 60 THEN '[61+]'
	END AS [AgeGroup]
	FROM WizzardDeposits
) AS [Groups Of Age] 
GROUP BY [Groups Of Age].AgeGroup

---===Pr. 10===---

SELECT LEFT(FirstName, 1) AS [FirstLetter] FROM WizzardDeposits
 WHERE DepositGroup = 'Troll Chest'
 GROUP BY LEFT(FirstName, 1)
 ORDER BY FirstLetter
  
---===Pr. 11===---

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS [AverageInterest] 
  FROM WizzardDeposits
 WHERE DepositStartDate > '1985-01-01'
 GROUP BY DepositGroup, IsDepositExpired
 ORDER BY DepositGroup DESC, IsDepositExpired
   
---===Pr. 12===---

DECLARE @currentDeposit DECIMAL(8, 2)
DECLARE @previousDeposit DECIMAL(8, 2)
DECLARE @summedDifference DECIMAL(8, 2) = 0

DECLARE wizzardCursor CURSOR FOR SELECT DepositAmount FROM WizzardDeposits

OPEN wizzardCursor

FETCH NEXT FROM wizzardCursor INTO @currentDeposit

WHILE (@@FETCH_STATUS = 0)
BEGIN
	IF (@previousDeposit IS NOT NULL)
	BEGIN
		SET @summedDifference += @previousDeposit - @currentDeposit
	END

	SET @previousDeposit = @currentDeposit

	FETCH NEXT FROM wizzardCursor INTO @currentDeposit
END

CLOSE wizzardCursor
DEALLOCATE wizzardCursor

SELECT @summedDifference AS [SumDifference]

--Another Solution--

SELECT SUM(CurrentDiffTable.CurrentDiff) AS [SumDifference] FROM
(
	SELECT FirstName, 
		   DepositAmount, 
		   LEAD(FirstName) OVER (ORDER BY Id) AS [Next Name], 
		   LEAD(DepositAmount) OVER (ORDER BY Id) AS [Next Deposit], 
		   DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS [CurrentDiff]
	  FROM WizzardDeposits
) AS CurrentDiffTable 

--Shortened Version of Second Solution--

SELECT SUM(DepositAmount - NextDeposit) AS [SumDifference]
  FROM (SELECT DepositAmount , 
	  LEAD (DepositAmount) OVER (ORDER BY Id) AS [NextDeposit]
	  FROM WizzardDeposits) AS WizzartDeposits

---===Pr. 13===---

USE SoftUni

SELECT * FROM Employees

SELECT DepartmentId, SUM(Salary) AS [TotalSalary]
  FROM Employees
 GROUP BY DepartmentID
  
---===Pr. 14===---

SELECT MIN(Salary) AS [MinSalary]
 FROM Employees 
 WHERE DepartmentID = 4 AND HireDate > '2000-01-01'

SELECT DepartmentId, MIN(Salary) AS [MinimumSalary]
  FROM Employees
 WHERE DepartmentID IN (2, 5, 7) AND HireDate > '2000-01-01'
 GROUP BY DepartmentID
   
---===Pr. 15===---

SELECT * INTO NewEmployeesTable
  FROM Employees
 WHERE Salary > 30000

SELECT * FROM NewEmployeesTable

DELETE FROM NewEmployeesTable
 WHERE ManagerID = 42

UPDATE NewEmployeesTable
   SET Salary += 5000
 WHERE DepartmentId = 1

SELECT DepartmentId, AVG(Salary) AS [AverageSalary]
  FROM NewEmployeesTable
 GROUP BY DepartmentID
   
---===Pr. 16===---

SELECT DepartmentId,  MAX(Salary) AS [MaxSalary]
  FROM Employees
 GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000
  
---===Pr. 17===---

SELECT COUNT(Salary) AS [Count]
  FROM Employees
 WHERE MANAGERID IS NULL 
  
---===Pr. 18===---

SELECT * FROM Employees

SELECT SalariesTable.DepartmentID, SalariesTable.Salary AS [ThirdHighestSalary] FROM 
(
	SELECT DepartmentId, 
		   MAX(Salary) AS [Salary], 
		   DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) AS [Ranking]
	  FROM Employees
	 GROUP BY DepartmentID, Salary
) AS SalariesTable
WHERE SalariesTable.Ranking = 3

  
---===Pr. 19===---

SELECT * FROM Employees

SELECT TOP 10 FirstName, LastName, DepartmentId
  FROM Employees AS e
 WHERE Salary > (
					SELECT AVG(Salary)
					  FROM Employees AS empl
					 WHERE e.DepartmentID = empl.DepartmentID
					 GROUP BY DepartmentID
				)

--Another Solution--
SELECT TOP(10) e.FirstName,
			   e.LastName,
			   e.DepartmentID
FROM Employees AS e
JOIN (SELECT DepartmentID,
	 AVG(Salary) AS DepartmentAverage
	 FROM Employees
	 GROUP BY DepartmentID
) AS compare
ON e.DepartmentId = compare.DepartmentID
WHERE e.Salary > compare.DepartmentAverage
ORDER BY DepartmentID