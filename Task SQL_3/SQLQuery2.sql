-- PHASE 5: DATABASE RELATIONS

-- Task 5.1: Create AccessCards Table

CREATE TABLE AccessCards (
    CardID INT PRIMARY KEY,
    CardNumber VARCHAR(50) NOT NULL UNIQUE,
    EmployeeID INT UNIQUE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- Task 5.2: Create Projects Table

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL
);


-- Task 5.2: Create EmployeeProjects Table

CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    AssignedDate DATE,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);


-- Task 5.3: Insert Access Cards

INSERT INTO AccessCards VALUES
(101, 'CARD-101', 1),
(102, 'CARD-102', 2),
(103, 'CARD-103', 3);


-- Task 5.3: Insert Projects

INSERT INTO Projects VALUES
(1, 'AI & Security Training'),
(2, 'Cloud Migration');


-- Task 5.3: Insert Employee Projects

INSERT INTO EmployeeProjects VALUES
(1, 1, GETDATE()),
(1, 2, GETDATE()),
(2, 1, GETDATE()),
(3, 2, GETDATE());


-- PHASE 6: DATABASE JOINS

-- Task 6.1: INNER JOIN

SELECT FullName, Salary, DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;


-- Task 6.2: LEFT JOIN

SELECT DepartmentName, FullName
FROM Departments
LEFT JOIN Employees
ON Departments.DepartmentID = Employees.DepartmentID;


-- Task 6.3: INNER JOIN

SELECT FullName, CardNumber
FROM Employees
INNER JOIN AccessCards
ON Employees.EmployeeID = AccessCards.EmployeeID;


-- Task 6.4: Multi-Table JOIN

SELECT FullName, ProjectName, AssignedDate
FROM Employees
INNER JOIN EmployeeProjects
ON Employees.EmployeeID = EmployeeProjects.EmployeeID
INNER JOIN Projects
ON EmployeeProjects.ProjectID = Projects.ProjectID;


-- PHASE 7: GROUP BY, HAVING, WHERE

-- Task 7.1: GROUP BY

SELECT DepartmentID,
SUM(Salary) AS TotalSalary,
COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;


-- Task 7.2: HAVING

SELECT DepartmentID,
AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 1000.00;


-- Task 7.3: Subquery

SELECT *
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- Task 7.4: VIEW
CREATE VIEW vw_EmployeeDetails
AS
SELECT Employees.EmployeeID, FullName, Email, DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;

SELECT * FROM vw_EmployeeDetails;

-- Task 7.5: Stored Procedure

CREATE OR ALTER PROCEDURE sp_GetEmployeesByDepartment
@DeptID INT
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE DepartmentID = @DeptID;
END;

EXEC sp_GetEmployeesByDepartment 1;

-- Task 7.6: Create Trigger

CREATE OR ALTER TRIGGER trg_EmployeeDelete
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit (EmployeeID, [Action], ActionDate)
    SELECT EmployeeID, 'DELETE', GETDATE()
    FROM deleted;
END;

SELECT * FROM EmployeeAudit;