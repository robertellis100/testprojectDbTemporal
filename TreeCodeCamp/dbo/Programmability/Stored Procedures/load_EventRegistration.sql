CREATE PROCEDURE [dbo].[load_EventRegistration]
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
---------------------------------------------------------------------------------

	EXEC dbo.ins_EventRegistration
	EXEC dbo.upd_EventRegistration

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