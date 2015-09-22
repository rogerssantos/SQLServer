/*FORMAT*/
DECLARE @DATA DATE = '20150101';

SELECT	FORMAT(@DATA, 'd', 'pt-BR') AS 'pt-BR', -- '01/01/2015'
		FORMAT(@DATA, 'd', 'en-gb') AS 'en-gb', -- '01/01/2015'
		FORMAT(@DATA, 'd', 'en-US') AS 'en-US', -- '1/1/2015'
		FORMAT(@DATA, 'd', 'zh-cn') AS 'zh-cn'; -- '2015/1/1'

SELECT	FORMAT(@DATA, 'D', 'pt-BR') AS 'pt-BR', -- 'quinta-feira, 1 de janeiro de 2015'
		FORMAT(@DATA, 'D', 'en-gb') AS 'en-gb', -- '01 January 2015'
		FORMAT(@DATA, 'D', 'en-US') AS 'en-US', -- 'Thursday, January 1, 2015'
		FORMAT(@DATA, 'D', 'zh-cn') AS 'zh-cn'; -- '2015?1?1?'
