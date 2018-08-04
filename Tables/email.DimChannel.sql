CREATE TABLE [email].[DimChannel]
(
[DimChannelId] [int] NOT NULL IDENTITY(-2, 1),
[Channel] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimChanne__Creat__1B158B74] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimChanne__Creat__1C09AFAD] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimChanne__Updat__1CFDD3E6] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimChanne__Updat__1DF1F81F] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimChannel] ADD CONSTRAINT [PK__DimChann__37F5D04D34D4A1FE] PRIMARY KEY CLUSTERED  ([DimChannelId])
GO
