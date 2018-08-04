CREATE TABLE [dbo].[dimcustomerssbid_20170320]
(
[DimCustomerSSBID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerId] [int] NOT NULL,
[NameAddr_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameEmail_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Composite_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_PRIMARY_FLAG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[DeleteDate] [datetime] NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG] [int] NULL,
[NamePhone_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssb_crmsystem_contactacct_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
