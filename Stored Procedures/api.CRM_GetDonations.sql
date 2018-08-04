SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [api].[CRM_GetDonations]
(
      @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	  @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	  @DisplayTable INT = 0,
	  @RowsPerPage  INT = 10000, 
	  @PageNumber   INT = 0
)
WITH RECOMPILE
AS

--BEGIN



-- EXEC api.GetDonations @SSB_CRMSYSTEM_CONTACT_ID = 'B0BD7036-3A5D-488F-BAD4-D9FB49DB726B', @RowsPerPage = 500, @PageNumber = 0, @DisplayTable = 0

--SET @SSB_CRMSYSTEM_CONTACT_ID = CASE WHEN @SSB_CRMSYSTEM_CONTACT_ID IN ('None','Test') THEN @SSB_CRMSYSTEM_ACCT_ID ELSE @SSB_CRMSYSTEM_CONTACT_ID END


----Declare 	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'F4ACEE63-2849-44DB-B71F-54948DF7F4D8',
----@SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
----	@RowsPerPage  INT = 10000,
----	@PageNumber   INT = 0,
----	@DisplayTable int = 0


--DECLARE @PatronID VARCHAR(MAX)

---- Init vars needed for API
--DECLARE @totalCount         INT,
--	@xmlDataNode        XML,
--	@recordsInResponse  INT,
--	@remainingCount     INT,
--	@rootNodeName       NVARCHAR(100),
--	@responseInfoNode   NVARCHAR(MAX),
--	@finalXml           XML

-- --Cap returned results at 1000
--IF @RowsPerPage > 1000
--BEGIN
--	SET @RowsPerPage = 1000;
--END

--SELECT DimCustomerId INTO #CustomerIDs
--FROM dbo.[vwDimCustomer_ModAcctId] dc 
--WHERE ISNULL(dc.SSB_CRMSYSTEM_ACCT_ID, dc.SSB_CRMSYSTEM_CONTACT_ID)  = @SSB_CRMSYSTEM_ACCT_ID
--OR ISNULL(dc.SSB_CRMSYSTEM_ACCT_ID, dc.SSB_CRMSYSTEM_CONTACT_ID)  = @SSB_CRMSYSTEM_CONTACT_ID
----'4E361DD3-6DF1-4C15-ACAE-1A4692086575'

--IF @@ROWCOUNT = 0
--BEGIN
--	INSERT INTO #CustomerIDs
--	SELECT dimcustomerid FROM mdm.SSB_ID_History a (NOLOCK)
--	INNER JOIN dbo.[vwDimCustomer_ModAcctId] b 
--	ON a.ssid = b.ssid AND a.sourcesystem = b.SourceSystem
--	WHERE ISNULL(a.SSB_CRMSYSTEM_ACCT_ID, a.SSB_CRMSYSTEM_CONTACT_ID) = @SSB_CRMSYSTEM_ACCT_ID
--	OR ISNULL(a.SSB_CRMSYSTEM_ACCT_ID, a.SSB_CRMSYSTEM_CONTACT_ID)  = @SSB_CRMSYSTEM_CONTACT_ID
--	;

--END

