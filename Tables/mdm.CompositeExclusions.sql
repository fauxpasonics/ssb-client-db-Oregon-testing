CREATE TABLE [mdm].[CompositeExclusions]
(
[ElementID] [int] NOT NULL,
[ExclusionID] [int] NOT NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__Composite__DateC__6383C8BA] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__Composite__DateU__6477ECF3] DEFAULT (getdate())
)
GO
