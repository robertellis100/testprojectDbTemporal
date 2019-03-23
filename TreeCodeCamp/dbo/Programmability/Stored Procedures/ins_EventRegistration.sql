CREATE PROCEDURE [dbo].[ins_EventRegistration]
AS 
BEGIN
	SET NOCOUNT ON

	BEGIN TRY


		DECLARE @EventName VARCHAR(50) = 'TreeCodeCamp';
		DECLARE @Source VARCHAR(386) = 'AdventureWorks2016_Person_Person';
		DECLARE @LoadType CHAR(1) = 'I';
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
		
		---- This will create a random number between 0 and 20,5,1
		DECLARE @LowerLimit INT = 0; ---- The lowest random number
		DECLARE @UpperLimit INT = 2; ---- The highest random number
		DECLARE @RandomChildren INT = ROUND(((@UpperLimit - @LowerLimit -1) * RAND() + @LowerLimit), 0)
		DECLARE @RandomYouth INT = ROUND(((@UpperLimit - @LowerLimit -1) * RAND() + @LowerLimit), 0)
		---- This will create a random number between 1 and 6,3
		DECLARE @LowerAdultLimit INT = 1; ---- The lowest random number
		DECLARE @UpperAdultLimit INT = 4; ---- The highest random number
		DECLARE @RandomAdults INT = ROUND(((@UpperAdultLimit - @LowerAdultLimit -1) * RAND() + @LowerAdultLimit), 0)
		;
		DECLARE @NewHighWaterMark INT = @PreviousHighWaterMark + ROUND(((2 - @LowerAdultLimit -1) * RAND() + @LowerAdultLimit), 0);

---------------------------------------------------------------------------------
		INSERT INTO dbo.LoadLog
		([Source],[LoadType],[PreviousHighWaterMark],[HighWaterMark])		
		VALUES(
			@Source
			, @LoadType
			, @PreviousHighWaterMark
			, @PreviousHighWaterMark
		);
		SELECT @LoadLogId = @@IDENTITY
	
		BEGIN TRANSACTION

			INSERT INTO dbo.EventRegistration
			(
				  EventName		
				, [FirstName]
				, [LastName]
				, [EmailAddress]	
				, RegisteredChildren	
				, RegisteredYouth		
				, RegisteredAdults		
			)
			SELECT 
				  @EventName						AS EventName
				, ISNULL(p.[FirstName],'')			AS FirstName
				, ISNULL(p.[LastName],'')			AS LastName
				, ISNULL(e.[EmailAddress],'')		AS [Email]
				, @RandomChildren					AS RegisteredChildren
				, @RandomYouth						AS RegisteredYouth
				, @RandomAdults						AS RegisteredAdults
			FROM [$(AdventureWorks2016)].[Person].[Person] p
			JOIN [$(AdventureWorks2016)].[Person].[EmailAddress] e
				ON p.[BusinessEntityID] = e.[BusinessEntityID]
			WHERE p.[BusinessEntityID] > @PreviousHighWaterMark
			AND p.[BusinessEntityID] <= @NewHighWaterMark
			SELECT @RowsLoaded = @@ROWCOUNT

			UPDATE dbo.LoadLog
			SET HighWaterMark = @NewHighWaterMark
			  , [RowsLoaded] = @RowsLoaded
			  , [IsSuccess] = 1
			WHERE LoadLogId = @LoadLogId

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