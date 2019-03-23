CREATE VIEW [dbo].[AsOf]
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
		, ValidFrom			
		, ValidTo	
	FROM dbo.EventRegistration
	FOR SYSTEM_TIME AS OF '2019-03-22 20:00:00'

	--SELECT
	--	SUM([RegisteredChildren]+[RegisteredYouth]+[RegisteredAdults])	AS RegisteredPeople	
	--FROM dbo.EventRegistration
	--FOR SYSTEM_TIME AS OF '2019-03-22 20:00:00'