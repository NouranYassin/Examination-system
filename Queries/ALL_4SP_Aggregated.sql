--- 4 Stored Procedure for Questions (Insert , Select  , Update , Delete)

Use [ItiExaminationSys]
GO

select*from Questions
Create Or Alter Procedure InsertQuestion  
@QuestionID Int , 
@QuestionText Nvarchar(MAX),
@QuestionType Nvarchar(100), 
@CorrectAnswer Nvarchar(100), 
@QuestionDegree Int , 
@choice1 Nvarchar(200) ,
@choice2 Nvarchar(200),
@choice3 Nvarchar(200)=NULL 
AS
Begin

    Insert Into Questions (QuestionID , QuestionText, QuestionType, CorrectAnswer, QuestionDegree , choice1,choice2,choice3)
    Values (@QuestionID , @QuestionText, @QuestionType, @CorrectAnswer, @QuestionDegree , @choice1,@choice2,@choice3)

End
Go; 

--- Calling -- EXEC InsertQuestion  @QuestionID = 2000 , @QuestionText = 'SQL For Structured Query Language',
						@QuestionType = 'T/F',  @CorrectAnswer = 'T',   @QuestionDegree = 10 ,
						@choice1 = 'T', @choice2='F'


---------------------------------------------------------------------

Create Or Alter Procedure SelectQuestion  @QuestionID Int
AS
Begin

		Select Distinct(Q.QuestionID), Q.QuestionText, Q.QuestionType, Q.CorrectAnswer, Q.QuestionDegree, C.CourseName
		From Questions AS Q
		Join Exams_Questions AS EQ 
		On Q.QuestionID = EQ.QuestionID
		Join Exams AS E 
		On EQ.ExamID = E.ExamID
		Join answers AS A
		On E.ExamID = A.ExamID
		Join Courses AS C 
		On A.CourseID = C.CourseID
		WHERE Q.QuestionID=@QuestionID

END
Go;
--- Calling -- EXEC SelectQuestion  @QuestionID = 1
--- Go; 

----------------------------------------------------------------------

Create Or Alter Procedure UpdateQuestion  
@QuestionID Int, 
@QuestionText Nvarchar(MAX),
@QuestionType Nvarchar(100), 
@CorrectAnswer Nvarchar(100), 
@QuestionDegree Int ,
@choice1 Nvarchar(200) ,
@choice2 Nvarchar(200),
@choice3 Nvarchar(200)
AS
Begin

    Update Questions
    Set QuestionText = @QuestionText, QuestionType = @QuestionType, CorrectAnswer = @CorrectAnswer, QuestionDegree = @QuestionDegree , 
	choice1 = @choice1,
	choice2 = @choice2,
	choice3 = @choice3
    Where QuestionID = @QuestionID

END
Go; 

--- Calling -- EXEC UpdateQuestion  @QuestionID = 2000, 
					@QuestionText = 'SQL is a programming language specifically designed for managing data in a relational database.', 
					@QuestionType = 'T/F',  @CorrectAnswer = 'F',  @QuestionDegree = 10 ,
					@choice1 = 'T' , @choice2='F',@choice3= NULL
--- Go; 

------------------------------------------------------------------------

Create Or Alter Procedure DeleteQuestion  @QuestionID Int
AS
Begin

	-- First delete related records in Exams_Questions
	Delete From Exams_Questions 
	Where QuestionID = @QuestionID
    Delete From Questions
	Where QuestionID = @QuestionID

END
Go; 

--- Calling -- EXEC DeleteQuestion  @QuestionID = 2000
--- Go;
--------------------------------------------------------------------------------------------
--- 4 Stored Procedure for Exams (Insert , Select  , Update , Delete)

Use [ItiExaminationSys]
GO

Create Or Alter Procedure InsertExam  
@ExamID INT,
@ExamName Nvarchar(100), 
@TotalDegree Int, 
@No_of_Questions Int, 
@ExamOnline Bit, 
@Fees Decimal(10, 2), 
@InstructorID Int
AS
Begin

    Insert Into exams (ExamID,ExamName, TotalDegree, No_of_Questions, ExamOnline, Fees, InstructorID)
    Values (@ExamID,@ExamName, @TotalDegree, @No_of_Questions, @ExamOnline, @Fees, @InstructorID)

