CREATE VIEW [dbo].[EventRegistrationValidFromGrouped]
AS 
	SELECT 
		  [EventRegistrationId]	
		, [EventName]				
		, [FirstName]				
		, [LastName]				
		, [EmailAddress]			
		, [RegisteredChildren]	
		, [RegisteredYouth]		
		, [RegisteredAdults]		
		, CAST(ValidFrom AS DATETIME2(0))								AS ValidFromGrouped				
		, CAST(ValidFrom AS DATETIME2(0))								AS ValidToGrouped	
	FROM dbo.EventRegistration

	--SELECT
	--	SUM([RegisteredChildren]+[RegisteredYouth]+[RegisteredAdults])	AS RegisteredPeople	
	--FROM dbo.EventRegistration
	--WHERE ValidFrom <='2019-03-22 20:00:00'
