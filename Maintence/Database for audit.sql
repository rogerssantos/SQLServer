IF (SELECT is_disabled FROM SYS.server_triggers WHERE NAME = 'TR_DDLEvents') = 0
	DISABLE TRIGGER [TR_DDLEvents] ON ALL SERVER;
GO

USE MASTER;
GO

IF DB_ID('AuditDB') IS NOT NULL
	DROP DATABASE AuditDB;
GO

CREATE DATABASE AuditDB;
GO

USE AuditDB;
GO

IF OBJECT_ID('dbo.DDLEvents') IS NOT NULL
	DROP TABLE dbo.DDLEvents;
GO

CREATE TABLE [dbo].[DDLEvents](
	[EventDate] [datetime] NOT NULL,
	[EventType] [nvarchar](64) NULL,
	[EventDDL] [nvarchar](max) NULL,
	[EventXML] [xml] NULL,
	[DatabaseName] sysname NULL,
	[SchemaName] sysname NULL,
	[ObjectName] sysname NULL,
	[ObjectType] sysname NULL,
	[HostName] [varchar](128) NULL,
	[IPAddress] [varchar](96) NULL,
	[ProgramName] [nvarchar](255) NULL,
	[LoginName] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

IF (SELECT NAME FROM SYS.server_triggers WHERE NAME = 'TR_DDLEvents') IS NOT NULL
	DROP TRIGGER TR_DDLEvents ON ALL SERVER;
GO

CREATE TRIGGER [TR_DDLEvents]
ON ALL SERVER
FOR
	CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,
	CREATE_TABLE, ALTER_TABLE, DROP_TABLE,
	CREATE_VIEW, ALTER_VIEW, DROP_VIEW,
	CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER,
	CREATE_SCHEMA, ALTER_SCHEMA, DROP_SCHEMA,
	CREATE_DATABASE, ALTER_DATABASE, DROP_DATABASE,
	CREATE_SYNONYM, DROP_SYNONYM,
	CREATE_SEQUENCE, DROP_SEQUENCE,
	RENAME
AS
BEGIN
SET NOCOUNT ON;

	DECLARE
		@EventData XML = EVENTDATA(),
		@IPAddress NVARCHAR(96) =
		(
	        SELECT client_net_address
			FROM sys.dm_exec_connections
			WHERE session_id = @@SPID
		),
		@ObjectName sysname;
		
	IF (@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)') = 'RENAME')
	BEGIN
		SET @ObjectName = CONCAT('OLD.', @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)'));
	END
	ELSE
	BEGIN
		SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)');
	END
	
	INSERT AuditDB.dbo.DDLEvents
	(
		EventDate,
		EventType,
		EventDDL,
		EventXML,
		DatabaseName,
		SchemaName,
		ObjectName,
		ObjectType,
		HostName,
		IPAddress,
		ProgramName,
		LoginName
	)
	SELECT
		CURRENT_TIMESTAMP AS EventDate,
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)') AS EventType,
		@EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)') AS EventDDL,
		@EventData AS EventXML,
		@EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'NVARCHAR(255)') AS DatabaseName,
		@EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(255)') AS SchemaName,
		@ObjectName AS ObjectName,
		@EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(255)') AS ObjectType,
		HOST_NAME() AS HostName,
		@IPAddress AS IPAddress,
		PROGRAM_NAME() AS ProgramName,
		SUSER_SNAME() AS LoginName;
END
GO

ENABLE TRIGGER [TR_DDLEvents] ON ALL SERVER
GO
