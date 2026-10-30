
-- Task 1.2: Create TempInstructors Table

CREATE TABLE TempInstructors(
    TempID INT,
    TempName VARCHAR(50),
    JoinedDate DATE
);
-- STAGE 2: SCHEMA DEFINITION & CONSTRAINTS (DDL)
-- Task 2.1: Create Departments Table
CREATE TABLE Departments(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
-- Task 2.2: Create Students Table (One-to-Many)
CREATE TABLE Students(
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    GPA DECIMAL(3,2),
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);
-- Task 2.3: Create StudentProfiles Table (One-to-One)

CREATE TABLE StudentProfiles(
    ProfileID INT PRIMARY KEY,
    StudentID INT UNIQUE,
    Addresss VARCHAR(200),
    EmergencyPhone VARCHAR(20),

    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID)
);
-- Task 2.4: Create Courses Table (One-to-Many)

CREATE TABLE Courses(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT,
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);
-- Task 2.5: Create StudentCourses Table (Many-to-Many)
CREATE TABLE StudentCourses(
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),

    PRIMARY KEY (StudentID, CourseID),

    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID),

    FOREIGN KEY (CourseID)
    REFERENCES Courses(CourseID)
);

-- Task 2.6: ALTER TABLE - Add Age Column
ALTER TABLE Students
ADD Age INT;

-- Task 2.6: DROP TABLE - Remove TempInstructors
DROP TABLE TempInstructors;

-- STAGE 3: DATA INSERTION & UPDATES (DML)
-- Task 3.1: Insert Departments
INSERT INTO Departments
(DepartmentID, DepartmentName)
VALUES
(1, 'Computer Science'),
(2, 'Software Engineering'),
(3, 'Business Administration');
-- Task 3.2: Insert Students
INSERT INTO Students
(StudentID, FullName, Email, GPA, DepartmentID, Age)
VALUES
(101, 'Ali Smadi', 'ali@coursehub.com', 3.80, 1, 22),
(102, 'Omar Ahmad', 'omar@coursehub.com', 2.90, 1, 21),
(103, 'Laila Hassan', 'laila@coursehub.com', 3.50, 2, 23),
(104, 'Tariq Zaid', 'tariq@coursehub.com', 2.10, 3, 20);
-- Task 3.3: Insert Student Profiles (One-to-One)
INSERT INTO StudentProfiles
(ProfileID, StudentID, Address, EmergencyPhone)
VALUES
(1, 101, 'Amman, Jordan', '0791111111'),
(2, 102, 'Irbid, Jordan', '0792222222'),
(3, 103, 'Zarqa, Jordan', '0793333333');
-- Task 3.4: Insert Courses
INSERT INTO Courses
(CourseID, CourseName, Credits, DepartmentID)
VALUES
(201, 'Database Systems', 3, 1),
(202, 'Web Development', 3, 1),
(203, 'Software Architecture', 3, 2);
-- Task 3.5: Enroll Students in Courses (Many-to-Many)
INSERT INTO StudentCourses
(StudentID, CourseID)
VALUES
(101, 201),
(101, 202),
(102, 201),
(103, 203);

-- Task 3.6: UPDATE - Update Tariq's GPA
UPDATE Students
SET GPA = 2.50
WHERE StudentID = 104;
-- Task 3.6: DELETE - Delete Tariq
DELETE FROM Students
WHERE StudentID = 104;

-- STAGE 3: DATA VERIFICATION
SELECT * FROM Departments;
SELECT * FROM Students;
SELECT * FROM StudentProfiles;
SELECT * FROM Courses;
SELECT * FROM StudentCourses;

-- STAGE 4: MULTI-TABLE JOINS & RELATIONS
-- Task 4.1: INNER JOIN (Students + Departments)

SELECT FullName, GPA, DepartmentName
FROM Students
INNER JOIN Departments
ON Students.DepartmentID = Departments.DepartmentID;

-- Task 4.2: LEFT JOIN (Departments + Students)
SELECT DepartmentName, FullName
FROM Departments
LEFT JOIN Students
ON Departments.DepartmentID = Students.DepartmentID;

-- Task 4.3: INNER JOIN (Students + StudentProfiles)

SELECT FullName, Addresss, EmergencyPhone
FROM Students
INNER JOIN StudentProfiles
ON Students.StudentID = StudentProfiles.StudentID;



-- Task 4.4: Many-to-Many JOIN (3 Tables)

SELECT FullName, CourseName, EnrollmentDate
FROM Students
INNER JOIN StudentCourses
ON Students.StudentID = StudentCourses.StudentID
INNER JOIN Courses
ON StudentCourses.CourseID = Courses.CourseID;

-- STAGE 5: AGGREGATIONS, GROUPING & FILTERING

-- Task 5.1: Global Aggregations

SELECT
    COUNT(*) AS TotalStudents,
    AVG(GPA) AS AverageGPA,
    MAX(GPA) AS HighestGPA,
    MIN(GPA) AS LowestGPA
FROM Students;
-- Task 5.2: GROUP BY Department

SELECT
    DepartmentID,
    COUNT(*) AS TotalStudents,
    AVG(GPA) AS AverageGPA
FROM Students
GROUP BY DepartmentID;
-- Task 5.3: HAVING Clause
SELECT
    DepartmentID,
    AVG(GPA) AS AverageGPA
FROM Students
GROUP BY DepartmentID
HAVING AVG(GPA) > 3.00;

-- Task 5.4: WHERE + GROUP BY + HAVING
SELECT
    DepartmentID,
    COUNT(*) AS TotalStudents
FROM Students
WHERE GPA >= 2.50
GROUP BY DepartmentID
HAVING COUNT(*) > 1;

-- STAGE 6: INDEXING
-- Task 6.1: Clustered Index

EXEC sp_helpindex 'Students';

-- Task 6.2: Non-Clustered Index
CREATE NONCLUSTERED INDEX IX_Students_Email
ON Students(Email);

-- STAGE 7: ADVANCED SQL OBJECTS

-- Task 7.1: Subqueries
SELECT * FROM Students
WHERE GPA > (SELECT AVG(GPA) FROM Students);
-- Task 7.2: Views

CREATE VIEW vw_StudentAcademicDetails
AS
SELECT StudentID, FullName, GPA, DepartmentName
FROM Students
INNER JOIN Departments
ON Students.DepartmentID = Departments.DepartmentID;

-- Task 7.2: Display View Data

SELECT * FROM vw_StudentAcademicDetails;

-- Task 7.3: Stored Procedures
CREATE PROCEDURE sp_GetStudentsByDepartment
    @DeptID INT
AS
BEGIN
    SELECT * FROM Students
    WHERE DepartmentID = @DeptID;
END;
-- Task 7.3: Execute Stored Procedure
EXEC sp_GetStudentsByDepartment @DeptID = 1;

