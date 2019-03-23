CREATE PROCEDURE [dbo].[upd_EventRegistration]
AS 
BEGIN
	SET NOCOUNT ON

	BEGIN TRY


		DECLARE @EventName VARCHAR(50) = 'TreeCodeCamp';
		DECLARE @Source VARCHAR(386) = 'AdventureWorks2016_Person_Person';
		DECLARE @LoadType CHAR(1) = 'U';
		DECLARE @PreviousHighWaterMark INT = (SELECT ISNULL(	
										(
											SELECT TOP 1 [HighWaterMark] 
											FROM dbo.LoadLog
											WHERE [Source] = @Source
											AND [IsSuccess] = 1
											ORDER BY [LoadDate] DESC
										), 0)
									);
		DECLARE @LoadLogId INT;
		DECLARE @RowsLoaded INT;
		
		---- This will create a random number between 0 and 20,5
		DECLARE @LowerLimit INT = 0; ---- The lowest random number
		DECLARE @UpperLimit INT = 2; ---- The highest random number
		DECLARE @RandomChildren INT;
		DECLARE @RandomYouth INT;
		---- This will create a random number between 1 and 6
		DECLARE @LowerAdultLimit INT = 1; ---- The lowest random number
		DECLARE @UpperAdultLimit INT = 5; ---- The highest random number
		DECLARE @RandomAdults INT;
		DECLARE @RandomRegistration INT; 
		DECLARE @RandomPerson INT;	
		DECLARE @LowerLimitUpdates INT = 0;
		DECLARE @UpperLimitUpdates INT = 3;
		
		DECLARE @iteration INT	= 1;
		DECLARE @NumberOfUpdates INT = ROUND(((@UpperLimitUpdates - @LowerLimitUpdates -1) * RAND() + @LowerLimitUpdates), 0);		
		
	
---------------------------------------------------------------------------------

	
		BEGIN TRANSACTION

		WHILE @iteration <= @NumberOfUpdates
		BEGIN
			SET @RandomRegistration = ROUND(((@PreviousHighWaterMark - @LowerAdultLimit -1) * RAND() + @LowerAdultLimit), 0);	
			SET @RandomPerson = ROUND(((@PreviousHighWaterMark - @LowerAdultLimit -1) * RAND() + @LowerAdultLimit), 0);	
			SET @RandomChildren = ROUND(((@UpperLimit - @LowerLimit -1) * RAND() + @LowerLimit), 0)
			SET @RandomYouth = ROUND(((@UpperLimit - @LowerLimit -1) * RAND() + @LowerLimit), 0)
			SET @RandomAdults = ROUND(((@UpperAdultLimit - @LowerAdultLimit -1) * RAND() + @LowerAdultLimit), 0);
			UPDATE dbo.EventRegistration		
				SET [FirstName] = (SELECT ISNULL((SELECT [FirstName] FROM [$(AdventureWorks2016)].[Person].[Person] WHERE [BusinessEntityID] = @RandomPerson),'P'))
			    , RegisteredChildren = @RandomChildren
				, RegisteredYouth = @RandomYouth	
				, RegisteredAdults = @RandomAdults
			WHERE [EventRegistrationId] = @RandomRegistration

			SET @iteration = @iteration + 1;
		END

		COMMIT

---------------------------------------------------------------------------------

	
	END TRY
 
	BEGIN CATCH
 
		  IF @@TRANCOUNT > 0
			ROLLBACK
 
			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;

			SELECT @ErrorMessage = ERROR_MESSAGE(),
					@ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE();

			-- Use RAISERROR inside the CATCH block to return 
			-- error information about the original error that 
			-- caused execution to jump to the CATCH block.
			RAISERROR (@ErrorMessage, -- Message text.
						@ErrorSeverity, -- Severity.
						@ErrorState -- State.
						);
		RETURN;
	END CATCH
END; -- END Procedure
GO