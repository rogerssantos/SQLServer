-- ALTER DATABASE MODIFY FILE

ALTER DATABASE <NameDataBase> MODIFY FILE (NAME = 'teste1', NEWNAME = 'teste_data');

-- Before
Name            Filename                                                           
----------------------------------------------------------------------------
teste1          C:\Arquivos de programas\Microsoft SQL Server\MSSQL$A\data\teste1.mdf
teste1_log      C:\Arquivos de programas\Microsoft SQL Server\MSSQL$A\data\teste1_log.ldf

-- After:

Name           Filename                                                           
----------------------------------------------------------------------------
teste_data     C:\Arquivos de programas\Microsoft SQL Server\MSSQL$A\data\teste1.mdf
teste1_log     C:\Arquivos de programas\Microsoft SQL Server\MSSQL$A\data\teste1_log.ldf
