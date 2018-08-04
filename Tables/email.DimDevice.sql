CREATE TABLE [email].[DimDevice]
(
[DimDeviceId] [int] NOT NULL IDENTITY(-2, 1),
[Device] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimDevice__Creat__20CE64CA] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimDevice__Creat__21C28903] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimDevice__Updat__22B6AD3C] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimDevice__Updat__23AAD175] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimDevice] ADD CONSTRAINT [PK__DimDevic__EE18DE21B6CFCF5F] PRIMARY KEY CLUSTERED  ([DimDeviceId])
GO
