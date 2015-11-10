/*Backup all dataBases*/

DECLARE @dataBase VARCHAR(40);
DECLARE @path VARCHAR(1000);
DECLARE @sqlCommand VARCHAR(1000);
DECLARE @dtBackup VARCHAR(10)

DECLARE DBBACKUP CURSOR FOR
	SELECT name FROM sys.databases
	WHERE name NOT IN (
		'master', 'tempdb', 'model', 'msdb', 'ReportServer', 'ReportServerTempDB'
	)
OPEN DBBACKUP FETCH NEXT
FROM DBBACKUP INTO @dataBase
WHILE @@FETCH_STATUS = 0
BEGIN

	SET @dtBackup = REPLACE(CONVERT(VARCHAR(10), GETDATE(), 103),'/', '_')
	SET @path =	LTRIM('C:\Backup\'+@dataBase+'_'+@dtBackup+'.bak');
	SET @sqlCommand = 'BACKUP DATABASE ' + @dataBase +' TO DISK = ''' + @path + ''' WITH INIT;'

	EXEC (@sqlCommand);

	FETCH NEXT FROM DBBACKUP INTO @dataBase
END
CLOSE DBBACKUP DEALLOCATE DBBACKUP
