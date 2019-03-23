CREATE VIEW [dbo].[PreviousValue]
AS 
	SELECT *
	FROM (
		SELECT
			  EventRegistrationId
			, LAG([EventName],1,'')	OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom])			AS PreviousEventName
			, LAG([FirstName],1,'') OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom])			AS PreviousFirstName
			, LAG([LastName],1,'') OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom])			AS PreviousLastName
			, LAG([EmailAddress],1,'') OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom])		AS PreviousEmailAddress
			, LAG([RegisteredChildren],1,0)	OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom])	AS PreviousRegisteredChildren
			, LAG([RegisteredYouth],1,0) OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom])		AS PreviousRegisteredYouth
			, LAG([RegisteredAdults],1,0) OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom])		AS PreviousRegisteredAdults
			, CAST(LAG([ValidFrom],1,NULL) OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom]) AS DATETIME2(0))			AS PreviousValidFrom
			, CAST(LAG([ValidTo],1,NULL)	OVER(PARTITION BY [EventRegistrationId] ORDER BY [ValidFrom]) AS DATETIME2(0))			AS PreviousValidTo

			, [EventName]																					AS NewEventName
			, [FirstName]																					AS NewFirstName
			, [LastName]																					AS NewLastName
			, [EmailAddress]																				AS NewEmailAddress
			, [RegisteredChildren]																			AS NewRegisteredChildren
			, [RegisteredYouth]																				AS NewRegisteredYouth
			, [RegisteredAdults]																			AS NewRegisteredAdults
			, CAST([ValidFrom] AS DATETIME2(0))																AS NewValidFrom
			, CAST([ValidTo] AS DATETIME2(0))																AS NewValidTo

		FROM dbo.EventRegistration
		FOR SYSTEM_TIME ALL
	) x

