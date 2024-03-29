USE [ventasTP]
GO
/****** Object:  Schema [ventas_tp_schema]    Script Date: 14/09/2023 15:10:44 ******/
CREATE SCHEMA [ventas_tp_schema]
GO
/****** Object:  Table [dbo].[tbCiudad]    Script Date: 14/09/2023 15:10:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbCiudad](
	[codCiudad] [int] NOT NULL,
	[ciudad] [varchar](50) NOT NULL,
	[codProvincia] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codCiudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbComprador]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbComprador](
	[idComprador] [int] NOT NULL,
	[nombreComprador] [varchar](50) NOT NULL,
	[correoComprador] [varchar](50) NULL,
	[cedulaComprador] [varchar](50) NULL,
	[telefComprador] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idComprador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[cedulaComprador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[correoComprador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbDivisa]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbDivisa](
	[codDivisa] [int] NOT NULL,
	[nombreDivisa] [varchar](50) NOT NULL,
	[simbolo] [varchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[codDivisa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbInmueble]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbInmueble](
	[codInmueble] [int] NOT NULL,
	[tipoInmueble] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codInmueble] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbOperacion]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbOperacion](
	[codOperacion] [int] NOT NULL,
	[tipoOperacion] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codOperacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbPais]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbPais](
	[codPais] [int] NOT NULL,
	[pais] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbProvincia]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbProvincia](
	[codProvincia] [int] NOT NULL,
	[provincia] [varchar](50) NOT NULL,
	[codPais] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codProvincia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbVendedor]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbVendedor](
	[idVendedor] [int] NOT NULL,
	[nombreVendedor] [varchar](50) NOT NULL,
	[correoVendedor] [varchar](50) NULL,
	[cedulaVendedor] [varchar](50) NULL,
	[telefVendedor] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idVendedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[correoVendedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[cedulaVendedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbVentas]    Script Date: 14/09/2023 15:10:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbVentas](
	[ReferenciaVenta] [int] NOT NULL,
	[IdVendedor] [int] NULL,
	[IdComprador] [int] NULL,
	[FechaAlta] [date] NULL,
	[HoraAlta] [time](7) NULL,
	[codInmueble] [int] NULL,
	[codOperacion] [int] NULL,
	[Superficie] [int] NULL,
	[codDivisa] [int] NULL,
	[PrecioVenta] [int] NULL,
	[FechaVenta] [date] NULL,
	[codCiudad] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReferenciaVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbCiudad]  WITH CHECK ADD FOREIGN KEY([codProvincia])
REFERENCES [dbo].[tbProvincia] ([codProvincia])
GO
ALTER TABLE [dbo].[tbProvincia]  WITH CHECK ADD FOREIGN KEY([codPais])
REFERENCES [dbo].[tbPais] ([codPais])
GO
ALTER TABLE [dbo].[tbVentas]  WITH CHECK ADD FOREIGN KEY([codCiudad])
REFERENCES [dbo].[tbCiudad] ([codCiudad])
GO
ALTER TABLE [dbo].[tbVentas]  WITH CHECK ADD FOREIGN KEY([codDivisa])
REFERENCES [dbo].[tbDivisa] ([codDivisa])
GO
ALTER TABLE [dbo].[tbVentas]  WITH CHECK ADD FOREIGN KEY([codInmueble])
REFERENCES [dbo].[tbInmueble] ([codInmueble])
GO
ALTER TABLE [dbo].[tbVentas]  WITH CHECK ADD FOREIGN KEY([codOperacion])
REFERENCES [dbo].[tbOperacion] ([codOperacion])
GO
ALTER TABLE [dbo].[tbVentas]  WITH CHECK ADD FOREIGN KEY([IdComprador])
REFERENCES [dbo].[tbComprador] ([idComprador])
GO
ALTER TABLE [dbo].[tbVentas]  WITH CHECK ADD FOREIGN KEY([IdVendedor])
REFERENCES [dbo].[tbVendedor] ([idVendedor])
GO
