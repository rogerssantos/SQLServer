
/* Common Select */

WITH tbLinha AS
(
	SELECT
		OBJECT_NAME(P.object_id) As Tabela, Rows As Linhas,
		SUM(Total_Pages * 8) As Reservado,
		SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) As Dados,
			SUM(Used_Pages * 8) -
			SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) As Indice,
		SUM((Total_Pages - Used_Pages) * 8) As NaoUtilizado
	FROM
		sys.partitions As P
		INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
		INNER JOIN sys.tables AS T ON T.object_id = P.object_id
	GROUP BY OBJECT_NAME(P.object_id), Rows
)
SELECT Tabela, Linhas, Reservado, Dados, Indice, NaoUtilizado FROM tbLinha
WHERE Linhas > 0
ORDER BY linhas desc;

/* Alternative Procedure */

CREATE PROC [dbo].[sp_espacotabela]
as

  declare @vname sysname
  declare @tmpTamTabela table (
    name       sysname     null
  , rows       int         null
  , reserved   varchar(25) null
  , data       varchar(25) null
  , index_size varchar(25) null
  , unused     varchar(25) null )
 
  declare cp1 cursor local fast_forward read_only for
    select name
      from sysobjects
     where type = 'U'
     order by name
 
  open cp1
 
  while 1 = 1
  begin
    fetch next from cp1 into @vname
    if @@fetch_status <> 0 break
 
    insert into @tmpTamTabela (name, rows, reserved
                             , data, index_size, unused)
      exec sp_spaceused @vname
 
  end
  close cp1
  deallocate cp1
 
  select name as 'Nome'
       , rows as 'Linhas'
       , convert(int, replace(reserved, ' KB','')) as 'Tamanho total'
       , convert(int, replace(data, ' KB',''))as 'Dados'
       , convert(int, replace(index_size, ' KB',''))as 'Index'
       , convert(int, replace(unused, ' KB',''))as 'Não utilizado'
    from @tmpTamTabela
   order by convert(int, replace(reserved, ' KB','')) desc
GO
