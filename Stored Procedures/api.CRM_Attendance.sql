SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Created By: Abbey Meitin
-- Create Date: 2018-04-13
-- Reviewed By: 
-- Reviewed Date: 
-- Description: Ticketmaster Attendance API Viewer
-- =============================================
 
/***** Revision History
 
Abbey Meitin on 4/13/2018 - created using Ducks as example

*****/
CREATE PROCEDURE [api].[CRM_Attendance]




   @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'test' ,
    @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'test' ,
    @DisplayTable INT = 0 ,
    @RowsPerPage INT = 500 ,
    @PageNumber INT = 0




AS
    BEGIN


-- =========================
-- Init vars needed for API
-- =========================

        DECLARE @totalCount INT ,
            @xmlDataNode XML ,
            @recordsInResponse INT ,
            @remainingCount INT ,
            @rootNodeName NVARCHAR(100) ,
            @responseInfoNode NVARCHAR(MAX) ,
            @finalXml XML;

        PRINT 'Acct-' + @SSB_CRMSYSTEM_ACCT_ID;
        PRINT 'Contact-' + @SSB_CRMSYSTEM_CONTACT_ID;

-- ==========================
-- GUIDS
-- ==========================

        DECLARE @GUIDTable TABLE ( GUID VARCHAR(50) );

        IF ( @SSB_CRMSYSTEM_ACCT_ID NOT IN ( 'None', 'Test' ) )
            BEGIN
                INSERT  INTO @GUIDTable
                        ( GUID
                        )
                        SELECT DISTINCT
                                z.SSB_CRMSYSTEM_CONTACT_ID
                        FROM    dbo.vwDimCustomer_ModAcctId z
                        WHERE   z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID;
            END;

        IF ( @SSB_CRMSYSTEM_CONTACT_ID NOT IN ( 'None', 'Test' ) )
            BEGIN
                INSERT  INTO @GUIDTable
                        ( GUID
                        )
                        SELECT  @SSB_CRMSYSTEM_CONTACT_ID;
            END;

-- ============================
-- Base Table Set
-- ============================

        DECLARE @baseData TABLE
            (
              Season_Name NVARCHAR(255) ,
              Event_Code NVARCHAR(255) ,
              Event_Name NVARCHAR(255) ,
              Event_Date DATE ,
              Event_Time TIME ,
              Section_Name NVARCHAR(50) ,
              Row_Name NVARCHAR(50) ,
              Seat NVARCHAR(50) ,
              Scan_Time TIME ,
              Game_Scan_Time_Difference NVARCHAR(255) ,
              Scan_Gate NVARCHAR(255) ,
              IsAttended BIT
            );

