CREATE TABLE [dbo].[EventRegistration]
(
	[EventRegistrationId]		INT				IDENTITY(1,1)						NOT NULL PRIMARY KEY,
	[EventName]					VARCHAR(50)											NOT NULL,		
	[FirstName]					NVARCHAR(50)										NOT NULL,
	[LastName]					NVARCHAR(50)										NOT NULL,
	[EmailAddress]				NVARCHAR(50)										NOT NULL,
	[RegisteredChildren]		INT													NOT NULL,
	[RegisteredYouth]			INT													NOT NULL,
	[RegisteredAdults]			INT													NOT NULL,
	[ValidFrom]					DATETIME2	GENERATED ALWAYS AS ROW START 			NOT NULL DEFAULT GETUTCDATE(),
	[ValidTo]					DATETIME2	GENERATED ALWAYS AS ROW END 			NOT NULL DEFAULT '9999-12-31 23:59:59.9999999',
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo]),
)
WITH (SYSTEM_VERSIONING = ON(HISTORY_TABLE=[dbo].[EventRegistration_History], DATA_CONSISTENCY_CHECK=ON))
