CREATE PROCEDURE [dbo].[ins_Registrations]
AS
BEGIN
		DECLARE @date DATETIME2(7) = '2019-03-21 5:15:00.0000000'
		DECLARE @iteration INT = 1

		IF OBJECT_ID('tempdb..#PossibleDates') IS NOT NULL
			DROP TABLE #PossibleDates;

		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'Registrations')
			DROP TABLE TreeCodeCamp.dbo.Registrations

		SELECT DISTINCT
			ValidFrom
		INTO #PossibleDates
		FROM dbo.EventRegistration
		FOR SYSTEM_TIME ALL
		ORDER BY ValidFrom;

		CREATE TABLE dbo.Registrations
		(
			RegistrationId		INT			IDENTITY(1,1)		NOT NULL,
			PeopleType			VARCHAR(8)						NOT NULL,
			RegisteredPeople	INT								NOT NULL,
			ValidFrom			DATETIME2(7)					NOT NULL,
			CONSTRAINT ci_Registrations_RegistrationId PRIMARY KEY CLUSTERED ([RegistrationId])
		); 

		WHILE EXISTS(SELECT TOP 1 * FROM #PossibleDates)
		BEGIN
			SET @date = (SELECT TOP 1 * FROM #PossibleDates ORDER BY ValidFrom)

			WHILE @iteration <= 3
			BEGIN
				INSERT INTO dbo.Registrations
				SELECT 
					  CASE @iteration
						WHEN 1
							THEN 'Children'
						WHEN 2
							THEN 'Youth'
						WHEN 3
							THEN 'Adults'
					  END						AS PeopleType
					, CASE @iteration
						WHEN 1
							THEN SUM(RegisteredChildren)
						WHEN 2
							THEN SUM(RegisteredYouth)
						WHEN 3
							THEN SUM(RegisteredAdults)
					  END						AS RegisteredPeople
					, @date						AS ValidFrom
				FROM dbo.EventRegistration
				FOR SYSTEM_TIME AS OF @date
				SET @iteration = @iteration + 1
			END	
			SET @iteration = 1

			DELETE FROM #PossibleDates
			WHERE ValidFrom = @date
		END
END --Procedure