-- ==============================
-- Procedure
-- ==============================

		-- Pull most recent activity for each event/seat combination from FactTicketActivity --
		SELECT f.DimEventId, f.DimSeatId_Start, MAX(f.ETL__SSID_TM_add_datetime) TM_add_datetime
		INTO #MostRecentActivity
		FROM dbo.FactTicketActivity_V2 f
		WHERE f.TM_activity IN ('ES', 'F', 'HF', 'HR', 'X')
		GROUP BY f.DimEventId, f.DimSeatId_Start


		-- Pull FactTicketActivity records that match most recent activity --
		SELECT f.FactTicketActivityId, f.DimTicketCustomerId, f.DimTicketCustomerId_Recipient
		INTO #FactTicketActivity
		FROM dbo.FactTicketActivity_V2 f
		JOIN #MostRecentActivity m
			ON f.DimEventId = m.DimEventId
			AND f.DimSeatId_Start = m.DimSeatId_Start
		WHERE f.TM_activity IN ('ES', 'F', 'HF', 'HR', 'X')


		SELECT FactTicketSalesId, DimTicketCustomerId
		INTO #FactTicketSales
		FROM dbo.FactTicketSales_V2


        SELECT 
                Season_Name ,
                Event_Code ,
                Event_Name ,
                Event_Date ,
                Event_Time ,
                Section_Name ,
                Row_Name ,
                Seat ,
                Scan_Time ,
                Game_Scan_Time_Difference ,
                Scan_Gate ,
                IsAttended
        INTO #tmpbase
        FROM    ( SELECT    dc.DimCustomerId AS AttendedDimCustomerID,
							/*CASE WHEN ISNULL(dimcustomer_buyer.DimCustomerId, '') NOT IN ('','-1') THEN dimcustomer_buyer.DimCustomerId
								ELSE dimcustomer_sold.dimcustomerID END AS AttendedDimcustomerID ,*/
                            DimSeason.SeasonName AS Season_Name ,
                            DimEvent.EventCode AS Event_Code ,
                            DimEvent.EventName AS Event_Name ,
                            DimEvent.EventDate AS Event_Date ,
                            DimEvent.EventTime Event_Time ,
                            DimSeat.SectionName AS Section_Name ,
                            DimSeat.RowName AS Row_Name ,
                            DimSeat.Seat AS Seat ,
                            CAST(FactAttendance.ScanDateTime AS TIME) Scan_Time ,
                            DATEDIFF(MINUTE, DimEvent.EventTime,
                                     CAST(FactAttendance.ScanDateTime AS TIME)) Game_Scan_Time_Difference ,
                            scangate.ScanGateCode AS Scan_Gate, 
                            CASE WHEN FactAttendance.FactAttendanceId IS null THEN 0 ELSE 1 END AS IsAttended --hide from api view on front end		
				--SELECT COUNT(*)
				  FROM      dbo.FactInventory_V2 fi (NOLOCK)
				  			INNER JOIN #FactTicketSales fts (NOLOCK) ON fts.FactTicketSalesId = fi.FactTicketSalesId
                            INNER JOIN dbo.DimEvent_V2 DimEvent WITH ( NOLOCK ) ON DimEvent.DimEventId = fi.DimEventId
                            INNER JOIN dbo.DimSeason_V2 DimSeason WITH ( NOLOCK ) ON DimSeason.DimSeasonId = DimEvent.DimSeasonId
                            INNER JOIN dbo.DimSeat_V2 DimSeat WITH ( NOLOCK ) ON DimSeat.DimSeatId = fi.DimSeatId
                            LEFT JOIN dbo.DimEventHeader_V2 DimEventHeader WITH ( NOLOCK ) ON DimEventHeader.DimEventHeaderId = DimEvent.DimEventHeaderId
                            LEFT JOIN dbo.DimSeasonHeader_V2 DimSeasonHeader  WITH ( NOLOCK ) ON DimSeasonHeader.DimSeasonHeaderId = DimEventHeader.DimSeasonHeaderId
							Left JOIN dbo.FactAttendance_V2 FactAttendance WITH (NOLOCK) ON factattendance.FactAttendanceId = fi.FactAttendanceId
							INNER JOIN dbo.DimScanGate_V2 scangate WITH (NOLOCK) ON scangate.dimscangateID = factattendance.dimscangateID
							JOIN dbo.DimTicketCustomer_V2 dtc (NOLOCK) ON dtc.DimTicketCustomerId = fts.DimTicketCustomerId
							JOIN dbo.DimCustomer dc (NOLOCK) ON dtc.ETL__SSID_TM_acct_id = dc.AccountId AND dc.SourceSystem = 'TM' AND dc.CustomerType = 'Primary'
							/*
							-- Resold --
							INNER JOIN #FactTicketActivity factticketactivity_sold WITH (NOLOCK) ON factticketactivity_sold.DimTicketCustomerId = FactAttendance.DimTicketCustomerId
							INNER JOIN dbo.DimTicketCustomer_V2 dimticketcustomer_sold WITH (NOLOCK) ON dimticketcustomer_sold.DimTicketCustomerId = Factticketactivity_sold.DimTicketCustomerId
							INNER JOIN dbo.DimCustomer dimcustomer_sold WITH (NOLOCK) ON dimcustomer_sold.SourceSystem =dimticketcustomer_sold.ETL__SourceSystem AND dimcustomer_sold.AccountId = dimticketcustomer_sold.ETL__SSID_TM_acct_id AND dimcustomer_sold.CustomerType = 'primary'
							-- Buyer --
							LEFT JOIN dbo.DimTicketCustomer_V2 dimticketcustomer_buyer WITH (NOLOCK)
								ON dimticketcustomer_buyer.DimTicketCustomerId = factticketactivity_sold.DimTicketCustomerId_recipient
							left JOIN dbo.DimCustomer dimcustomer_buyer WITH (NOLOCK)
								ON dimcustomer_buyer.SourceSystem =dimticketcustomer_buyer.ETL__SourceSystem AND dimcustomer_buyer.SSID = dimticketcustomer_buyer.ETL__SSID
							*/
				  WHERE     DimEvent.EventDate <= CAST(GETDATE() + 1 AS DATE)
                ) x
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.DimCustomerId = x.AttendedDimcustomerID
                                                              AND DimCustomer.CustomerType = 'Primary'
                                                              AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = DimCustomer.DimCustomerId

		WHERE   ssbid.SSB_CRMSYSTEM_CONTACT_ID IN (
               SELECT GUID FROM @GUIDTable );




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
        FROM    #tmpbase AS c;
