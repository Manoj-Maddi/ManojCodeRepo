USE [MDB]
GO
/****** Object:  StoredProcedure [Monitor].[CompareIOPS_Test]    Script Date: 2/1/2021 12:54:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [Monitor].[CompareIOPS_Test]
 (@PreviousIOStartTime DATETIME,
  @PreviousIOEndTIme DATETIME,
  @CurrentIOStartTime DATETIME,
  @CurrentIOEndTime DATETIME)
AS
BEGIN 
select ROW_NUMBER() OVER(order by databaseName desc)as PreviousID, ServerName,databaseName,[TotalMB],[TotalMBRead],[TotalMBWritten],[DataFileOrLogFile],[I/O],[CreatedOn],[DBMode] into #TempPreviousIOResult from  [MDB].[Monitor].[DatabaseIOPS] 
where CreatedOn between @PreviousIOStartTime and @PreviousIOEndTIme order by databasename desc


select ROW_NUMBER() OVER(order by databaseName desc)as CurrentID, ServerName,databaseName,[TotalMB],[TotalMBRead],[TotalMBWritten],[DataFileOrLogFile],[I/O],[CreatedOn],[DBMode] into #TempCurrentIOResult from  [MDB].[Monitor].[DatabaseIOPS] 
where CreatedOn between @CurrentIOStartTime and @CurrentIOEndTime order by databasename desc


	select #TempPreviousIOResult.ServerName,
	#TempPreviousIOResult.DatabaseName,
	#TempPreviousIOResult.CreatedOn as PreviousIOStartTime,
	#TempCurrentIOResult.CreatedOn as CurrentIOStartTime,
	#TempPreviousIOResult.TotalMBRead as PreviousTotalMBRead,
	#TempCurrentIOResult.TotalMBRead as CurrentTotalMBRead,
	#TempCurrentIOResult.TotalMBRead-#TempPreviousIOResult.TotalMBRead as DifferenceTotalMBRead,
	#TempPreviousIOResult.TotalMBWritten as PreviousTotalMBWritten,
	#TempCurrentIOResult.TotalMBWritten as CurrentTotalMBWritten,
	#TempCurrentIOResult.TotalMBWritten-#TempPreviousIOResult.TotalMBWritten as DifferenceTotalMBWritten,
	#TempPreviousIOResult.[I/O] as PreviousIO,
	#TempCurrentIOResult.[I/O] as currentIO,
	#TempCurrentIOResult.[I/O]-#TempPreviousIOResult.[I/O] as IODifference,
	#TempPreviousIOResult.DataFileOrLogFile as DataFileorLogFile,
	#TempPreviousIOResult.DBMode as PreviousDBMode,
	#TempCurrentIOResult.DBMode as CurrentDBMode
	from #TempPreviousIOResult,#TempCurrentIOResult
		where #TempPreviousIOResult.PreviousID=#TempCurrentIOResult.CurrentID
		order by IODifference desc

		DROP TABLE #TempPreviousIOResult
		DROP TABLE #TempCurrentIOResult
	 END