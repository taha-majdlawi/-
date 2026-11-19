/* =====================================================
   University Enrollment System - SQL Server (SSMS)
   ملاحظة: استبدل StudentID في اسم قاعدة البيانات برقمك الجامعي
   مثال: UniversityDB_20231234  (استخدم Find & Replace على "StudentID" في اسم القاعدة فقط)
   ===================================================== */

-- ============ المطلوب الثاني: DDL ============
CREATE DATABASE UniversityDB_StudentID;
GO
USE UniversityDB_StudentID;
GO

CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Students (
    StudentID    INT PRIMARY KEY,
    StudentName  VARCHAR(100) NOT NULL,
    Email        VARCHAR(100) UNIQUE,
    DepartmentID INT,
    CONSTRAINT FK_Students_Departments
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    CourseID     INT PRIMARY KEY,
    CourseName   VARCHAR(100) NOT NULL,
    Hours        INT CHECK (Hours BETWEEN 1 AND 6),
    DepartmentID INT,
    CONSTRAINT FK_Courses_Departments
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    StudentID      INT,
    CourseID       INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    Grade          INT CHECK (Grade BETWEEN 0 AND 100),
    CONSTRAINT PK_Enrollments PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_Enrollments_Students
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Enrollments_Courses
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- ============ المطلوب الثالث: DML ============
INSERT INTO Departments VALUES (1, 'Computer Science');
INSERT INTO Departments VALUES (2, 'Mathematics');

INSERT INTO Students (StudentID, StudentName, Email, DepartmentID) VALUES
(101, 'Ahmad Ali',   'ahmad@uni.edu', 1),
(102, 'Sara Omar',   'sara@uni.edu',  1),
(103, 'Khaled Nasr', 'khaled@uni.edu',2),
(104, 'Lina Yousef', 'lina@uni.edu',  2);

INSERT INTO Courses (CourseID, CourseName, Hours, DepartmentID) VALUES
(201, 'Database Systems',  3, 1),
(202, 'Programming 1',     4, 1),
(203, 'Calculus',          2, 2);

INSERT INTO Enrollments (StudentID, CourseID, Grade) VALUES
(101, 201, 85),
(101, 202, 90),
(102, 201, 60),
(103, 203, 55),
(104, 203, 75),
(104, 202, 95);

-- UPDATE
UPDATE Students
SET Email = 'ahmad.new@uni.edu'
WHERE StudentID = 101;

-- DELETE
DELETE FROM Enrollments
WHERE StudentID = 103 AND CourseID = 203;
GO

-- ============ المطلوب الرابع: الاستعلامات ============
-- 1) أسماء الطلاب مع أقسامهم
SELECT s.StudentName, d.DepartmentName
FROM Students s
JOIN Departments d ON s.DepartmentID = d.DepartmentID;

-- 2) الطالب والمساقات المسجل فيها
SELECT s.StudentName, c.CourseName
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses  c ON e.CourseID  = c.CourseID;

-- 3) المساقات ذات 3 ساعات أو أكثر
SELECT * FROM Courses WHERE Hours >= 3;

-- 4) الطلاب الذين درجتهم >= 60 في أي مساق
SELECT DISTINCT s.StudentID, s.StudentName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.Grade >= 60;

-- 5) اختبار التكامل المرجعي: StudentID غير موجود
-- سيفشل الأمر بخطأ FOREIGN KEY constraint conflict لأن الطالب 999 غير موجود في Students،
-- والـ Foreign Key يمنع إدخال سجل تسجيل يشير إلى طالب غير موجود (حفاظاً على تكامل البيانات).
INSERT INTO Enrollments (StudentID, CourseID, Grade) VALUES (999, 201, 70);
GO
