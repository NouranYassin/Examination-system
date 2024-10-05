------- 6 Stored Procedures for Reports
Use [ItiExaminationSys]
GO

--1.PROC that takes Track_Id and return Student_INFO
Create or alter proc Stu_Track @Track_ID int 
as
Begin 
select s.StudentID,(s.std_Fname+ ' ' +s.std_Lname) as [FullName],s.std_Gender,s.std_Age,s.std_Address,t.TrackID, t.TrackName
from student s inner join  tracks t
ON s.std_TrackID = t.TrackID
where std_TrackID=@Track_ID
End;
GO

-- Test  EXECUTE Stu_Track @Track_ID=1
Go



--2.PROC that takes student_Id and return Student_Id , course Name and Student Degrre 
Create or alter proc Stu_info @Stu_ID int 
as
Begin 
select Student_Courses.StudentID,(student.std_Fname+ ' ' +student.std_Lname) as [FullName],courses.CourseName,Student_Courses.StudentDegree
from courses,Student_Courses, student 
where courses.CourseID=Student_Courses.CourseID
and student.StudentID = Student_Courses.StudentID
and Student_Courses.StudentID=@Stu_ID
End;
Go

-- Test  EXECUTE Stu_info 1
GO



--3.PROC that take Instructor ID and return Instructor ID,CourseName, Number of Student Per each Course 
create or alter proc Inst_Courses @Inst_ID int 
as
Begin 
select Instructor_Courses.InstructorID,instructor.InstructorName,department.Dept_Name, courses.CourseName , count(distinct(Student_Courses.StudentID)) as Number_Of_Student
from courses,Instructor_Courses,Student_Courses , instructor , department
where courses.CourseID=Instructor_Courses.CourseID
and courses.CourseID=Student_Courses.CourseID
and instructor.InstructorID = Instructor_Courses.InstructorID
and department.Dept_ID = instructor.Dep_Id
and Instructor_Courses.InstructorID=@Inst_ID
group BY Instructor_Courses.InstructorID,instructor.InstructorName,department.Dept_Name, courses.CourseName 
order by Number_Of_Student
End;
Go

-- Test  EXECUTE Inst_Courses 1
GO



--4 Report that takes course ID and returns its topics  
Create or alter procedure CourseTopics @crs_id int
as
begin
	select c.CourseID,c.CourseName,t.TopicID,t.TopicName
	from courses c inner join Topics t
	on c.CourseID = t.CourseID
	where c.CourseID=@crs_id
End;
Go

-- Test  Exec CourseTopics @crs_id=1



--5.Report that takes exam number and returns the Questions in it and chocies 
Create or alter proc Exam_Questions @Exam_num int
as
begin
select Questions.QuestionText,Questions.choice1,Questions.choice2,Questions.choice3
from Questions, Exams_Questions
where Questions.QuestionID=Exams_Questions.QuestionID
AND Exams_Questions.ExamID=@Exam_num
End;
Go

-- Test Exec Exam_Questions @Exam_num=3
Go



--6.Report that takes exam number and the student ID then returns the Questions in this exam with the student answers
Create or alter proc Student_answer @Exam_num int,@Stu_id int
as
begin
select distinct(QuestionS.QuestionText),answers.StudentAnswer
from Questions,answers
where Questions.QuestionID=answers.QuestionID
and answers.ExamID=@Exam_num 
and answers.StudentID=@Stu_id
End;
Go 




-- Test
Exec Student_answer @Exam_num=1, @Stu_id=2
Exec Student_answer @Exam_num=1, @Stu_id=4
Exec Student_answer @Exam_num=1, @Stu_id=5
Exec Student_answer @Exam_num=2, @Stu_id=5