----SELECT * FROM [#CustomerIDs]


--SELECT DISTINCT a.[Accountid] 
--INTO #PatronList
--FROM dbo.[vwDimCustomer_ModAcctId] (nolock) a
--INNER JOIN #CustomerIDs b ON a.DimCustomerId = b.DimCustomerId
--WHERE a.SourceSystem = 'TM'


--SET @PatronID = (SELECT SUBSTRING(
--(SELECT CONCAT(',',s.accountID)
--FROM [#PatronList] s
--ORDER BY s.Accountid
--FOR XML PATH('')),2,200000) AS CSV)

--SELECT DISTINCT
--	'Oregon' AS Team
--	, don.acct_id AS Account
--	, CAST(don.pledge_datetime AS DATE) AS Pledge_Date
--	, don.order_num AS Order_Number
--	, don.order_line_item AS Order_Line_Item
--	, don.donation_type_name AS Donation_Type
--	, don.fund_name AS Fund_Name
--	, don.fund_desc AS Fund_Description
--	, don.drive_year AS Drive_Year
--	, don.solicitation_name AS Solicitation_Name
--	, don.solicitation_category_name AS Solicitation_Category
--	, don.contact_type AS Contact_Type
--	, don.original_pledge_amount AS Original_Pledge_Amount
--	, don.pledge_amount AS Pledge_Amount
--	, don.total_received_amount AS Total_Received_Amount
--	, don.owed_amount AS Owed_Amount
--	, don.external_paid_amount AS External_Paid_Amount
--INTO #tmpA
--FROM ods.TM_Donation don (NOLOCK)
--WHERE don.acct_id IN (SELECT * FROM #PatronList)



-- SET @totalCount = @@ROWCOUNT
 
--SELECT Account
--,Drive_Year 
--,Convert(varchar(50),CAST(Pledge_Date AS DATE),101) _Date
--, Order_Number Trans_ID
--, Original_Pledge_Amount
--, Pledge_Amount
--, Total_Received_Amount
--, Owed_Amount
--, Donation_Type 
--, Fund_Description
--INTO #ReturnSet
--FROM #tmpA a
--ORDER BY Pledge_Date DESC
--OFFSET (@PageNumber) * @RowsPerPage ROWS
--FETCH NEXT @RowsPerPage ROWS ONLY
----DROP TABLE #ReturnSet
----SELECT * FROM [#ReturnSet]

--SET @recordsInResponse  = (SELECT COUNT(*) FROM #ReturnSet)

--SELECT Drive_Year
--, SUM(Pledge_Amount) as Pledge_Amount_Total 
--, SUM(Owed_Amount) as Owed_Amount_Total
--, SUM(Total_Received_Amount) as Received_Amount_Total
--INTO #TopGroup
--FROM #tmpA
--GROUP BY Drive_Year

--SELECT Drive_Year
--, Fund_Description
--, SUM(Pledge_Amount) as Pledge_Amount_Total 
--, SUM(Owed_Amount) as Owed_Amount_Total
--, SUM(Total_Received_Amount) as Received_Amount_Total
--INTO #SecGroup
--FROM #tmpA
--GROUP BY Drive_Year, Fund_Description

---- Create XML response data node
--SET @xmlDataNode = (
----SELECT [ParentValue] Season , [ParentLabel] AS [Season_Name]
----, CASE WHEN SIGN(ISNULL([AggregateValue] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue])), '0.00') AS [Order_Value],
----CASE WHEN SIGN(ISNULL([AggregateValue1] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue1])), '0.00') AS [Order_Balance],
--SELECT Drive_Year
--	, CASE WHEN SIGN(ISNULL(p.Pledge_Amount_Total ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( [Pledge_Amount_Total])), '0.00') Pledge_Amount
--	, CASE WHEN SIGN(ISNULL(p.[Received_Amount_Total] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( [Received_Amount_Total])), '0.00') Total_Received_Amount
--	, CASE WHEN SIGN(ISNULL(p.[Owed_Amount_Total] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( [Owed_Amount_Total])), '0.00') Owed_Amount
--, (
--	SELECT Drive_Year
--	, Fund_Description
--	, CASE WHEN SIGN(ISNULL(c.Pledge_Amount_Total ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(c.[Pledge_Amount_Total])), '0.00') Pledge_Amount
--	, CASE WHEN SIGN(ISNULL(c.[Received_Amount_Total] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( c.[Received_Amount_Total])), '0.00') Total_Received_Amount
--	, CASE WHEN SIGN(ISNULL(c.[Owed_Amount_Total] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( c.[Owed_Amount_Total])), '0.00') Owed_Amount
--, (
--	SELECT Account
--	, _Date
--	, Donation_Type
--	, CASE WHEN SIGN(ISNULL(Pledge_Amount ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( [Pledge_Amount])), '0.00') Pledge_Amount
--	, CASE WHEN SIGN(ISNULL([Total_Received_Amount] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( [Total_Received_Amount])), '0.00') Total_Received_Amount
--	, CASE WHEN SIGN(ISNULL([Owed_Amount] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( [Owed_Amount])), '0.00') Owed_Amount
--	FROM #ReturnSet i
--		WHERE i.Drive_Year = c.Drive_Year AND i.Fund_Description = c.Fund_Description
--		ORDER BY Account ASC, _Date ASC, Donation_Type ASC
--		FOR XML PATH ('Infant'), TYPE
--		) AS 'Infants'
--	FROM #SecGroup c
--	WHERE c.Drive_Year = p.Drive_Year
--	ORDER BY Fund_Description ASC
--	FOR XML PATH ('Child'), TYPE
--	) AS 'Children'
--FROM #TopGroup AS p  
--ORDER BY Drive_Year DESC
--FOR XML PATH ('Parent'), ROOT('Parents')
--)


--SET @rootNodeName = 'Parents'

---- Calculate remaining count
--SET @remainingCount = @totalCount - (@RowsPerPage * (@PageNumber + 1))
--IF @remainingCount < 0
--BEGIN
--	SET @remainingCount = 0
--END

---- Wrap response info and data, then return	
--IF @xmlDataNode IS NULL
--BEGIN
--	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
--END


---- Create response info node
--SET @responseInfoNode = ('<ResponseInfo>'
--	+ '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
--	+ '<RemainingCount>' + CAST(@remainingCount AS NVARCHAR(20)) + '</RemainingCount>'
--	+ '<RecordsInResponse>' + CAST(@recordsInResponse AS NVARCHAR(20)) + '</RecordsInResponse>'
--	+ '<PagedResponse>true</PagedResponse>'
--	+ '<RowsPerPage>' + CAST(@RowsPerPage AS NVARCHAR(20)) + '</RowsPerPage>'
--	+ '<PageNumber>' + CAST(@PageNumber AS NVARCHAR(20)) + '</PageNumber>'
--	+ '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
--	+ '</ResponseInfo>')

--SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

--IF ISNULL(@DisplayTable,0) = 0
--BEGIN
--SELECT CAST(@finalXml AS XML)
--END
--ELSE 
--BEGIN
--SELECT * FROM [#ReturnSet]
--END

--DROP TABLE [#tmpA]
--DROP TABLE [#ReturnSet]
--DROP TABLE [#CustomerIDs]
--DROP TABLE [#PatronList]
--DROP TABLE [#TopGroup]
--DROP TABLE [#SecGroup]

--END

GO