-- =========================================
-- API Loading
-- =========================================

-- Load base data

        INSERT  INTO @baseData
                ( Season_Name ,
                  Event_Code ,
                  Event_Name ,
                  Event_Date ,
                  Event_Time ,
                  Section_Name ,
                  Row_Name ,
                  Seat ,
                  Scan_Time ,
                  Game_Scan_Time_Difference ,
                  Scan_Gate ,
                  IsAttended
                )
                SELECT  ISNULL(Season_Name, '') Season_Name ,
                        ISNULL(Event_Code, '') Event_Code ,
                        ISNULL(Event_Name, '') Event_Name ,
                        ISNULL(Event_Date, '') Event_Date ,
                        ISNULL(Event_Time, '') Event_Time ,
                        ISNULL(Section_Name, '') Section_Name ,
                        ISNULL(Row_Name, '') Row_Name ,
                        ISNULL(Seat, '') Seat ,
                        ISNULL(Scan_Time, '') Scan_Time ,
        --( CASE WHEN IsAttended = 1 THEN Game_Scan_Time_Difference
        --       ELSE NULL
        --  END ) True_GameScanDiff ,
                        ISNULL(CAST(LTRIM(RTRIM(STR(ABS(CASE WHEN IsAttended = 1
                                                             THEN Game_Scan_Time_Difference
                                                             ELSE NULL
                                                        END)))) + ' minute'
                               + CASE WHEN Game_Scan_Time_Difference = 0
                                      THEN ''
                                      ELSE 's'
                                 END
                               + CASE WHEN Game_Scan_Time_Difference < 0
                                      THEN ' early'
                                      ELSE ' late'
                                 END AS VARCHAR(50)), '') Game_Scan_Time_Difference ,
                        ISNULL(Scan_Gate, '') Scan_Gate ,
                        ISNULL(IsAttended, '') IsAttended
                FROM    #tmpbase
                ORDER BY Event_Date ,
                        Row_Name ASC ,
                        Seat ASC
                        OFFSET ( @PageNumber ) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY;

-- DROP TABLE #tmpParent

-- Pull counts
        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;


        SET @xmlDataNode = ( SELECT p.Season_Name ,
                                    p.Event_Code ,
                                    p.Event_Name ,
                                    p.Event_Date ,
                                    p.Event_Time ,
                                    p.Section_Name ,
                                    p.Row_Name ,
                                    p.Seat ,
                                    p.Scan_Time ,
                                    p.Game_Scan_Time_Difference ,
                                    p.Scan_Gate ,
                                    p.IsAttended
                             FROM   @baseData p
                             ORDER BY p.Season_Name DESC
                           FOR
                             XML PATH('Parent') ,
                                 ROOT('Parents')
                           );

        SET @rootNodeName = 'Parents';

-- Calculate remaining count
        SET @remainingCount = @totalCount - ( @RowsPerPage * ( @PageNumber + 1 ) );
        IF @remainingCount < 0
            BEGIN
                SET @remainingCount = 0;
            END;

-- Create response info node
        SET @responseInfoNode = ( '<ResponseInfo>' + '<TotalCount>'
                                  + CAST(@totalCount AS NVARCHAR(20))
                                  + '</TotalCount>' + '<RemainingCount>'
                                  + CAST(@remainingCount AS NVARCHAR(20))
                                  + '</RemainingCount>'
                                  + '<RecordsInResponse>'
                                  + CAST(@recordsInResponse AS NVARCHAR(20))
                                  + '</RecordsInResponse>'
                                  + '<PagedResponse>true</PagedResponse>'
                                  + '<RowsPerPage>'
                                  + CAST(@RowsPerPage AS NVARCHAR(20))
                                  + '</RowsPerPage>' + '<PageNumber>'
                                  + CAST(@PageNumber AS NVARCHAR(20))
                                  + '</PageNumber>' + '<RootNodeName>'
                                  + @rootNodeName + '</RootNodeName>'
                                  + '</ResponseInfo>' );

        PRINT @responseInfoNode;
	
-- Wrap response info and data, then return	
        IF @xmlDataNode IS NULL
            BEGIN
                SET @xmlDataNode = '<' + @rootNodeName + ' />'; 
            END;
		
        SET @finalXml = '<Root>' + @responseInfoNode
            + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>';

        IF @DisplayTable = 1
            SELECT  *
            FROM    #tmpbase;

        --IF @DisplayTable = 0
            SELECT  CAST(@finalXml AS XML);

        DROP TABLE #tmpbase;

        
    END;
























GO
