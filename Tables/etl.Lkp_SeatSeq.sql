CREATE TABLE [etl].[Lkp_SeatSeq]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Seat] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SeatSeq] [int] NULL
)
GO
ALTER TABLE [etl].[Lkp_SeatSeq] ADD CONSTRAINT [PK_etl__Lkp_SeatSeq] PRIMARY KEY CLUSTERED  ([Id])
GO
