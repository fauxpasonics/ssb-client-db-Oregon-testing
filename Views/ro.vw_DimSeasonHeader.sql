SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ro].[vw_DimSeasonHeader] AS ( SELECT * FROM dbo.DimSeasonHeader_V2 (NOLOCK) )
GO
