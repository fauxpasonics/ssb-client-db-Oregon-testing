IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SSBINFO\BI Developers')
CREATE LOGIN [SSBINFO\BI Developers] FROM WINDOWS
GO
CREATE USER [SSBCLOUD\BI Developers] FOR LOGIN [SSBINFO\BI Developers]
GO
