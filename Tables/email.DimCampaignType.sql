CREATE TABLE [email].[DimCampaignType]
(
[DimCampaignTypeId] [int] NOT NULL IDENTITY(-2, 1),
[CampaignType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Creat__155CB21E] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Creat__1650D657] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Updat__1744FA90] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Updat__18391EC9] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimCampaignType] ADD CONSTRAINT [PK__DimCampa__7EB1CFE503D9CD6F] PRIMARY KEY CLUSTERED  ([DimCampaignTypeId])
GO
