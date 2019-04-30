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
	[DatabaseName] [nvarchar](255) NULL,
	[SchemaName] [nvarchar](255) NULL,
	[ObjectName] [nvarchar](255) NULL,
	[HostName] [varchar](64) NULL,
	[IPAddress] [varchar](32) NULL,
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
	RENAME
AS
BEGIN
SET NOCOUNT ON;

	DECLARE
		@EventData XML = EVENTDATA(),
		@Ip VARCHAR(32) =
		(
	        SELECT client_net_address
			FROM sys.dm_exec_connections
			WHERE session_id = @@SPID
		),
		@ObjectName NVARCHAR(255);
		
		IF (@EventData.value('(/EVENT_INSTANCE/EventType)[1]',   'NVARCHAR(100)') = 'RENAME')
			SET @ObjectName = CONCAT(
										'OLD.', @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]',  'NVARCHAR(255)')
									);
		ELSE
			SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]',  'NVARCHAR(255)');
	
	INSERT AuditDB.dbo.DDLEvents
	(
		EventDate,
		EventType,
		EventDDL,
		EventXML,
		DatabaseName,
		SchemaName,
		ObjectName,
		HostName,
		IPAddress,
		ProgramName,
		LoginName
	)
	SELECT
		CURRENT_TIMESTAMP,
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]',   'NVARCHAR(100)'), 
		@EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)'),
		@EventData,
		@EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]',  'NVARCHAR(255)'),
		@EventData.value('(/EVENT_INSTANCE/SchemaName)[1]',  'NVARCHAR(255)'), 
		@ObjectName,
		HOST_NAME(),
		@ip,
		PROGRAM_NAME(),
		SUSER_SNAME();
END
GO

ENABLE TRIGGER [TR_DDLEvents] ON ALL SERVER
GO
