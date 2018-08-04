SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_KeyAccounts]
AS 

/*
KEEP THE column structure the same, pulling back ssb_crmsystem_contact_ids as the SSBID for records that need to be withheld. 
Also add the bit for the final 3 columns to denote whether the record should be witheld from Standard, Custom, and Merging.
Having a value of 1 will hold the record out of these updates.
*/

SELECT dimcustomerid, ssbid, ssid, MAX(Withhold_StandardUpdates) Withhold_StandardUpdates, MAX(Withhold_CustomUpdate) Withhold_CustomUpdate, MAX(Withhold_Merging) Withhold_Merging
FROM (

SELECT NULL AS DimCustomerId, NULL AS SSBID, NULL as ssid,  0 AS Withhold_StandardUpdates, 0 AS Withhold_CustomUpdate, 1 AS Withhold_Merging 
) z

GROUP BY  dimcustomerid, ssbid, ssid



GO
