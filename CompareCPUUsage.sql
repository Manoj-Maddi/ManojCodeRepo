USE [MDB]
GO
/****** Object:  StoredProcedure [Monitor].[CompareCPUUsage_Test]    Script Date: 2/1/2021 12:49:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [Monitor].[CompareCPUUsage_Test]
 (@PreviousStartTime DATETIME,
  @PreviousEndTIme DATETIME,
  @CurrentStartTime DATETIME,
  @CurrentEndTime DATETIME)
AS
BEGIN 
	select ROW_NUMBER() OVER(order by CPUPercent desc)as PreviousID,ServerName,databaseName,CPUTimems,
	CPUPercent,[DBMODE],CreatedOn into #TempPreviousResult from [MDB].[Monitor].[DBCPUStats] 
	where CreatedOn between @PreviousStartTime AND @PreviousEndTIme order by DatabaseName,CreatedOn desc

	select ROW_NUMBER() OVER(order by CPUPercent desc)as CurrentID,ServerName,databaseName,CPUTimems,
	CPUPercent,[DBMODE],CreatedOn into #TempCurrentResult  from [MDB].[Monitor].[DBCPUStats] 
	where CreatedOn between @CurrentStartTime AND @CurrentEndTime order by DatabaseName,CreatedOn desc

	select #TempPreviousResult.ServerName,
	#TempPreviousResult.DatabaseName,
	#TempPreviousResult.CreatedOn as PreviousStartTime,
	#TempCurrentResult.CreatedOn as CurrentStartTime,
	#TempPreviousResult.CPUTimems as PreviousCPUTime,
	#TempCurrentResult.CPUTimems as CurrentCPUTime,
	#TempPreviousResult.CPUPercent as PreviousCPUPercent,
	#TempCurrentResult.CPUPercent as CurrentCPUPercent,
	#TempCurrentResult.CPUTimems-#TempPreviousResult.CPUTimems as DifferenceCPUTimems,
	#TempCurrentResult.CPUPercent-#TempPreviousResult.CPUPercent as DifferenceCPUPercentage,
	#TempPreviousResult.DBMode as PreviousDBMode,
	#TempCurrentResult.DBMode as CurrentDBMode
	from #TempPreviousResult,#TempCurrentResult
		where #TempPreviousResult.PreviousID=#TempCurrentResult.CurrentID
		order by #TempCurrentResult.CreatedOn,#TempPreviousResult.CreatedOn,#TempPreviousResult.DatabaseName desc

		DROP TABLE #TempPreviousResult
		DROP TABLE #TempCurrentResult
	END

	
	

