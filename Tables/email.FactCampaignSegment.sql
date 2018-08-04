CREATE TABLE [email].[FactCampaignSegment]
(
[FactCampaignSegmentId] [int] NOT NULL IDENTITY(-2, 1),
[DimCampaignId] [int] NULL,
[DimSegmentId] [int] NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__FactCampa__Creat__572A757B] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__FactCampa__Creat__581E99B4] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__FactCampa__Updat__5912BDED] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__FactCampa__Updat__5A06E226] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[FactCampaignSegment] ADD CONSTRAINT [PK__FactCamp__1324ECD514E1AB06] PRIMARY KEY CLUSTERED  ([FactCampaignSegmentId])
GO
CREATE NONCLUSTERED INDEX [idx_FactCampaignSegment_DimCampaignId] ON [email].[FactCampaignSegment] ([DimCampaignId])
GO
CREATE NONCLUSTERED INDEX [idx_FactCampaignSegment_DimSegmentId] ON [email].[FactCampaignSegment] ([DimSegmentId])
GO
ALTER TABLE [email].[FactCampaignSegment] ADD CONSTRAINT [FK__FactCampa__DimCa__5BEF2A98] FOREIGN KEY ([DimCampaignId]) REFERENCES [email].[DimCampaign] ([DimCampaignId])
GO
ALTER TABLE [email].[FactCampaignSegment] ADD CONSTRAINT [FK__FactCampa__DimSe__5CE34ED1] FOREIGN KEY ([DimSegmentId]) REFERENCES [email].[DimSegment] ([DimSegmentId])
GO
