SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE PROCEDURE [etl].[TM_Load_AttendRealTime]  
( 
	@EventCode VARCHAR(50) 
) 
AS  
BEGIN 
	 
	DECLARE @DimEventId INT, @SSIDEventId INT, @EventDate DATE, @ManifestId INT 
 
	SELECT  
		@DimEventId = DimEventId 
		, @SSIDEventId = SSID_event_id 
		, @EventDate = EventDate 
		, @ManifestId = ManifestId 
	FROM dbo.DimEvent 
	WHERE EventCode = @EventCode 
 
 
	SELECT a.acct_id, a.event_name, a.section_name, a.row_name, a.seat_num, a.gate, a.action_time, a.channel_ind 
	INTO #seat 
	FROM ( 
		SELECT acct_id, event_name, section_name, row_name, seat_num, gate, action_time, channel_ind  
		, ROW_NUMBER() OVER(PARTITION BY event_name, section_name, row_name, seat_num ORDER BY CAST(action_time AS TIME) desc) AS RowRank		 
		FROM stg.TM_AttendRealTime 
		WHERE result_code = 0 AND event_name = @EventCode 
	) a  
	WHERE RowRank = 1 
	 
	CREATE NONCLUSTERED INDEX IX_seat ON #seat (section_name, row_name, seat_num) 
	CREATE NONCLUSTERED INDEX IX_acct_id ON #seat (acct_id) 
 
 
	SELECT DISTINCT a.acct_id, dc.DimCustomerId 
	INTO #Lkp_DimCustomerId 
	FROM #seat a 
	INNER JOIN rpt.vw_DimCustomer dc ON a.acct_id = dc.AccountId AND dc.CustomerType = 'Primary' AND dc.SourceSystem = 'TM' 
 
	CREATE NONCLUSTERED INDEX IX_acct_id ON #Lkp_DimCustomerId (acct_id) 
	 
	SELECT @DimEventId AS DimEventId, ISNULL(ldc.DimCustomerId, -1) DimCustomerId, ISNULL(dst.DimSeatId, -1) DimSeatId 
	, CAST(@EventDate AS DATETIME) + ISNULL(TRY_CAST(a.action_time AS DATETIME), '00:00') ScanDateTime 
	, a.gate ScanGate 
	, a.channel_ind Channel 
	, @SSIDEventId SSID_event_id 
	, a.acct_id SSID_acct_id 
	, dst.SSID_section_id SSID_section_id 
	, dst.SSID_row_id SSID_row_id 
	, a.seat_num SSID_seat	 
	, 'TM' ETL_SourceSystem 
	, GETDATE() ETL_CreatedDate 
	, GETDATE() ETL_UpdatedDate 
	INTO #StgFactAttendance 
	FROM #seat a 
	LEFT OUTER JOIN rpt.vw_DimSeat dst  
		ON 1=1 
		AND dst.ManifestId = @ManifestId 
		AND dst.SectionName = a.section_name  
		AND dst.RowName = a.row_name  
		AND dst.SSID_seat = a.seat_num		 
		AND dst.SourceSystem = 'TM' 
	LEFT OUTER JOIN #Lkp_DimCustomerId ldc ON ldc.acct_id = a.acct_id  
 
	CREATE NONCLUSTERED INDEX IX_LoadKey ON #StgFactAttendance (DimEventId, DimSeatId) 
 
	INSERT INTO dbo.FactAttendance (DimEventId, DimCustomerId, DimSeatId, ScanDateTime, ScanGate, Channel, SSID_event_id, SSID_acct_id, SSID_section_id, SSID_row_id, SSID_seat, ETL_SourceSystem, ETL_CreatedDate, ETL_UpdatedDate) 
	SELECT a.DimEventId, a.DimCustomerId, a.DimSeatId, a.ScanDateTime, a.ScanGate, a.Channel, a.SSID_event_id, a.SSID_acct_id, a.SSID_section_id, a.SSID_row_id, a.SSID_seat, a.ETL_SourceSystem, a.ETL_CreatedDate, a.ETL_UpdatedDate 
	FROM #StgFactAttendance a 
	LEFT OUTER JOIN dbo.FactAttendance f ON f.DimEventId = a.DimEventId AND f.DimSeatId = a.DimSeatId  
	WHERE f.FactAttendanceId IS NULL    
 
 
	UPDATE f 
	SET IsAttended = 1 
		, ScanDateTime = a.ScanDateTime 
		, ScanGate = a.ScanGate 
		, ETL_UpdatedDate = GETDATE() 
	FROM #StgFactAttendance a 
	INNER JOIN dbo.FactInventory f ON a.DimEventId = f.DimEventId 
		AND a.DimSeatId = f.DimSeatId 
	WHERE f.IsAttended = 0 
	 
 
 
END 
 
 
 
 
GO