END
Go;

--- Calling -- EXEC InsertExam  @ExamID=200, @ExamName = Network ,  @TotalDegree = 100,  @No_of_Questions = 10, @ExamOnline = 1,  @Fees = 500.00,  @InstructorID = 2
--- Go; 


--------------------------------------------------------------------------------------

Create Or Alter Procedure SelectExams
AS
Begin
    Select distinct(E.ExamID), E.ExamName, E.TotalDegree, E.No_of_Questions, E.ExamOnline, E.Fees, I.InstructorName, C.CourseName
    From Exams AS E
    Join Instructor AS I 
	On E.InstructorID = I.InstructorID
	Join Instructor_Courses AS IC
	On I.InstructorID = IC.InstructorID
    JOIN Courses AS C 
	On IC.CourseID = C.CourseID
END;
GO


--- Calling --EXEC SelectExams
--- Go; 


----------------------------------------------------------------------------------------

Create Or Alter Procedure UpdateExam   @ExamID Int, @ExamName Nvarchar(100), @TotalDegree Int, @No_of_Questions Int, @ExamOnline Bit, @Fees Decimal(10,2), @InstructorID Int
AS
Begin
    Update Exams
    Set ExamName = @ExamName,
        TotalDegree = @TotalDegree,
        No_of_Questions = @No_of_Questions,
        ExamOnline = @ExamOnline,
        Fees = @Fees,
        InstructorID = @InstructorID
    Where ExamID = @ExamID;
END
GO


--- Calling -- EXEC UpdateExam  @ExamID = 200,  @ExamName = Network ,  @TotalDegree = 80,  @No_of_Questions = 8,  @ExamOnline = 1,  @Fees = 400.00,  @InstructorID = 2
--- Go; 


--------------------------------------------------------------------------------------


CREATE PROCEDURE DeleteExam  @ExamID INT
AS
Begin
	
	-- First delete related records in Exams_Questions
	Delete From Exams_Questions
	Where ExamID = @ExamID 
    Delete From exams
	Where ExamID = @ExamID

END
Go; 

--- Calling -- EXEC DeleteExam  @ExamID = 200
--- Go; 

--------------------------------------------------------------------------------------------

----- SPs -----

----- Intake table -----

----- SP Select
create or alter procedure selectIntake
as
BEGIN
		select I.IntakeID, I.IntakeName, T.TrackID,t.TrackName
		from intakes I inner join TracksIntake TI
		ON I.IntakeID= TI.IntakeID
		Join tracks T
		on T.TrackID= TI.TrackID
End

---Test
--- EXEC selectIntake 
Go;

----- SP Insert
CREATE OR ALTER PROCEDURE InsertIntake
    @IntakeID INT,
    @IntakeName NVARCHAR(30)
AS
BEGIN
    -- Check if the IntakeID already exists in the intakes table
    IF NOT EXISTS (
        SELECT 1
        FROM intakes
        WHERE IntakeID = @IntakeID
    )
    BEGIN
        -- Insert the new record if it doesn't exist
        INSERT INTO intakes (IntakeID, IntakeName)
        VALUES (@IntakeID, @IntakeName);
    END
END;


--- Test
--- EXEC InsertIntake @IntakeID=500, @IntakeName='Intake50'
Go;

----- SP UPDATE
Create or alter procedure UpdateIntake
    @IntakeID int,
	@IntakeName Nvarchar(30)
as
begin
	update intakes
	set	IntakeName=@IntakeName
	where IntakeID=@IntakeID
End
--- Test
--- EXEC UpdateIntake @IntakeID=500, @IntakeName='Intake49'
Go;


----- SP Delete
Create or alter procedure DeleteIntake
    @IntakeID int
as
begin
    delete from intakes
	where IntakeID=@IntakeID
End

GO

--- Test
--- EXEC DeleteIntake @IntakeID=500
Go;
------------------------------------------------------------------------------------------

----- Feedback table -----

