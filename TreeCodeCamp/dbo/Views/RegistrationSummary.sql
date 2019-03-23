CREATE VIEW [dbo].[RegistrationSummary]
AS
	SELECT
		  PeopleType		
		, RegisteredPeople
		, ValidFromGrouped
		 , LAG([PeopleType],1,'') OVER(PARTITION BY [PeopleType] ORDER BY ValidFromGrouped)			AS PreviousPeopleType
		 , LAG([RegisteredPeople],1,0) OVER(PARTITION BY [PeopleType] ORDER BY ValidFromGrouped)	AS PreviousRegisteredPeople
		 , LAG(ValidFromGrouped,1,NULL) OVER(PARTITION BY [PeopleType] ORDER BY ValidFromGrouped)	AS PreviousValidFromGrouped
	FROM (
		SELECT *
		FROM (
			SELECT 
				  PeopleType		
				, RegisteredPeople				
				, CAST(ValidFrom AS DATETIME2(0))								AS ValidFromGrouped
				, RANK() OVER(PARTITION BY PeopleType,CAST(ValidFrom AS DATETIME2(0)) ORDER BY ValidFrom DESC)	AS RankNum
			FROM dbo.[RegistrationsLag]
		) x
		WHERE RankNum = 1
) y
