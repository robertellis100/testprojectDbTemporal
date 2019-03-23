CREATE VIEW [dbo].[EventRegistration_All]
AS
	SELECT *
	FROM (
		SELECT
			  [EventRegistrationId]
			, [EventName]																					
			, [FirstName]																					
			, [LastName]																					
			, [EmailAddress]																				
			, [RegisteredChildren]																			
			, [RegisteredYouth]																				
			, [RegisteredAdults]																			
			, CAST([ValidFrom] AS DATETIME2(0))			AS	AllValidFrom																			
			, CAST([ValidTo] AS DATETIME2(0))			AS	AllValidTo																		

		FROM dbo.EventRegistration
		FOR SYSTEM_TIME ALL
	) x