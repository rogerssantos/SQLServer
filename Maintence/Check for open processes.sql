select
	p.blocked,
	P.spid,
	db_name(p.dbid) as dbname,
	p.status,
	right(convert(varchar, 
			dateadd(ms, datediff(ms, P.last_batch, getdate()), '1900-01-01'), 
			121), 12) as 'batch_duration',
	P.program_name,
	P.hostname,
	P.loginame,
	dest.text
from master.dbo.sysprocesses P
CROSS APPLY sys.dm_exec_sql_text(p.sql_handle) AS dest
where P.spid > 50
and	P.cmd not in ('MIRROR HANDLER'
                    ,'LAZY WRITER'
                    ,'CHECKPOINT SLEEP'
                    ,'RA MANAGER')
order by batch_duration desc
