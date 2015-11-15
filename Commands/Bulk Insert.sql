-- BULK INSERT

/*Create a text file and insert the folowing text

R9 380X;AMD;KABUM;1600.00
6S;APPLE;APPLE STORE;4000.00
MONITOR 29";LG;KABUM;899.90
CX800;CORSAIR;BALAO DA INFORMATICA;850.00

*/
CREATE TABLE WishList(
	Product VARCHAR(50) NOT NULL ,
	Brand VARCHAR(30) ,
	Store VARCHAR(50) ,
	AveragePrice DECIMAL(16,9)
);
GO

BULK INSERT WishList
	FROM 'D:\WishList.txt' -- Here is where you need to point your recently file created
WITH
(
	FIELDTERMINATOR = ';' ,
	ROWTERMINATOR = '\n' -- The \n means (like outher languages), jump line
);
GO

SELECT * FROM WishList;
GO