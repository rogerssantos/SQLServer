/*Função para trazer datas*/

--SQL Server
/*Data Atual*/

select GETDATE();

/*Extrair*/

select DAY(GETDATE());
select MONTH(GETDATE());
select YEAR(GETDATE());