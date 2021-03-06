USE [MDB]
GO
/****** Object:  StoredProcedure [Monitor].[CompareTopExpensiveQueries_Test]    Script Date: 2/1/2021 12:54:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER    PROCEDURE [Monitor].[CompareTopExpensiveQueries_Test]
 (@PreviousdaystartTime DATETIME,
  @PreviousdayEndTime DATETIME,
  @CurrentdaystartTime DATETIME,
  @CurrentdayEndTime DATETIME)
AS
BEGIN
  	select ServerName,databaseName,[ObjectName],[QueryText],[TotalCPUPercent],[TotalLogicalReadsPercent],
	CreatedOn into #TempTopQueriesPrevious from [MDB].[Monitor].[TopExpensiveQueries] WITH (NOLOCK)
	where CreatedOn between @PreviousdaystartTime AND @PreviousdayEndTime order by CreatedOn,DatabaseName,[TotalCPUPercent] desc 

	select ServerName,databaseName,[ObjectName],[QueryText],[TotalCPUPercent],[TotalLogicalReadsPercent],
	CreatedOn into #TempTopQueriesCurrent from [MDB].[Monitor].[TopExpensiveQueries]  WITH (NOLOCK)
	where CreatedOn between @CurrentdaystartTime AND @CurrentdayEndTime order by CreatedOn,DatabaseName,[TotalCPUPercent] desc

	select * from #TempTopQueriesPrevious order by [TotalCPUPercent] desc;
	select * from #TempTopQueriesCurrent order by [TotalCPUPercent] desc;

		DROP TABLE #TempTopQueriesPrevious
		DROP TABLE #TempTopQueriesCurrent

		END
