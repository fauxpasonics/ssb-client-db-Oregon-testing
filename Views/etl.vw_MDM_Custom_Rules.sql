SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_MDM_Custom_Rules]
 AS 

SELECT dc.dimcustomerid
		, Tix.LastPurchase_STH
		, Tix.LastPurchase
		, Don.LastDonation
FROM [dbo].[vwDimCustomer_ModAcctId] dc 

	LEFT JOIN ( SELECT dc.dimcustomerid
						 ,MAX(CASE WHEN plan_event_name IN ('17FBS', '18SBS', '17WBS', '17MBS', '17VBS') THEN upd_datetime END) LastPurchase_STH
						 ,MAX(upd_datetime) LastPurchase
				FROM [ods].[TM_Ticket] fts (NOLOCK)
				INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc 
					ON dc.SourceSystem = 'TM' and dc.AccountId = fts.acct_id and CustomerType = 'Primary'
				GROUP BY DimCustomerId
				) Tix ON dc.DimCustomerId = Tix.DimCustomerId

	LEFT JOIN ( SELECT dc.dimcustomerid
						 ,MAX(donation_paid_datetime) LastDonation
				FROM [ods].[TM_Donation] don (NOLOCK)
				INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc 
					ON dc.SourceSystem = 'TM' and dc.AccountId = don.acct_id and CustomerType = 'Primary'
				GROUP BY DimCustomerId
				
				) Don  ON dc.DimCustomerId = Don.DimCustomerId
WHERE dc.SourceSystem = 'TM' 
AND CustomerType = 'Primary'



GO
