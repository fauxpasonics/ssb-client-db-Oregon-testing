CREATE TABLE [email].[DimEmailClient]
(
[DimEmailClientId] [int] NOT NULL IDENTITY(-2, 1),
[EmailClient] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimEmailC__Creat__26873E20] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimEmailC__Creat__277B6259] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimEmailC__Updat__286F8692] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimEmailC__Updat__2963AACB] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimEmailClient] ADD CONSTRAINT [PK__DimEmail__92D90F91D1045E06] PRIMARY KEY CLUSTERED  ([DimEmailClientId])
GO
