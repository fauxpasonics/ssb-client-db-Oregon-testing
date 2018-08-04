CREATE ROLE [db_DataUpload]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'db_DataUpload', N'svcssbrp'
GO