----- SP SELECT
CREATE OR ALTER  PROCEDURE SelectFeedback
AS
BEGIN
    SELECT FD.FeedbackID,s.std_Fname + s.std_Lname as [Full Name],s.StudentID,FD.Crs_Content,FD.Inst_Explanation,FD.Crs_Material_helpful
 FROM Feedback FD inner join student s
 on FD.St_ID= s.StudentID
END

go
--- Test
--- EXEC SelectFeedback 


----- SP INSERT
CREATE or alter PROCEDURE InsertFeedback
    @FD_Id INT,
    @Crs_Content INT,
    @Inst_Explanation INT
AS
BEGIN
    -- Check if the FeedbackID already exists in the Feedback table
    IF NOT EXISTS (
        SELECT 1
        FROM Feedback
        WHERE FeedbackID = @FD_Id
    )
	BEGIN
		INSERT INTO Feedback (FeedbackID, Crs_Content, Inst_Explanation)
	 VALUES(@FD_Id, @Crs_Content, @Inst_Explanation)
	END
END;
--- Test
--- EXEC InsertFeedback @FD_Id=200,@Crs_Content=10,@Inst_Explanation=10

----- SP UPDATE
Create or alter procedure UpdateFeedback
    @FD_Id INT,
	@Crs_Material_helpful INT,
	@Crs_Content INT,
	@Crs_well_organised INT,
	@Crs_Suitable_References INT,
	@Inst_ClassTime INT,
	@Inst_Responce_Qus INT,
	@Inst_GiveClearEx INT,
    @Inst_Explanation INT,
	@St_ID INT
as
begin
	update Feedback
	set	FeedbackID= @FD_Id,
	   Crs_Material_helpful=@Crs_Material_helpful,
	    Crs_Content=@Crs_Content,
		Crs_well_organised=@Crs_well_organised,
		Crs_Suitable_References=@Crs_Suitable_References,
		Inst_ClassTime=@Inst_ClassTime,
		Inst_Responce_Qus=@Inst_Responce_Qus,
		Inst_Explanation=@Inst_Explanation,
		Inst_GiveClearEx=@Inst_GiveClearEx,
		St_ID=@St_ID
		where FeedbackID=@FD_Id
End
--- Test
--- EXEC UpdateFeedback 200,5,5,5,5,5,5,5,5,1
Go;

----- SP DELETE
CREATE or alter PROCEDURE DeleteFeedback
    @FD_Id INT
AS
BEGIN
    DELETE FROM Feedback
 WHERE FeedbackID = @FD_Id 
END

--- Test
--- EXEC DeleteFeedback @FD_Id=200

------------------------------------------------------------------------------------------
----- Student table -----

----- SP SELECT
CREATE or alter PROCEDURE SelectStudent
AS
BEGIN
    SELECT *
	FROM Student
	order by StudentID 
END

--test
----- SP select
execute SelectStudent 

go
CREATE or alter PROCEDURE InsertStudent
	@StudentID int ,
	@std_Fname Nvarchar (50),
	@std_Lname Nvarchar (50),
	@std_Email Nvarchar (100)=Null,
	@std_Address Nvarchar (50)=NULL,
	@std_Phone int=NULL,
	@std_Education Nvarchar (50)=NULL,
	@std_Gender Nvarchar (50)=NULL,
	@std_Age int=NULL,
	@std_TrackID int=NULL 
AS
BEGIN
begin try
    INSERT INTO Student (StudentID,std_Fname,std_Lname,
						std_Email,std_Address,std_Phone,
						std_Education,std_Gender,std_Age,std_TrackID)
	VALUES(
	@StudentID ,
	@std_Fname,
	@std_Lname,
	@std_Email,
	@std_Address,
	@std_Phone,
	@std_Education,
	@std_Gender,
	@std_Age,
	@std_TrackID)
end try
begin catch
select CONCAT('You have error',@@ERROR)
end catch
END
--test
----- SP INSERT
execute InsertStudent 1002,'mohamed','Ali'

----- SP UPDATE
CREATE or alter PROCEDURE UpdateStudent
	@StudentID int ,
	@std_Fname Nvarchar (50),
	@std_Lname Nvarchar (50),
	@std_Email Nvarchar (100)=Null,
	@std_Address Nvarchar (50)=NULL,
	@std_Phone int=NULL,
	@std_Education Nvarchar (50)=NULL,
	@std_Gender Nvarchar (50)=NULL,
	@std_Age int=NULL,
	@std_TrackID int=NULL 
