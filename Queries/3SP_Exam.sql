---- Stored Procedure For Exam Creation

Use [ItiExaminationSys]
GO; 

Create or Alter Procedure ExamCreation  @CourseName Nvarchar(100),  @ExamID Int,  @No_of_TandF Int,  @No_of_MCQ Int 
As 
Begin

    -- Create Temp Table
    Create Table #ExamTemp (QuestionID Int,  QuestionText Nvarchar(Max))

    -- Insert True/False Questions into Temp Table
    Insert Into #ExamTemp (QuestionID, QuestionText)
    Select Top (@No_of_TandF) QuestionID, QuestionText 
    From Questions
    Where QuestionType = 'T/F' 
    Order By NEWID()

    -- Insert Multiple Choice Questions into Temp Table
    Insert Into #ExamTemp (QuestionID, QuestionText)
    Select Top (@No_of_MCQ) QuestionID, QuestionText 
    From Questions
    Where QuestionType = 'MCQ' 
    Order By NEWID()

    -- Insert into Exams_Questions table
    Insert Into Exams_Questions (QuestionID, ExamID)
    Select  QuestionID, @ExamID
    From #ExamTemp 

    -- Drop the Temporary Table
    Drop Table #ExamTemp

END
GO; 

---- Calling Exam Creation SP
----EXEC ExamCreation  @CourseName = '', @ExamID =48 , @No_of_TandF = 3, @No_of_MCQ = 7;

select*from Exams_Questions
select*from exams
-----------------------------------------------------------------------------------------------------------------------
--SHOW exam
create or alter PROCEDURE showExam
@ExamID int
As
Begin
select Q.QuestionText , Q.choice1, Q.choice2, Q.choice3
from Exams_Questions EQ , Questions Q
where EQ.QuestionID =Q.QuestionID
and EQ.ExamID = @ExamID
END;

--EXEC showExam @ExamID=48
-------------------------------------------------------------------------------------------------
CREATE OR ALTER  PROCEDURE InsertStudentAnswer
    @ExamID INT,
	@CourseID INT,
	@StudentID INT,
	@QuestionID INT, 
	@StudentAnswerID INT,
	@StudentAnswer NVARCHAR(5)
AS
BEGIN
    -- Insert the answer into the Answers table
    INSERT INTO Answers (StudentAnswerID,StudentAnswer, ExamID, StudentID, CourseID,QuestionID )
    VALUES 
    (
        @StudentAnswerID,@StudentAnswer, @ExamID, @StudentID, 
        @CourseID, @QuestionID
        
    )
END;
GO
select *from Answers

--Test InsertStudentAnswer
Exec InsertStudentAnswer @ExamID =48, @CourseID =1,@StudentID=2,@QuestionID= 1, @StudentAnswerID = 879400, @StudentAnswer ='T';
GO
--  Display student answers
SELECT * From Answers
Where StudentAnswerID = 879400;
GO
-- Delete 
Delete From Answers
Where StudentAnswerID = 879400;
GO
--------------------------------------------------------------------------------------------------
-----Stored Procedure For Exam Correction

Create or Alter Procedure ExamCorrection 
@StudentID Int,
@ExamID Int , 
@CourseID int
AS
Begin

Declare @Total_Score int

Select @Total_Score = Sum(
            Case 
                When A.StudentAnswer = Q.CorrectAnswer Then Q.QuestionDegree 
                Else 0 
            End
        )
From [dbo].[Questions] AS q 
Join [dbo].[answers] AS a 
On q.QuestionID = a.QuestionID 
Where a.ExamID = @ExamID AND a.StudentID = @StudentID 

Update Student_Courses 
Set StudentDegree = @Total_Score
Where StudentID = @StudentID and CourseID = @CourseID


End;


---- Calling Exam Correction SP
----Exec ExamCorrection 2 , 48 , 1
