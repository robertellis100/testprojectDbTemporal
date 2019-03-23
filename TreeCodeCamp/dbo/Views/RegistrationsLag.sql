CREATE VIEW [dbo].[RegistrationsLag]
AS 
	SELECT  
		   RegistrationId
		 , [PeopleType]      
		 , [RegisteredPeople]
		 , ValidFrom 
		 
		 --, LAG([PeopleType],1,'') OVER(PARTITION BY [PeopleType] ORDER BY ValidFrom) AS PreviousPeopleType
		 --, LAG([RegisteredPeople],1,0) OVER(PARTITION BY [PeopleType] ORDER BY ValidFrom) AS PreviousRegisteredPeople
		 --, LAG(ValidFrom,1,NULL) OVER(PARTITION BY [PeopleType] ORDER BY ValidFrom) AS PreviousValidFrom

	FROM dbo.[Registrations]
