CREATE PROCEDURE sp_CallURL(
	@url VARCHAR(8000)
)
AS
BEGIN
	DECLARE @Object AS INT;
	DECLARE @ResponseText AS VARCHAR(8000);
	EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
	EXEC sp_OAMethod @Object, 'open', NULL, 'get', @url, 'false';
	EXEC sp_OAMethod @Object, 'send'
	EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
	SELECT @ResponseText
	EXEC sp_OADestroy @Object
END;

-- Test
DECLARE @url VARCHAR(8000) = 'http://google.com';
EXEC sp_CallURL @url;