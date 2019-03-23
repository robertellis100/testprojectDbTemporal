CREATE TABLE [dbo].[Registrations] (
    [RegistrationId]   INT           IDENTITY (1, 1) NOT NULL,
    [PeopleType]       VARCHAR (8)   NOT NULL,
    [RegisteredPeople] INT           NOT NULL,
    [ValidFrom]        DATETIME2 (7) NOT NULL,
    CONSTRAINT [ci_Registrations_RegistrationId] PRIMARY KEY CLUSTERED ([RegistrationId] ASC)
);

