CREATE TABLE [email].[DimBrowser]
(
[DimBrowserId] [int] NOT NULL IDENTITY(-2, 1),
[Browser] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimBrowse__Creat__09EAFF72] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimBrowse__Creat__0ADF23AB] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimBrowse__Updat__0BD347E4] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimBrowse__Updat__0CC76C1D] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimBrowser] ADD CONSTRAINT [PK__DimBrows__7481998825CDED5A] PRIMARY KEY CLUSTERED  ([DimBrowserId])
GO
