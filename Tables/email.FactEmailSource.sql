CREATE TABLE [email].[FactEmailSource]
(
[FactEmailSourceId] [int] NOT NULL IDENTITY(-2, 1),
[DimEmailId] [int] NULL,
[SourceSystemId] [int] NULL,
[EffectiveBeginDate] [datetime] NULL,
[EffectiveEndDate] [datetime] NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__FactEmail__Creat__6E0DDAD3] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__FactEmail__Creat__6F01FF0C] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__FactEmail__Updat__6FF62345] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__FactEmail__Updat__70EA477E] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[FactEmailSource] ADD CONSTRAINT [PK__FactEmai__11CE7944BE9079A4] PRIMARY KEY CLUSTERED  ([FactEmailSourceId])
GO
CREATE NONCLUSTERED INDEX [idx_FactEmailSource_DimEmailId] ON [email].[FactEmailSource] ([DimEmailId])
GO
ALTER TABLE [email].[FactEmailSource] ADD CONSTRAINT [FK__FactEmail__DimEm__72D28FF0] FOREIGN KEY ([DimEmailId]) REFERENCES [email].[DimEmail] ([DimEmailID])
GO
ALTER TABLE [email].[FactEmailSource] ADD CONSTRAINT [FK__FactEmail__Sourc__73C6B429] FOREIGN KEY ([SourceSystemId]) REFERENCES [mdm].[SourceSystems] ([SourceSystemID])
GO
