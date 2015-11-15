CREATE PROCEDURE PRWriteToFile(
	-- Font: http://devwithdave.com/SQLServer/stored-procedures/SQLServer-StoredProcedures--HOW-TO-WRITE-TO-A-TEXT-FILE.asp
    @File        VARCHAR(2000),
    @Text        VARCHAR(2000)
)
AS
 
BEGIN
 
    DECLARE @OLE            INT;
    DECLARE @FileID         INT;
 
    EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT;
    EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @File, 8, 1;
    EXECUTE sp_OAMethod @FileID, 'WriteLine', Null, @Text;
    EXECUTE sp_OADestroy @FileID;
    EXECUTE sp_OADestroy @OLE;
 
END
GO