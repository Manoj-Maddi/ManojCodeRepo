USE [MDB]
GO

/****** Object:  StoredProcedure [Monitor].[uspMOnitorIOPSDBwise]    Script Date: 13-01-2021 23:38:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************************
*******************************************************************************************
**
**     Author:	Manoj Kumar Maddineni									Date: 13Jan20201
**
**     Description:	Keep a log of IOPS of databases in MDB
**					(depends on the table [MDB].[MONITOR].[DatabaseIOPS])
**
**     Parameters:		
**					
**
**     Remark:	
**
**	   Example: 
**					
**
**     Version: 1.0
**
**
*******************************************************************************************
******************************************************************************************/
CREATE OR ALTER   PROCEDURE [Monitor].[uspMOnitorIOPSDBwise]
       AS
	   BEGIN 

SET NOCOUNT ON;
SET ANSI_WARNINGS OFF;
DECLARE @SQLString nvarchar(MAX); 

             IF EXISTS (SELECT DatabasePropertyEx('master','Status') FROM   master.dbo.sysdatabases where DatabasePropertyEx('master','Status')='ONLINE')
             BEGIN
			 
                     
                    SELECT @SQLString = FORMATMESSAGE('WITH IO_Per_DB_Per_File
AS
(SELECT 
@@SERVERNAME as ServerName,
    DB_NAME(dmivfs.database_id) AS DatabaseName
  , CONVERT(DECIMAL(12,2), SUM(num_of_bytes_read + num_of_bytes_written) / 1024 / 1024) AS TotalMb
  , CONVERT(DECIMAL(12,2), SUM(num_of_bytes_read) / 1024 / 1024) AS TotalMbRead
  , CONVERT(DECIMAL(12,2), SUM(num_of_bytes_written) / 1024 / 1024) AS TotalMbWritten
  , CASE WHEN dmmf.type_desc = ''ROWS'' THEN ''Data File'' WHEN dmmf.type_desc = ''LOG'' THEN ''Log File'' END AS DataFileOrLogFile
 FROM sys.dm_io_virtual_file_stats(NULL, NULL) dmivfs
 JOIN sys.master_files dmmf ON dmivfs.file_id = dmmf.file_id AND dmivfs.database_id = dmmf.database_id
 GROUP BY dmivfs.database_id, dmmf.type_desc)

 INSERT INTO [MDB].[MONITOR].[DatabaseIOPS](ServerName,DatabaseName,TotalMb,TotalMbRead,TotalMbWritten,DataFileOrLogFile,[I/O],CreatedOn,DBMode)
 SELECT 
   ServerName,
    DatabaseName
  , TotalMb
  , TotalMbRead
  , TotalMbWritten
  , DataFileOrLogFile
  , CAST(TotalMb / SUM(TotalMb) OVER() * 100 AS DECIMAL(5,2)) AS [I/O],
CURRENT_TIMESTAMP as CreatedOn,
DBmode=CAST(DATABASEPROPERTYEX([DatabaseName], ''Updateability'') as varchar(50))
FROM IO_Per_DB_Per_File
ORDER BY [I/O] DESC;');
										
										                    EXEC sp_executesql @SQLString;
                    

             END

			 END
GO


