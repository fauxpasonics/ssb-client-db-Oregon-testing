CREATE TABLE [email].[DimSegment]
(
[DimSegmentId] [int] NOT NULL IDENTITY(-2, 1),
[Src_SegmentId] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentDescription] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimSegmen__Creat__31F8F0CC] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimSegmen__Creat__32ED1505] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimSegmen__Updat__33E1393E] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimSegmen__Updat__34D55D77] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimSegment] ADD CONSTRAINT [PK__DimSegme__91C6F6AA5E0D297A] PRIMARY KEY CLUSTERED  ([DimSegmentId])
GO
