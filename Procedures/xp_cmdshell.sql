EXEC sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'xp_cmdshell', 1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'show advanced options', 0;
GO

RECONFIGURE;
GO

--TESTE
EXECUTE xp_cmdshell 'C:\Workspace\delete.bat';