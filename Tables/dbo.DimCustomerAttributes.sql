CREATE TABLE [dbo].[DimCustomerAttributes]
(
[DimCustomerAttrID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NULL,
[AttributeGroupID] [int] NULL,
[Attributes] [xml] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Creat__5FB337D6] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Updat__60A75C0F] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[DimCustomerAttributes] ADD CONSTRAINT [PK__DimCusto__ABC69402011C38EB] PRIMARY KEY NONCLUSTERED  ([DimCustomerAttrID])
GO
CREATE CLUSTERED INDEX [IXC_DimCustomerAttributes] ON [dbo].[DimCustomerAttributes] ([DimCustomerID], [AttributeGroupID])
GO
