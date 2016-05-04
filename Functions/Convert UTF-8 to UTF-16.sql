SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/* Returns UTF-16 coded nvarchar string from a string of UTF-8 octets.
   Note that while the input is passed in as a varchar, we are actually
   treating each character as if it were a UTF-8 octet. To do this,
   the number returned by ASCII() must be the value of the octet.
   This, along with the PATINDEX() means that this function will
   probably only work if the database collation uses CP1252 for varchar
   and the collation on the value being passed in as @s uses CP1252 too.

   This function has no error checking and does not detect bogus UTF-8
   sequences.
   The function fails if the returned UTF-16 would exceed 4000 code units.
*/
CREATE FUNCTION dbo.utf8_to_utf16 (@s varchar(8000))
RETURNS nvarchar(4000)
BEGIN
  IF @s IS NULL RETURN NULL
  DECLARE @n int, @r nvarchar(4000), @cn int, @octets int, @ch nvarchar(2)
  SET @r = N''
  WHILE 1 = 1 BEGIN
    -- dubious: unexpected octets (0x80-0xBF, 0xF8-0xFF) are treated like 0x00-0x7F
    SET @n = PATINDEX('%[À-÷]%', @s COLLATE Latin1_General_bin)
    IF @n = 0 BEGIN
      SET @r = @r + @s
      BREAK
    END ELSE BEGIN
      SET @r = @r + SUBSTRING(@s, 1, @n-1)
      SET @cn = ASCII(SUBSTRING(@s, @n, 1))
      IF @cn <= 0xDF BEGIN
        SET @octets = 2
        SET @ch = NCHAR((@cn & 0x1F) * 0x40 +
          (ASCII(SUBSTRING(@s, @n+1, 1)) & 0x3F))
      END ELSE IF @cn <= 0xEF BEGIN
        SET @octets = 3
        SET @ch = NCHAR((@cn & 0x0F) * 0x1000 +
          (ASCII(SUBSTRING(@s, @n+1, 1)) & 0x3F) * 0x40 +
          (ASCII(SUBSTRING(@s, @n+2, 1)) & 0x3F))
      END ELSE BEGIN
        -- code point in a supplementary plane: output UTF-16 surrogate pair
        SET @octets = 4
        SET @ch = NCHAR((@cn & 0x07) * 0x100 + 
            (ASCII(SUBSTRING(@s, @n+1, 1)) & 0x3F) * 0x04 +
            (ASCII(SUBSTRING(@s, @n+2, 1)) & 0x30) / 0x10 + 0xD7C0) +
          NCHAR((ASCII(SUBSTRING(@s, @n+2, 1)) & 0x0F) * 0x40 +
            (ASCII(SUBSTRING(@s, @n+3, 1)) & 0x3F) + 0xDC00)
      END
      SET @r = @r + @ch
      SET @s = SUBSTRING(@s, @n+@octets, 8000)
    END
  END
  RETURN @r
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO