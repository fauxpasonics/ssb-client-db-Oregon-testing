SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[sp_CRMInteg_RecentCustData]
AS

TRUNCATE TABLE etl.CRMProcess_RecentCustData

DECLARE @Client VARCHAR(50)
SET @Client = 'Oregon' --updateme


SELECT x.dimcustomerid, MAX(x.maxtransdate) maxtransdate, x.team
INTO #tmpTicketSales
	FROM (
		
		SELECT dc.DimCustomerID, MAX(dd.calDate) MaxTransDate , @Client Team
		--Select * 
		FROM [ro].[vw_FactTicketSales_All] ft WITH(NOLOCK)
		INNER JOIN dbo.DimDate dd on ft.dimdateID = dd.DimdateID	
		INNER JOIN dbo.[vwDimCustomer_ModAcctId] dc ON dc.SourceSystem = 'TM' AND dc.AccountId = ft.ETL__SSID_TM_acct_id AND dc.CustomerType = 'Primary' 
		WHERE dd.calDate >= DATEADD(YEAR, -5, GETDATE())
		GROUP BY dc.[DimCustomerId]

		UNION ALL

		SELECT dc.DimCustomerId, MAX(donor.pledge_datetime) Maxdonationdate, @Client Team
		FROM dbo.[vwDimCustomer_ModAcctId] dc 
		JOIN ods.TM_Donation donor ON dc.SourceSystem = 'TM' AND dc.AccountId = donor.acct_id AND dc.CustomerType = 'Primary'
		WHERE donor.pledge_datetime >= DATEADD(YEAR, -5, GETDATE())
		GROUP BY dc.[DimCustomerId]



		) x
		GROUP BY x.dimcustomerid, x.team

INSERT INTO etl.CRMProcess_RecentCustData (SSID, MaxTransDate, Team)
SELECT SSID, [MaxTransDate], Team FROM [#tmpTicketSales] a 
INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[DimCustomerId] = [a].[DimCustomerId]


GO