AS
BEGIN
update student
set std_Fname=@std_Fname,
	std_Lname=@std_Fname,
	std_Email=@std_Email,
	std_Address=@std_Address,
	std_Phone=@std_Phone,
	std_Education=@std_Education,
	std_Gender=@std_Gender,
	std_Age=@std_Age,
	std_TrackID=@std_TrackID
where StudentID=@StudentID
END
--test
----- SP Update
execute UpdateStudent 1002,'mohamed','Ahmed'

----- SP DELETE
GO
CREATE OR ALTER PROCEDURE DeleteStudent
    @Std_ID INT
AS
BEGIN
    DELETE FROM Student
	WHERE StudentID = @Std_ID
END
--test
----- SP Delete
execute DeleteStudent 1002
-------------------------------------------------------------------------------

----- Track table -----
----- SP SELECT
CREATE PROCEDURE SelectTrack
AS
BEGIN
    SELECT *
	FROM tracks
END
--test
----- SP Select
execute SelectTrack 


----- SP INSERT
CREATE or alter PROCEDURE InsertTrack @TrackID INT ,@TrackName varchar(30)
AS
Begin
BEGIN try
    insert into tracks (TrackID,TrackName)
	Values(@TrackID,@TrackName)
end TRY
begin catch
select CONCAT('You have error',@@ERROR)
end catch
END
--test
----- SP INSERT
execute InsertTrack  @TrackID=5 , @TrackName='PowerBI'

----- SP UPDATE
CREATE or alter PROCEDURE UpdateTrack @TrackID INT ,@TrackName varchar(30)
AS
BEGIN
Update tracks
set TrackName=@TrackName
where TrackID=@TrackID
end
--test
----- SP Update
execute UpdateTrack  @TrackID=5 , @TrackName='testing'

----- SP DELETE
CREATE or alter PROCEDURE DeleteTrack @TrackID INT 
AS
BEGIN
DELETE FROM tracks
WHERE TrackID=@TrackID
end
--test
----- SP DELETE
execute DeleteTrack  @TrackID=5 
--------------------------------------------------------------------------------------------------------
USE[ItiExaminationSys];
GO
---                                                                Instructor Table  S.P
-- 1 S.P to SELECT data from the instructor table
CREATE OR ALTER PROCEDURE SelectInstructor
AS
BEGIN
    SELECT * FROM dbo.instructor;
END;
GO
-- Test  S.P SelectInstructor
 EXEC SelectInstructor;
 GO

 ----------------------------

--  2 S.P to INSERT data into the instructor  Personal Info 
CREATE  OR ALTER PROCEDURE sp_InsertInstructor @InstructorID INT, @InstructorName NVARCHAR(30), @Inst_Email NVARCHAR(30),
    @Inst_Address NVARCHAR(30), @Inst_Phone INT,
    @Inst_Age INT,@Inst_Degree NVARCHAR(30),
    @Inst_Salary INT,@Inst_Experience INT, @Dept_ID INT
AS 
BEGIN
    -- Check if the Department ID exists
    IF NOT EXISTS (SELECT Dept_ID FROM [dbo].[department] WHERE [Dept_ID] = @Dept_ID)
    BEGIN 
        -- Return an error message
        RAISERROR('Please enter a correct department number.', 16, 1);
        RETURN;
    END
    
    -- Insert the data into the instructor table
    INSERT INTO dbo.instructor (
        InstructorID, InstructorName, Inst_Email,
        Inst_Address, Inst_Phone, Inst_Age, Inst_Degree, 
        Inst_Salary, Inst_Experience, Dep_Id)
    VALUES (
        @InstructorID, @InstructorName,
        @Inst_Email, @Inst_Address,
        @Inst_Phone, @Inst_Age,
        @Inst_Degree, @Inst_Salary,
        @Inst_Experience, @Dept_ID 
    );
END;
GO
-- TEST S.P sp_InsertInstructor
EXEC sp_InsertInstructor 10001,'Sara Ahmed','SaraAhmed@ITI.com', 'Giza', @Inst_Phone = 01124584663,
@Inst_Age =28,@Inst_Degree='PHD',@Inst_Salary=11000,@Inst_Experience=5,@Dept_ID=3;
Go 


