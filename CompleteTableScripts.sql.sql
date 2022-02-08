USE [MDB]
GO

/****** Object:  Table [Monitor].[DBCPUStats]    Script Date: 13-01-2021 23:32:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Monitor].[DBCPUStats](
	[ServerName] [varchar](50) NULL,
	[CPURank] [numeric](18, 0) NULL,
	[DatabaseName] [varchar](50) NULL,
	[CPUTimems] [numeric](18, 0) NULL,
	[CPUPercent] [float] NULL,
	[CreatedOn] [datetime] NULL,
	[DBMode] [varchar](10) NULL
) ON [PRIMARY]
GO


USE [MDB]
GO

/****** Object:  Table [Monitor].[DBSizeMonitortab]    Script Date: 13-01-2021 23:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Monitor].[DBSizeMonitortab](
	[name] [varchar](50) NULL,
	[recovery_model_desc] [varchar](20) NULL,
	[total_size_GB] [decimal](18, 3) NULL,
	[data_size_GB] [decimal](18, 3) NULL,
	[data_used_size_GB] [decimal](18, 3) NULL,
	[log_size_GB] [decimal](18, 3) NULL,
	[log_used_size_GB] [decimal](18, 3) NULL,
	[fullbkp_last_date] [datetime] NULL,
	[logbkp_last_date] [datetime] NULL,
	[DBMode] [varchar](20) NULL
) ON [PRIMARY]
GO


GO


USE [MDB]
GO

/****** Object:  Table [Monitor].[DatabaseIOPS]    Script Date: 13-01-2021 23:33:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Monitor].[DatabaseIOPS](
	[ServerName] [varchar](30) NULL,
	[DatabaseName] [varchar](50) NULL,
	[TotalMB] [decimal](30, 3) NULL,
	[TotalMBRead] [decimal](30, 3) NULL,
	[TotalMBWritten] [decimal](30, 3) NULL,
	[DataFileOrLogFile] [varchar](20) NULL,
	[I/O] [decimal](30, 3) NULL,
	[CreatedOn] [datetime] NULL,
	[DBMode] [varchar](20) NULL
) ON [PRIMARY]
GO




USE [MDB]
GO

/****** Object:  Table [Monitor].[TopExpensiveQueries]    Script Date: 13-01-2021 23:34:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Monitor].[TopExpensiveQueries](
	[ServerName] [varchar](20) NULL,
	[DatabaseName] [varchar](100) NULL,
	[SchemaName] [varchar](50) NULL,
	[ObjectName] [varchar](max) NULL,
	[QueryText] [varchar](max) NULL,
	[TotalExecutions] [bigint] NULL,
	[TotalExecutionsPercent] [decimal](30, 3) NULL,
	[TotalDurationSec] [decimal](30, 3) NULL,
	[TotalDurationPercent] [decimal](30, 3) NULL,
	[AverageDurationms] [decimal](30, 3) NULL,
	[TotalCPUPercent] [decimal](30, 3) NULL,
	[AverageCPUms] [decimal](30, 3) NULL,
	[TotalLogicalReads] [bigint] NULL,
	[TotalLogicalReadsPercent] [decimal](30, 3) NULL,
	[AverageLogicalReadsPercent] [decimal](30, 3) NULL,
	[TotalCPU] [decimal](30, 3) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


