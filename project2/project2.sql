/*************************** HOMEWORK #2 ***************************/

/* Q1 */
ALTER TABLE qbs181.aazim.PhoneCall ADD "EnrollmentGroup" NVARCHAR(255)
UPDATE qbs181.aazim.PhoneCall SET EnrollmentGroup='Clinical Alert' WHERE EncounterCode=125060000
UPDATE qbs181.aazim.PhoneCall SET EnrollmentGroup='Health Coaching' WHERE EncounterCode=125060001
UPDATE qbs181.aazim.PhoneCall SET EnrollmentGroup='Technical Question' WHERE EncounterCode=125060002
UPDATE qbs181.aazim.PhoneCall SET EnrollmentGroup='Administrative' WHERE EncounterCode=125060003
UPDATE qbs181.aazim.PhoneCall SET EnrollmentGroup='Other' WHERE EncounterCode=125060004
UPDATE qbs181.aazim.PhoneCall SET EnrollmentGroup='Lack of engagement' WHERE EncounterCode=125060005

/* Q2 */
SELECT EnrollmentGroup, count(EnrollmentGroup) FROM qbs181.aazim.PhoneCall GROUP BY EnrollmentGroup

/* Q3 */
SELECT * FROM qbs181.aazim.CallDuration 
	INNER JOIN qbs181.aazim.PhoneCall 
	ON CallDuration.tri_CustomerIDEntityReference=PhoneCall.CustomerId 

/* Q4 */
ALTER TABLE qbs181.aazim.CallDuration ADD "CallTypeChar" NVARCHAR(255)
UPDATE qbs181.aazim.CallDuration SET CallTypeChar='Inbound' WHERE CallType=1
UPDATE qbs181.aazim.CallDuration SET CallTypeChar='Outbound' WHERE CallType=2

ALTER TABLE qbs181.aazim.CallDuration ADD "CallOutcomeChar" NVARCHAR(255)
UPDATE qbs181.aazim.CallDuration SET CallOutcomeChar='No Response' WHERE CallType=1
UPDATE qbs181.aazim.CallDuration SET CallOutcomeChar='Left Voicemail' WHERE CallType=2
UPDATE qbs181.aazim.CallDuration SET CallOutcomeChar='Successful' WHERE CallType=3

SELECT CallTypeChar, count(CallTypeChar) FROM qbs181.aazim.CallDuration GROUP BY CallTypeChar
SELECT CallOutcomeChar, count(CallOutcomeChar) FROM qbs181.aazim.CallDuration GROUP BY CallOutcomeChar

SELECT EnrollmentGroup, SUM(CallDuration) FROM qbs181.aazim.CallDuration 
	INNER JOIN qbs181.aazim.PhoneCall 
	ON CallDuration.tri_CustomerIDEntityReference=PhoneCall.CustomerId
GROUP BY EnrollmentGroup

/* Q5 */
SELECT *
FROM qbs181.dbo.Demographics
INNER JOIN qbs181.dbo.ChronicConditions
	ON qbs181.dbo.Demographics.contactid=qbs181.dbo.ChronicConditions.tri_patientid
INNER JOIN qbs181.dbo.Text
	ON qbs181.dbo.Text.tri_contactId=qbs181.dbo.ChronicConditions.tri_patientid
	
SELECT SenderName, COUNT(SenderName) / DATEDIFF(WEEK,MIN(TextSentDate),MAX(TextSentDate)) AS TextsPerWeek 
	FROM qbs181.dbo.Text 
GROUP BY SenderName


/* Q6 */

SELECT sub.tri_name AS ChronicCondition, COUNT(sub.tri_name) AS numTextsInFirstWeekOfMarch2016
	FROM
		(
			SELECT *
			FROM qbs181.dbo.ChronicConditions
			INNER JOIN qbs181.dbo.Demographics
				ON qbs181.dbo.Demographics.contactid=qbs181.dbo.ChronicConditions.tri_patientid
			INNER JOIN qbs181.dbo.Text
				ON qbs181.dbo.Text.tri_contactId=qbs181.dbo.ChronicConditions.tri_patientid
		) sub
WHERE sub.TextSentDate BETWEEN '2016-03-01 00:00:00' AND '2016-03-07 00:00:00' 
GROUP BY sub.tri_name


/* TESTING */
select * from qbs181.aazim.PhoneCall
select EncounterCode, EnrollmentGroup from aazim.PhoneCall

