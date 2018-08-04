CREATE TABLE [email].[DimCampaign]
(
[DimCampaignId] [int] NOT NULL IDENTITY(-2, 1),
[DimCampaignTypeId] [int] NULL,
[DimChannelId] [int] NULL,
[SourceSystemID] [int] NULL,
[Src_CampaignID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromEmail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[GoalDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Creat__37B1CA22] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Creat__38A5EE5B] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Updat__399A1294] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Updat__3A8E36CD] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [PK__DimCampa__2C52FBAD066F3850] PRIMARY KEY CLUSTERED  ([DimCampaignId])
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [FK__DimCampai__DimCa__3C767F3F] FOREIGN KEY ([DimCampaignTypeId]) REFERENCES [email].[DimCampaignType] ([DimCampaignTypeId])
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [FK__DimCampai__DimCh__3D6AA378] FOREIGN KEY ([DimChannelId]) REFERENCES [email].[DimChannel] ([DimChannelId])
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [FK__DimCampai__Sourc__3E5EC7B1] FOREIGN KEY ([SourceSystemID]) REFERENCES [mdm].[SourceSystems] ([SourceSystemID])
GO
