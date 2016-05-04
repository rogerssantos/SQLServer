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

   This function is based on utf8to32b, pp 543-545 Unicode Demystified
   by Richard Gillam (Addison-Wesley Professional, 2002).
   Most erroneous UTF-8 octet sequences convert to U+FFFD, but non-shortest
   sequences are allowed through.
   The function fails if the returned UTF-16 would exceed 4000 code units.
*/
CREATE FUNCTION dbo.utf8_to_utf16a (@s varchar(8000))
RETURNS nvarchar(4000)
BEGIN
  DECLARE @states binary(128)
  SET @states =
    -- 0 1 2 3 4 5 6 7 8 9 A B C D E F101112131415161718191A1B1C1D1E1F
    0x00000000000000000000000000000000FFFFFFFFFFFFFFFF01010101020203FF +
    0xFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE0000000000000000FEFEFEFEFEFEFEFE +
    0xFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE0101010101010101FEFEFEFEFEFEFEFE +
    0xFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE0202020202020202FEFEFEFEFEFEFEFE

  DECLARE @size int, @out nvarchar(4000), @outp int, @q int, @state int, @mask int
  SELECT @size = DATALENGTH(@s), @out = 0x, @outp = 0, @q = 1, @state = 0, @mask = 0

  WHILE @q <= @size BEGIN
    DECLARE @c int
    SELECT @c = ASCII(SUBSTRING(@s, @q, 1)), @q = @q + 1,
      @state = CAST(SUBSTRING(@states, 1 + @state*32 + @c/8, 1) AS int)
    IF @state = 0 BEGIN
      SET @outp = @outp + (@c & 0x7F)
      IF @outp <= 0xFFFF
        SET @out = @out + NCHAR(@outp)
      ELSE
        SET @out = @out + NCHAR(@outp / 0x400 + 0xD7C0) + NCHAR((@outp & 0x3FF) + 0xDC00)
      SELECT @outp = 0, @mask = 0
    END ELSE IF @state <= 3 BEGIN
      IF @mask = 0 SET @mask = CAST(SUBSTRING(0x1F0F07, @state, 1) AS int)
      SELECT @outp = (@outp + (@c & @mask)) * 0x40, @mask = 0x3F
    END ELSE BEGIN
      IF @state = 0xFE SET @q = @q - 1
      SELECT @out = @out + NCHAR(0xFFFD), @outp = 0, @state = 0, @mask = 0
    END
  END
  -- end of input is incomplete sequence:
  IF @mask <> 0 SELECT @out = @out + NCHAR(0xFFFD)
  RETURN @out
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO