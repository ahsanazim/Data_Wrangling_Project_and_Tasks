/*************************** HOMEWORK #1 ***************************/

/* Q1 */
EXEC sp_rename 'aazim.demo1.tri_age', 'age', 'COLUMN'
EXEC sp_rename 'aazim.demo1.contactid', 'ID', 'COLUMN'
EXEC sp_rename 'aazim.demo1.address1_stateorprovince', 'State', 'COLUMN'
EXEC sp_rename 'aazim.demo1.tri_imaginecareenrollmentemailsentdate', 'EmailSentDate', 'COLUMN'
EXEC sp_rename 'aazim.demo1.tri_enrollmentcompletedate', 'CompleteDate', 'COLUMN'
SELECT *, DaysTaken = DATEDIFF(DAY, try_convert(date,EmailSentDate), try_convert(date,CompleteDate)) 
ALTER TABLE qbs181.aazim.demo1 ADD DaysTaken AS DATEDIFF(DAY, try_convert(date,EmailSentDate), try_convert(date,CompleteDate))

/* Q2 */
ALTER TABLE qbs181.aazim.demo1 ADD "Enrollment Status" NVARCHAR(255)
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Complete' WHERE tri_imaginecareenrollmentstatus=167410011
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Email Sent' WHERE tri_imaginecareenrollmentstatus=167410001
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Non Responder' WHERE tri_imaginecareenrollmentstatus=167410004
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Facilitated Enrollment' WHERE tri_imaginecareenrollmentstatus=167410005
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Incomplete Enrollments' WHERE tri_imaginecareenrollmentstatus=167410002
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Opted Out' WHERE tri_imaginecareenrollmentstatus=167410003
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Unprocessed' WHERE tri_imaginecareenrollmentstatus=167410000
UPDATE qbs181.aazim.demo1 SET [Enrollment Status]='Second Email Sent' WHERE tri_imaginecareenrollmentstatus=167410006

/* Q3 */
ALTER TABLE qbs181.aazim.demo1 ADD "Sex" NVARCHAR(255)
UPDATE qbs181.aazim.demo1 SET Sex='female' WHERE gendercode='2'
UPDATE qbs181.aazim.demo1 SET Sex='male' WHERE gendercode='1'
UPDATE qbs181.aazim.demo1 SET Sex='other' WHERE tri_imaginecareenrollmentstatus=167410000
UPDATE qbs181.aazim.demo1 SET Sex='other' WHERE gendercode='167410000'
UPDATE qbs181.aazim.demo1 SET Sex='Unknown' WHERE gendercode='NULL'
-- Note that the NULL's are stored in gendercode as strings, not as the raw NULL format. Hence quotes required

/* Q4 */
ALTER TABLE qbs181.aazim.demo1 ADD "Age Group" NVARCHAR(255)
UPDATE qbs181.aazim.demo1 SET [Age Group]='0-25' WHERE Age BETWEEN 0 AND 25
UPDATE qbs181.aazim.demo1 SET [Age Group]='25-50' WHERE Age BETWEEN 25 AND 50
UPDATE qbs181.aazim.demo1 SET [Age Group]='50-60' WHERE Age BETWEEN 50 AND 60
UPDATE qbs181.aazim.demo1 SET [Age Group]='60-70' WHERE Age BETWEEN 60 AND 70
UPDATE qbs181.aazim.demo1 SET [Age Group]='70+' WHERE Age BETWEEN 70 AND 200

/* TESTING */
select * from qbs181.aazim.demo1
select EmailSentDate, CompleteDate from aazim.demo1
select EmailSentDate, CompleteDate, DaysTaken from aazim.demo1
select [Enrollment Status], tri_imaginecareenrollmentstatus from aazim.demo1
select Sex, gendercode from aazim.demo1
select Age, [Age Group] from aazim.demo1