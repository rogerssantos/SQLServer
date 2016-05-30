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
