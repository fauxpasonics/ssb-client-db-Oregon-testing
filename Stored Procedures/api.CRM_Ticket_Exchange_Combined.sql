SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










-- =============================================
-- Created By: Abbey Meitin
-- Create Date: 2018-04-13
-- Reviewed By: 
-- Reviewed Date: 
-- Description: Ticketmaster Exchange API Viewer
-- =============================================
 
/***** Revision History
 
Abbey Meitin on 4/13/2018 - created using Ducks as example

*****/


CREATE PROCEDURE [api].[CRM_Ticket_Exchange_Combined] 
    @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	@DisplayTable INT = 0,
	@RowsPerPage  INT = 500, @PageNumber   INT = 0
WITH RECOMPILE
AS 

BEGIN
/*
DECLARE @SSB_CRMSYSTEM_CONTACT_ID AS VARCHAR(50), @RowsPerPage  INT = 500, @PageNumber   INT = 0, @DisplayTable INT = 1
SET @SSB_CRMSYSTEM_CONTACT_ID = '94B615C4-C182-409B-82C9-0A12BB879567'
--EXEC [api].[CRM_Ticket_Exchange_Originator] @SSB_CRMSYSTEM_CONTACT_ID = '817086D0-27F0-40D2-84F0-41D9626B1E30', @DisplayTable = 0
*/
-- =========================================
-- Initial Variables for API
-- =========================================
DECLARE @totalCount     INT,
	@xmlDataNode        XML,
	@recordsInResponse  INT,
	@remainingCount     INT,
	@rootNodeName       NVARCHAR(100),
	@responseInfoNode   NVARCHAR(MAX),
	@finalXml           XML

PRINT 'Acct-' + @SSB_CRMSYSTEM_ACCT_ID
PRINT 'Contact-' + @SSB_CRMSYSTEM_CONTACT_ID

-- =========================================
-- GUID Table for GUIDS
-- =========================================
DECLARE @GUIDTable TABLE (
GUID VARCHAR(50)
)

