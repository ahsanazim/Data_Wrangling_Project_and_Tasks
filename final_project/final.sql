/* QBS-181 Final sql code */

/***********************************
           QUESTION 2
***********************************/
/***** ANSWER *****/
/* NOTE on selected method:
 * 	I realise that the usual technique for this sort of 
 * question might be to first do a group-by maximum 
 * TextSentDate on the output of our three way join, 
 * with this then being joined with the raw output from 
 * the subqueries.
 * 	I opted for a different technique here, one using 
 * analytic queries - i.e. over, partition by, etc. I can
 * explain the logic behind these if required, they're 
 * applied in a relatively straightforward fashion below 
 * though.  
 */
SELECT * FROM 
(
	SELECT contactid as ID, 
			gendercode, 
			tri_age,
			parentcontactidname,
			tri_imaginecareenrollmentstatus,
			address1_stateorprovince,
			tri_enrollmentcompletedate,
			tri_name,
			SenderName,
			TextSentDate,
			max(TextSentDate) over (partition by contactid) as MaxTextSentDate
	FROM
	(
		SELECT * FROM qbs181.dbo.Demographics
			INNER JOIN qbs181.dbo.ChronicConditions
				ON qbs181.dbo.Demographics.contactid=qbs181.dbo.ChronicConditions.tri_patientid
			INNER JOIN qbs181.dbo.Text
				ON qbs181.dbo.Text.tri_contactId=qbs181.dbo.ChronicConditions.tri_patientid
	) AS t2
) AS t1
WHERE t1.TextSentDate = t1.MaxTextSentDate


/********************* NOTES ON MY ANSWER **********************/
/* Since there still seem to be a small number of duplicate IDs (there 
 * are ~80k total rows, I have ~4k in my output, while there are 3k 
 * unique IDs --> hence ideally I'd have ~3k rows in my output) present,
 * this is to demonstrate some of these duplicate IDs. Here I simply take
 * one of the duplicate IDs, eg 8C4FF7DC-A90C-E611-811B-C4346BAC02E8, and 
 * return its corresponding data. Although I could simply choose one of 
 * the corresponding rows and only use it, I choose to keep these rows as
 * their content is in fact distinct and they seem to be referring to 
 * distinct people. This therefore seems to be an issue with the underlying 
 * data as much as anything else.
 */
SELECT * FROM 
(
	SELECT * FROM 
	(
		SELECT contactid as ID, 
				gendercode, 
				tri_age,
				parentcontactidname,
				tri_imaginecareenrollmentstatus,
				address1_stateorprovince,
				tri_enrollmentcompletedate,
				tri_name,
				SenderName,
				TextSentDate,
				max(TextSentDate) over (partition by contactid) as MaxTextSentDate
		FROM
		(
			SELECT * FROM qbs181.dbo.Demographics
				INNER JOIN qbs181.dbo.ChronicConditions
					ON qbs181.dbo.Demographics.contactid=qbs181.dbo.ChronicConditions.tri_patientid
				INNER JOIN qbs181.dbo.Text
					ON qbs181.dbo.Text.tri_contactId=qbs181.dbo.ChronicConditions.tri_patientid
		) AS t2
	) AS t1
	WHERE t1.TextSentDate = t1.MaxTextSentDate
) AS t3
WHERE t3.ID='8C4FF7DC-A90C-E611-811B-C4346BAC02E8'