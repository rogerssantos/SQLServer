-- DATALENGTH VS LEN

-- Test with normal character
DECLARE @TEST VARCHAR(20) = 'ROGER     ';

SELECT DATALENGTH(@TEST);
-- 10

SELECT LEN(@TEST); -- The function LEN does not consider the right spaces
-- 5

-- Test with ncharacteres
DECLARE @TEST2 NVARCHAR(20) = 'ROGER     ';

SELECT DATALENGTH(@TEST2);
-- 20

SELECT LEN(@TEST2); -- The function LEN does not consider the right spaces
-- 5