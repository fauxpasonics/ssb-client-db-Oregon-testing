CREATE TABLE [config].[ElementProcessMapping]
(
[ElementProcessId] [int] NOT NULL IDENTITY(1, 1),
[ElementId] [int] NULL,
[ProcessId] [int] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__ElementPr__DateC__0120AF47] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__ElementPr__DateU__0214D380] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__ElementPr__Creat__0308F7B9] DEFAULT (suser_sname()),
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__ElementPr__Updat__03FD1BF2] DEFAULT (suser_sname())
)
GO
