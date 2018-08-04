CREATE TABLE [email].[DimOperatingSystem]
(
[DimOperatingSystemId] [int] NOT NULL IDENTITY(-2, 1),
[OperatingSystem] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimOperat__Creat__2C401776] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimOperat__Creat__2D343BAF] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimOperat__Updat__2E285FE8] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimOperat__Updat__2F1C8421] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimOperatingSystem] ADD CONSTRAINT [PK__DimOpera__04A7A4C699D909D8] PRIMARY KEY CLUSTERED  ([DimOperatingSystemId])
GO