IF (@SSB_CRMSYSTEM_ACCT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT DISTINCT z.SSB_CRMSYSTEM_CONTACT_ID
		FROM dbo.vwDimCustomer_ModAcctId z 
		WHERE z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID
END

IF (@SSB_CRMSYSTEM_CONTACT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT @SSB_CRMSYSTEM_CONTACT_ID
END

-- =========================================
-- Base Table Set
-- =========================================

DECLARE @baseData TABLE
	( Acct_ID NVARCHAR(255)
	, Activity_Type NVARCHAR(255)
	, Activity_Name NVARCHAR(255)
	, Transaction_Date DATE
	, Season_Year INT
	, Event_Code NVARCHAR(100)
	, Event_Name NVARCHAR(255)
	, Event_Time TIME
	, Event_Date DATE
	, Section_Name INT
	, Row_Name NVARCHAR(255)
	, Seat_Block NVARCHAR(255)
	, Orig_Purchase_Price NUMERIC
	, TE_Price NUMERIC
	, TE_Price_Difference NUMERIC)

-- =========================================
-- Procedure
-- =========================================

        SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
			  , DimCustomer.AccountId AS Archtics_Acct_Id
			  , Tex.activity AS Activity
			  , Tex.activity_name AS Activity_Name
			  , CAST(Tex.add_datetime AS DATE) AS Transaction_Date 
              , Tex.season_year AS Season_Year
              , Tex.event_name AS Event_Code
			  , Event.Team AS Event_Name 
              , Tex.event_time AS Event_Time
              , Tex.event_date AS Event_Date
              , Tex.section_name AS Section_Name
              , Tex.row_name AS Row_Name
              , CONVERT(NVARCHAR,Tex.seat_num) +':'+ CONVERT(NVARCHAR,Tex.last_seat) AS Seat_Block
              , Tex.num_seats AS Qty_Seat
              , CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					CAST(Tex.Orig_purchase_price AS NUMERIC (18,2) )  * Tex.num_seats END AS Orig_purchase_price
              , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END AS TE_Purchase_Price
			  , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END - CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					  CAST(Tex.Orig_purchase_price AS NUMERIC) * Tex.num_seats END  AS TE_Price_Difference
			  , tex.assoc_acct_id AS Recipient_Account_Id
			  , 'Sale' AS TE_Activity_Type
		INTO #tmpBase
        FROM    ods.TM_Tex Tex
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.AccountId = Tex.acct_id AND DimCustomer.CustomerType = 'Primary' AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = DimCustomer.DimCustomerId
				INNER JOIN ods.TM_Evnt Event WITH ( NOLOCK ) ON Event.Event_id = Tex.event_id
        WHERE   Tex.activity_name = 'TE Resale'
			AND ssbid.SSB_CRMSYSTEM_CONTACT_ID IN (SELECT GUID FROM @GUIDTable)
			AND tex.event_date >= DATEADD(YEAR, -2, GETDATE()+120)
		UNION ALL
		SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
			  , DimCustomer.AccountId AS Archtics_Acct_Id
			  , Tex.activity AS Activity
			  , Tex.activity_name AS Activity_Name
			  , CAST(Tex.add_datetime AS DATE) AS Transaction_Date 
              , Tex.season_year AS Season_Year
              , Tex.event_name AS Event_Code
			  , Event.Team AS Event_Name 
              , Tex.event_time AS Event_Time
              , Tex.event_date AS Event_Date
              , Tex.section_name AS Section_Name
              , Tex.row_name AS Row_Name
              , CONVERT(NVARCHAR,Tex.seat_num) +':'+ CONVERT(NVARCHAR,Tex.last_seat) AS Seat_Block
              , Tex.num_seats AS Qty_Seat
              , CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					CAST(Tex.Orig_purchase_price AS NUMERIC (18,2) )  * Tex.num_seats END AS Orig_purchase_price
              , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END AS TE_Purchase_Price
			  , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END - CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					  CAST(Tex.Orig_purchase_price AS NUMERIC) * Tex.num_seats END  AS TE_Price_Difference
			  , Tex.owner_acct_id AS Seller_Account_Id
			  , 'Purchase' AS TE_Activity_Type
        FROM    ods.TM_Tex Tex
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.AccountId = Tex.assoc_acct_id AND DimCustomer.CustomerType = 'Primary' AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = DimCustomer.DimCustomerId
				INNER JOIN ods.TM_Evnt Event WITH ( NOLOCK ) ON Event.Event_id = Tex.event_id
        WHERE   Activity_Name = 'TE Resale'
			AND ssbid.SSB_CRMSYSTEM_CONTACT_ID IN (SELECT GUID FROM @GUIDTable)
			AND tex.event_date >= DATEADD(YEAR, -2, GETDATE()+120)


-- =========================================
-- API Pagination
-- =========================================
-- Cap returned results at 1000

        IF @RowsPerPage > 1000
            BEGIN

                SET @RowsPerPage = 1000;

            END;

-- Pull total count

        SELECT  @totalCount = COUNT(*)
        FROM    #tmpBase AS c;


-- =========================================
-- API Loading
-- =========================================

-- Load base data
INSERT INTO @baseData
        ( Acct_ID ,
		  Activity_Type ,
          Activity_Name ,
          Transaction_Date ,
          Season_Year ,
          Event_Code ,
          Event_Name ,
          Event_Time ,
          Event_Date ,
          Section_Name ,
          Row_Name ,
          Seat_Block ,
          Orig_Purchase_Price ,
          TE_Price ,
          TE_Price_Difference
        )
SELECT ISNULL(Archtics_Acct_Id,'') AS Acct_ID
, ISNULL(TE_Activity_Type,'') AS Activity_Type
, ISNULL(Activity_Name,'') AS Activity_Name
, ISNULL(Transaction_Date,'') AS Transaction_Date
, ISNULL(Season_Year,9999) AS Season_Year
, ISNULL(Event_Code,'') AS Event_Code
, ISNULL(Event_Name,'') AS Event_Name
, ISNULL(Event_Time,'') AS Event_Time
, ISNULL(Event_Date,'') AS Event_Date
, ISNULL(Section_Name,'') AS Section_Name
, ISNULL(Row_Name, '') AS Row_name
, ISNULL(Seat_Block, '') AS Seat_Block
, ISNULL(Orig_Purchase_Price,0) AS Orig_Purchase_Price
, ISNULL(TE_Purchase_Price,0) AS TE_Price
, ISNULL(TE_Price_Difference, 0) AS TE_Price_Difference
FROM #tmpBase
ORDER BY Season_Year DESC, Transaction_Date Desc
OFFSET (@PageNumber) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY

-- Set records in response

        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;
-- Create XML response data node

SET @xmlDataNode = (
		SELECT Acct_ID ,
			   Activity_Type ,
               Activity_Name ,
               Transaction_Date ,
               Season_Year ,
               Event_Code ,
               Event_Name ,
               Event_Time ,
               Event_Date ,
               Section_Name ,
               Row_Name ,
               Seat_Block ,
               Orig_Purchase_Price ,
               TE_Price ,
               TE_Price_Difference               
		FROM @baseData
		ORDER BY Season_Year DESC
		FOR XML PATH ('Parent'), ROOT('Parents'))

SET @rootNodeName = 'Parents'


-- Calculate remaining count
SET @remainingCount = @totalCount - (@RowsPerPage * (@PageNumber + 1))
IF @remainingCount < 0
BEGIN
	SET @remainingCount = 0
END


-- Create response info node
SET @responseInfoNode = ('<ResponseInfo>'
	+ '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
	+ '<RemainingCount>' + CAST(@remainingCount AS NVARCHAR(20)) + '</RemainingCount>'
	+ '<RecordsInResponse>' + CAST(@recordsInResponse AS NVARCHAR(20)) + '</RecordsInResponse>'
	+ '<PagedResponse>true</PagedResponse>'
	+ '<RowsPerPage>' + CAST(@RowsPerPage AS NVARCHAR(20)) + '</RowsPerPage>'
	+ '<PageNumber>' + CAST(@PageNumber AS NVARCHAR(20)) + '</PageNumber>'
	+ '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
	+ '</ResponseInfo>')

	
-- Wrap response info and data, then return	
IF @xmlDataNode IS NULL
BEGIN
	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
END
		
SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'


SELECT CAST(@finalXml AS XML)

IF @DisplayTable = 1
	BEGIN
    SELECT * FROM @baseData
	END
    


--DROP TABLE #tmpBase

--DROP TABLE [#XMLFriendly]
END

















GO
