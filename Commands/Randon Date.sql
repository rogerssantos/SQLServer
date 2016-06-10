
-- Generate a randon date

SELECT GETDATE() + (365 * 2 * RAND() - 365);