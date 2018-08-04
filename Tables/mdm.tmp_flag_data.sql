CREATE TABLE [mdm].[tmp_flag_data]
(
[dimcustomerid] [int] NOT NULL,
[sourcesystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssb_crmsystem_acct_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_HOUSEHOLD_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_PRIMARY_FLAG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG] [int] NULL,
[SSB_CRMSYSTEM_HOUSEHOLD_PRIMARY_FLAG] [int] NULL,
[Source_System_Priority] [int] NOT NULL,
[LastPurchase_STH] [datetime] NULL,
[LastDonation] [datetime] NULL,
[LastPurchase] [datetime] NULL,
[Most_Recently_Updated] [datetime] NULL,
[Most_Recently_Created] [datetime] NOT NULL
)
GO
