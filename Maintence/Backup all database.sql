/*Backup all dataBases*/


DECLARE @dataBase VARCHAR(40);
DECLARE @caminho VARCHAR(1000);
DECLARE @sqlCommand VARCHAR(1000);
DECLARE @dtBackup VARCHAR(10)

DECLARE DBBACKUP CURSOR FOR
	SELECT NAME FROM SYS.DATABASES
	WHERE NAME LIKE 'Name'
OPEN DBBACKUP FETCH NEXT
FROM DBBACKUP INTO @dataBase
WHILE @@FETCH_STATUS = 0
BEGIN

	SET @dtBackup = REPLACE(CONVERT(VARCHAR(10), GETDATE(), 103),'/', '_')
	SET @caminho =	LTRIM('C:\Backup\'+@dataBase+'_'+@dtBackup+'.bak');

	SET @sqlCommand = 'BACKUP database ' + @dataBase +' to disk = ''' + @caminho + ''' WITH INIT;'

	EXEC (@sqlCommand);

	FETCH NEXT FROM DBBACKUP INTO @dataBase
END
CLOSE DBBACKUP DEALLOCATE DBBACKUP