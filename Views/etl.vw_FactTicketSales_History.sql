SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_FactTicketSales_History] AS ( SELECT * FROM dbo.FactTicketSales_History_V2 )
GO
