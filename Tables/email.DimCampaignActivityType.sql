CREATE TABLE [email].[DimCampaignActivityType]
(
[DimCampaignActivityTypeId] [int] NOT NULL IDENTITY(-2, 1),
[ActivityType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Creat__0FA3D8C8] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Creat__1097FD01] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Updat__118C213A] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Updat__12804573] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimCampaignActivityType] ADD CONSTRAINT [PK__DimCampa__9DB9554E60CB1D6A] PRIMARY KEY CLUSTERED  ([DimCampaignActivityTypeId])
GO
