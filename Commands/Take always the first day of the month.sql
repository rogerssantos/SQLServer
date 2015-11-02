-- First day of the current month

SELECT DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0);