SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN



-- TM
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Oregon', @LoadView = '[etl].[vw_Load_DimCustomer_TM]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- SFDC
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Oregon', @LoadView = 'etl.vw_Load_DimCustomer_SFDCAccount', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


--SFDC deletes
UPDATE b
	SET b.IsDeleted = a.IsDeleted
	,deletedate = getdate()
	--SELECT a.IsDeleted
	--SELECT COUNT(*) 
	FROM Oregon_Reporting.ProdCopy.Account a (NOLOCK)
	INNER JOIN dbo.DimCustomer b (NOLOCK) ON a.id = b.SSID AND b.SourceSystem = 'Oregon PC_SFDC Account'
	WHERE a.IsDeleted <> b.IsDeleted


END





GO
