/*Backup all dataBases*/

DECLARE @dataBase VARCHAR(40);
DECLARE @path VARCHAR(1000);
DECLARE @sqlCommand VARCHAR(1000);
DECLARE @dtBackup VARCHAR(10);
DECLARE @logPath VARCHAR(100);
DECLARE @logDatabaseStart VARCHAR(100);
DECLARE @logDatabaseEnd VARCHAR(100);

SET @logpath = CONCAT('C:\Backup\backup_', REPLACE(CONVERT(VARCHAR(10), GETDATE(), 103),'/', '_'), '.log')

EXEC prWriteText @logpath,'Initializing the backup all the bases.';
DECLARE DBBACKUP CURSOR FOR
	SELECT name FROM sys.databases
	WHERE name NOT IN (
		'master', 'tempdb', 'model', 'msdb', 'ReportServer', 'ReportServerTempDB'
	)
OPEN DBBACKUP FETCH NEXT
FROM DBBACKUP INTO @dataBase
WHILE @@FETCH_STATUS = 0
BEGIN

	SET @logDatabaseStart = CONCAT('Initializing ', @dataBase, '...');
	EXEC prWriteText @logpath, @logDatabaseStart;

	SET @dtBackup = REPLACE(CONVERT(VARCHAR(10), GETDATE(), 103),'/', '_')
	SET @path =	LTRIM('C:\Backup\'+@dataBase+'_'+@dtBackup+'.bak');
	SET @sqlCommand = 'BACKUP DATABASE ' + @dataBase +' TO DISK = ''' + @path + ''' WITH INIT;'
	EXEC (@sqlCommand);

	SET @logDatabaseEnd = CONCAT('Finish backup for ', @dataBase, '.');
	EXEC prWriteText @logpath, @logDatabaseEnd;

	FETCH NEXT FROM DBBACKUP INTO @dataBase
END
CLOSE DBBACKUP DEALLOCATE DBBACKUP
EXEC prWriteText @logpath,'Finish the backup all the bases.';
