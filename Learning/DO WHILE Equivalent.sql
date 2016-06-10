-- DO WHILE Equivalent

DECLARE @I INT=1;
START:
    PRINT @I;
    SET @I += 1;
IF @I<=10 GOTO START;
