SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create VIEW [etl].[vwCRMProcess_SeasonTicketHolders]
AS

SELECT DISTINCT dc.SSID
, NULL SeasonYear
, NULL SeasonYr
FROM   [ro].[vw_FactTicketSalesBase] fts
INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc on dc.SourceSystem = 'TM' AND dc.AccountId = fts.TicketingAccountId AND dc.CustomerType = 'Primary'
WHERE 0=1

GO