--3  Stored Procedure to UPDATE data in the instructor Data
CREATE OR ALTER PROCEDURE UpdateInstructor
    @InstructorID INT,
    @InstructorName NVARCHAR(30),
    @Inst_Email NVARCHAR(30),
    @Inst_Address NVARCHAR(30),
    @Inst_Phone INT,
    @Inst_Age INT,
    @Inst_Degree NVARCHAR(30),
    @Inst_Salary INT,
    @Inst_Experience INT,
	@Dept_ID  INT
AS
BEGIN
IF NOT EXISTS (SELECT Dept_ID FROM [dbo].[department] WHERE [Dept_ID] = @Dept_ID)
    BEGIN 
        -- Return an error message
        RAISERROR('Please enter a correct department number.', 16, 1);
        RETURN;
    END
    UPDATE dbo.instructor
    SET InstructorName = @InstructorName, 
        Inst_Email = @Inst_Email, 
        Inst_Address = @Inst_Address,
        Inst_Phone = @Inst_Phone,
        Inst_Age = @Inst_Age,
        Inst_Degree = @Inst_Degree,
        Inst_Salary = @Inst_Salary,
        Inst_Experience = @Inst_Experience,
		Dep_Id= @Dept_ID 
    WHERE InstructorID = @InstructorID;
END;
GO
--  TEST S.P  UpdateInstructor 
EXEC UpdateInstructor 10001,'pola','pola@ITI.com', 'Minia', @Inst_Phone = 01166066666,
@Inst_Age =28,@Inst_Degree='PHD',@Inst_Salary=11000,@Inst_Experience=5, @Dept_ID =2;
Go 

-------------------------------------------------
  -- 4.S.P to DELETE Instructor Row from the department table
CREATE  OR ALTER PROCEDURE Sp_Delete_Instructor    @InstructorID INT
AS
BEGIN
    DELETE FROM [dbo].[instructor]
    WHERE InstructorID = @InstructorID;
END;
GO
--   Test Sp_Delete_Department
Exec Sp_Delete_Instructor 10001;
Go

--------------------------------------------------------------------------
---  Department Table S.P
-- 1 S.P to SELECT data from the department table
CREATE  OR ALTER PROCEDURE sp_SelectDepartment
AS
BEGIN
    SELECT * FROM dbo.department;
END;
GO
 -- Test sp_SelectDepartment
  EXec sp_SelectDepartment; 
 Go

-- 2 S.P to INSERT data into the department table
CREATE OR ALTER PROCEDURE Sp_InsertDepartment
	@Dept_ID INT ,
    @Dept_Name NVARCHAR(30),
    @Dept_ManagerID INT
AS
BEGIN
    INSERT INTO dbo.department (Dept_ID,Dept_Name, Dept_ManagerID)
    VALUES (@Dept_ID,@Dept_Name, @Dept_ManagerID);
END;
GO


-- Test Sp_InsertDepartment 
 EXEC Sp_InsertDepartment @Dept_ID= 405,  @Dept_Name ='ACE' ,@Dept_ManagerID= 20;
 GO


 -- 3  S.P to UPDATE Manager ID in the department table
CREATE  OR ALTER PROCEDURE Sp_Update_MGN_ID_Department  @MGN_ID INT,@Dept_Name NVARCHAR(30)

AS
BEGIN
    UPDATE dbo.department
    SET 
        Dept_ManagerID = @MGN_ID
    WHERE  Dept_Name= @Dept_Name;
END;
GO
-- Test Sp_Update_MGN_ID_Department
 EXEC Sp_Update_MGN_ID_Department  1 , 'ACE';
 GO

  --4 S.P to DELETE  Department from the department table

CREATE  OR ALTER PROCEDURE Sp_Delete_Department    @Dept_Name NVARCHAR(30)
AS
BEGIN
    DELETE FROM dbo.department
    WHERE Dept_Name = @Dept_Name;
END;
GO
--   Test Sp_Delete_Department
Exec Sp_Delete_Department  @Dept_Name= 'ACE';
GO
-------------------------------------------------








 
