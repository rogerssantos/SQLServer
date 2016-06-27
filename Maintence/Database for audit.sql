ALTER TRIGGER [TR_DDLEvents]
    ON ALL SERVER
    FOR
	CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,
	CREATE_TABLE, ALTER_TABLE, DROP_TABLE,
	CREATE_VIEW, ALTER_VIEW, DROP_VIEW,
	CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER,
	CREATE_SCHEMA, ALTER_SCHEMA, DROP_SCHEMA,
	CREATE_DATABASE, ALTER_DATABASE, DROP_DATABASE,
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
										'OLD.', @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]',  'NVARCHAR(255)'),
										' NEW. ', @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
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
        DB_NAME(),
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