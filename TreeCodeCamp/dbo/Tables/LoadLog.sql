CREATE TABLE [dbo].[LoadLog]
(
	[LoadLogId]				INT				IDENTITY(1,1)			NOT NULL PRIMARY KEY,
	[Source]				VARCHAR(386)							NOT NULL,
	[LoadType]				CHAR(1)									NOT NULL,
	[PreviousHighWaterMark]	INT										NOT NULL,
	[HighWaterMark]			INT										NOT NULL,
	[LoadDate]				DATETIME2(7)	DEFAULT GETUTCDATE()	NOT NULL,
	[RowsLoaded]			INT				DEFAULT(0)				NOT NULL,
	[IsSuccess]				BIT				DEFAULT(0)				NOT NULL
)
