USE [master]
GO
/****** Object:  Database [TPVentas]    Script Date: 15/09/2023 21:47:59 ******/
CREATE DATABASE [TPVentas]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TPVentas', FILENAME = N'D:\SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TPVentas.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TPVentas_log', FILENAME = N'D:\SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TPVentas_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [TPVentas] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TPVentas].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TPVentas] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TPVentas] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TPVentas] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TPVentas] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TPVentas] SET ARITHABORT OFF 
GO
ALTER DATABASE [TPVentas] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TPVentas] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TPVentas] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TPVentas] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TPVentas] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TPVentas] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TPVentas] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TPVentas] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TPVentas] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TPVentas] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TPVentas] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TPVentas] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TPVentas] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TPVentas] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TPVentas] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TPVentas] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TPVentas] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TPVentas] SET RECOVERY FULL 
GO
ALTER DATABASE [TPVentas] SET  MULTI_USER 
GO
ALTER DATABASE [TPVentas] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TPVentas] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TPVentas] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TPVentas] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TPVentas] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TPVentas] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'TPVentas', N'ON'
GO
ALTER DATABASE [TPVentas] SET QUERY_STORE = ON
GO
ALTER DATABASE [TPVentas] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [TPVentas]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcularValorEnDolar]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Calcular valores en dolares
CREATE FUNCTION [dbo].[CalcularValorEnDolar] (@CodDivisa INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @ValorEnDolar DECIMAL(18, 2);

    SELECT @ValorEnDolar = 
        CASE
            WHEN @CodDivisa = 2 THEN 1.00
            WHEN @CodDivisa = 3 THEN 1.32
            WHEN @CodDivisa = 4 THEN 0.00082
            WHEN @CodDivisa = 5 THEN 1.07
            WHEN @CodDivisa = 6 THEN 0.11
            WHEN @CodDivisa = 7 THEN 1.10
            ELSE 1.00 -- Valor predeterminado si no coincide con ningún codDivisa conocido
        END;

    RETURN @ValorEnDolar;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertirFecha]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  FUNCIONES DE LIMPIEZA DE DATOS!!!!
CREATE FUNCTION [dbo].[ConvertirFecha] (@fecha NVARCHAR(255))

RETURNS DATE
AS
BEGIN
    DECLARE @fechaResultado DATE;

    -- Verificar si la fecha es '1900-01-01' o '-'
    IF @fecha = '1900-01-01' OR @fecha = '-' OR @fecha = '00-01-1900'
    BEGIN
        SET @fechaResultado = NULL; -- Devolver un espacio en blanco 
    END
    ELSE
    BEGIN
        -- Convertir la fecha en formato 'dd-mm-yyyy' a DATE
        SET @fechaResultado = CONVERT(DATE, @fecha, 105);
    END

    RETURN @fechaResultado;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[ExtraerValorNumericoConMoneda]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ExtraerValorNumericoConMoneda] (@cadena NVARCHAR(255))
RETURNS INT 
AS
BEGIN
    DECLARE @valorNumerico INT;

    -- Encontrar la posición del primer espacio en blanco
    DECLARE @posicionEspacio INT;
    SET @posicionEspacio = CHARINDEX(' ', @cadena);

    -- Extraer el valor numérico después del primer espacio
    SET @valorNumerico = CAST(SUBSTRING(@cadena, @posicionEspacio + 1, LEN(@cadena)) AS INT);

    RETURN @valorNumerico;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[LimpiarCedula]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LimpiarCedula] (@registro FLOAT)
RETURNS NVARCHAR(255)  
AS
BEGIN
    DECLARE @registroLimpio NVARCHAR(255);

    -- Limpiar espacios en blanco al principio y al final
    SET @registroLimpio = LTRIM(RTRIM(@registro));


    RETURN @registroLimpio;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[LimpiarMetros]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[LimpiarMetros] (@cadena NVARCHAR(255))
RETURNS INT 
AS
BEGIN
    DECLARE @valorLimpio INT;

    -- Eliminar la palabra "Metros" y espacios en blanco, luego convertir a entero
    SET @cadena = REPLACE(@cadena, 'Metros', '');
    SET @cadena = LTRIM(RTRIM(@cadena));

    -- Convertir la cadena resultante en un valor entero
    SET @valorLimpio = CAST(@cadena AS INT);

    RETURN @valorLimpio;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[LimpiarRegistro]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LimpiarRegistro] (@registro NVARCHAR(255))
RETURNS VARCHAR(255)  
AS
BEGIN
    DECLARE @registroLimpio NVARCHAR(255);

    -- Limpiar espacios en blanco al principio y al final
    SET @registroLimpio = LTRIM(RTRIM(@registro));

    -- Reemplazar guiones '-' por una cadena vacía
    SET @registroLimpio = REPLACE(@registroLimpio, '-', '');

    RETURN @registroLimpio;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[SepararFechaHora]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SepararFechaHora] (@cadenaFechaHora NVARCHAR(255))
RETURNS TABLE
AS
RETURN (
    SELECT
        CAST(SUBSTRING(@cadenaFechaHora, 1, 10) AS DATE) AS Fecha, --Extre fecha
        CAST(SUBSTRING(@cadenaFechaHora, 12, 8) AS TIME) AS Hora  -- Extraer la hora
);
GO
/****** Object:  Table [dbo].[BBDD$]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBDD$](
	[Referencia Venta] [float] NULL,
	[Id Vendedor] [float] NULL,
	[Fecha y hora Alta] [nvarchar](255) NULL,
	[Tipo Inmueble] [nvarchar](255) NULL,
	[Operación] [nvarchar](255) NULL,
	[Superficie] [nvarchar](255) NULL,
	[Divisa] [nvarchar](255) NULL,
	[Precio Venta] [nvarchar](255) NULL,
	[Fecha Venta] [nvarchar](255) NULL,
	[Vendedor] [nvarchar](255) NULL,
	[coprador] [nvarchar](255) NULL,
	[Correo Vendedor] [nvarchar](255) NULL,
	[Correo coprador] [nvarchar](255) NULL,
	[Cedula coprador] [float] NULL,
	[Cedula Vendedor] [float] NULL,
	[Pais] [nvarchar](255) NULL,
	[Provincia] [nvarchar](255) NULL,
	[Ciudad] [nvarchar](255) NULL,
	[Telefono comprador] [nvarchar](255) NULL,
	[Telefono Vendedor] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbCiudad]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbCiudad](
	[codCiudad] [int] IDENTITY(1,1) NOT NULL,
	[ciudad] [varchar](50) NOT NULL,
	[codProvincia] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codCiudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbComprador]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbComprador](
	[idComprador] [int] IDENTITY(1,1) NOT NULL,
	[nombreComprador] [varchar](50) NOT NULL,
	[correoComprador] [varchar](50) NULL,
	[cedulaComprador] [varchar](50) NULL,
	[telefComprador] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idComprador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbDivisa]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbDivisa](
	[codDivisa] [int] IDENTITY(1,1) NOT NULL,
	[nombreDivisa] [varchar](50) NOT NULL,
	[simbolo] [varchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[codDivisa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbInmueble]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbInmueble](
	[codInmueble] [int] IDENTITY(1,1) NOT NULL,
	[tipoInmueble] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codInmueble] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbOperacion]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbOperacion](
	[codOperacion] [int] IDENTITY(1,1) NOT NULL,
	[tipoOperacion] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codOperacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbPais]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbPais](
	[codPais] [int] IDENTITY(1,1) NOT NULL,
	[pais] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbProvincia]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbProvincia](
	[codProvincia] [int] IDENTITY(1,1) NOT NULL,
	[provincia] [varchar](50) NOT NULL,
	[codPais] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codProvincia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbVendedor]    Script Date: 15/09/2023 21:47:59 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbVentas]    Script Date: 15/09/2023 21:47:59 ******/
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
/****** Object:  StoredProcedure [dbo].[ExtraccionTransformacionCarga]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--use TPVentas;

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[ExtraccionTransformacionCarga]
AS
BEGIN
    -- Crear una tabla temporal para almacenar los registros transformados
    CREATE TABLE #RegistrosTransformados (
		referenciaVenta INT,
        idVendedor INT,
		fechaAlta DATE,
		horaAlta TIME,
        tipoInmueble VARCHAR(50),
        tipoOperacion VARCHAR(50),
		superficie INT,
		simboloDivisa VARCHAR(50),
		precioVenta INT,
		fechaVenta DATE,
		nombreVendedor VARCHAR(50),
        nombreComprador VARCHAR(50),
        correoVendedor VARCHAR(50),
        correoComprador VARCHAR(50),
        cedulacomprador VARCHAR(50),
        cedulaVendedor VARCHAR(50),
		pais VARCHAR (50),
		provincia VARCHAR(50),
        ciudad VARCHAR(50),
        telefComprador VARCHAR(50),
        telefVendedor VARCHAR(50)
    );

    -- Insertar registros transformados en la tabla temporal
    INSERT INTO #RegistrosTransformados
	SELECT CONVERT(INT,[Referencia Venta]) AS referenciaVenta
      ,CONVERT(INT,[Id Vendedor]) AS idVendedor
	  --,[Fecha y hora Alta]
      ,CONVERT(date,[Fecha y hora Alta]) as fechaAlta 
	  ,CONVERT(TIME(0), [Fecha y hora Alta]) as horaAlta
      ,CONVERT(VARCHAR,[Tipo Inmueble]) AS tipoInmueble
      ,CONVERT(VARCHAR,[Operación]) AS tipoOperacion
      ,dbo.LimpiarMetros([Superficie]) as superficie
      ,CONVERT(VARCHAR,[Divisa]) AS simboloDivisa
      ,dbo.ExtraerValorNumericoConMoneda([Precio Venta]) as precioVenta
      ,CONVERT(DATE,dbo.ConvertirFecha([Fecha Venta])) AS fechaVenta
      ,dbo.LimpiarRegistro([Vendedor]) as nombreVendedor
      ,dbo.LimpiarRegistro([coprador]) as nombreComprador
      ,dbo.LimpiarRegistro([Correo Vendedor]) as correoVendedor
      ,dbo.LimpiarRegistro([Correo coprador]) as correoComprador
      ,CONVERT(VARCHAR,[Cedula coprador]) AS cedulaComprador
      ,CONVERT(VARCHAR,[Cedula Vendedor]) as cedulaVendedor
      ,dbo.LimpiarRegistro([Pais]) as pais
      ,dbo.LimpiarRegistro([Provincia]) as provincia
      ,dbo.LimpiarRegistro([Ciudad]) as ciudad
      ,dbo.LimpiarRegistro([Telefono comprador]) as telefComprador
      ,dbo.LimpiarRegistro([Telefono Vendedor]) as telefVendedor
     FROM [TPVentas].[dbo].[BBDD$]

	 -- Crear una tabla temporal para almacenar los vendedores únicos
	CREATE TABLE #tbVendedor (
	    idVendedor INT,
		nombreVendedor VARCHAR(50),
		correoVendedor VARCHAR(50),
		cedulaVendedor VARCHAR(50),
		telefVendedor VARCHAR(50)
	);
	
	-- Insercion vendedores en tabla temporal
	INSERT INTO #tbVendedor (idVendedor,nombreVendedor, correoVendedor, cedulaVendedor, telefVendedor)
	SELECT DISTINCT idVendedor, nombreVendedor, max(correoVendedor) as correoVendedor, cedulaVendedor, max(telefVendedor) as telefVendedor
	FROM #RegistrosTransformados
	WHERE idVendedor IS NOT NULL
	GROUP BY idVendedor, nombreVendedor, cedulaVendedor, telefVendedor;

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbVendedor(idVendedor, nombreVendedor, correoVendedor, cedulaVendedor, telefVendedor)
    SELECT idVendedor, nombreVendedor, correoVendedor, cedulaVendedor, telefVendedor
    FROM #tbVendedor
	WHERE idVendedor IS NOT NULL;

	-- Tabla temporal comprador
	CREATE TABLE #tbComprador (
	    nombreComprador VARCHAR(50),
		correoComprador VARCHAR(50),
		cedulaComprador VARCHAR(50),
		telefComprador VARCHAR(50),
	);
	
	-- Insercion vendedores en tabla temporal
	INSERT INTO #tbComprador (nombreComprador, correoComprador, cedulaComprador, telefComprador)
	SELECT DISTINCT nombreComprador, max(correoComprador) as correoComprador, max(cedulaComprador) as cedulaComprador, max(telefComprador) as telefComprador
	FROM #RegistrosTransformados
	WHERE nombreComprador IS NOT NULL
	GROUP BY nombreComprador;

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbComprador(nombreComprador, correoComprador, cedulaComprador, telefComprador)
    SELECT nombreComprador, correoComprador, cedulaComprador, telefComprador
    FROM #tbComprador
	WHERE nombreComprador IS NOT NULL and cedulaComprador IS NOT NULL;

	-- Tabla temporal divisa
	CREATE TABLE #tbDivisa (
	    nombreDivisa VARCHAR(50),
		simbolo VARCHAR(50),
	);
	
	-- Insercion divisa en tabla temporal
	INSERT INTO #tbDivisa (nombreDivisa, simbolo)
	SELECT DISTINCT '-' AS nombreDivisa, simboloDivisa 
	FROM #RegistrosTransformados
	WHERE simboloDivisa IS NOT NULL

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbDivisa(nombreDivisa, simbolo)
    SELECT nombreDivisa, simbolo
    FROM #tbDivisa
	WHERE simbolo IS NOT NULL;
	
	-- Tabla temporal pais
	CREATE TABLE #tbPais (
	    pais VARCHAR(50),
	);
	
	-- Insercion pais en tabla temporal
	INSERT INTO #tbPais (pais)
	SELECT DISTINCT pais 
	FROM #RegistrosTransformados
	WHERE pais IS NOT NULL

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbPais(pais)
    SELECT pais
    FROM #tbPais
	WHERE pais IS NOT NULL;

	-- Tabla temporal provincia
	CREATE TABLE #tbProvincia (
	    provincia VARCHAR(50),
		codPais INT
	);

	-- Insercion provincia en tabla temporal
	INSERT INTO #tbProvincia (provincia, codPais)
	SELECT DISTINCT r.provincia, p.codPais
	FROM #RegistrosTransformados r
	INNER JOIN tbPais p ON r.pais = p.pais
	WHERE r.pais IS NOT NULL;

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbProvincia(provincia, codPais)
    SELECT provincia, codPais
    FROM #tbProvincia
	WHERE provincia IS NOT NULL;

		-- Tabla temporal ciudad	
	CREATE TABLE #tbCiudad (
	    ciudad VARCHAR(50),
		codProvincia INT
	);

	-- Insercion provincia en tabla temporal
	INSERT INTO #tbCiudad (ciudad, codProvincia)
	SELECT DISTINCT r.ciudad, p.codProvincia
	FROM #RegistrosTransformados r
	INNER JOIN tbProvincia p ON r.provincia = p.provincia
	WHERE r.provincia IS NOT NULL;

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbCiudad(ciudad, codProvincia)
    SELECT ciudad, codProvincia
    FROM #tbCiudad
	WHERE ciudad IS NOT NULL;

	--Tabla tempora inmueble
    CREATE TABLE #tbInmueble(
	    tipoInmueble VARCHAR(50),
	);

	-- Insercion inmueble en tabla temporal
	INSERT INTO #tbInmueble (tipoInmueble)
	SELECT DISTINCT r.tipoInmueble
	FROM #RegistrosTransformados r
	WHERE r.tipoInmueble IS NOT NULL;

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbInmueble(tipoInmueble)
    SELECT tipoInmueble
    FROM #tbInmueble
	WHERE tipoInmueble IS NOT NULL;

		--Tabla temporal operacion
    CREATE TABLE #tbOperacion(
	    tipoOperacion VARCHAR(50),
	);

	-- Insercion inmueble en tabla temporal
	INSERT INTO #tbOperacion (tipoOperacion)
	SELECT DISTINCT r.tipoOperacion
	FROM #RegistrosTransformados r
	WHERE r.tipoOperacion IS NOT NULL;

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbOperacion(tipoOperacion)
    SELECT tipoOperacion
    FROM #tbOperacion
	WHERE tipoOperacion IS NOT NULL;


	-- Tabla temporal ventas
	CREATE TABLE #tbVentas (
	    ReferenciaVenta INT,
		idVendedor INT,
		idComprador INT,
		FechaAlta DATE,
		HoraAlta TIME,
		codInmueble INT,
		codOperacion INT,
		superficie INT,
		codDivisa INT,
		precioVenta INT,
		fechaVenta DATE,
		codCiudad INT
	);

	-- Insercion ventas en tabla temporal
	INSERT INTO #tbVentas (ReferenciaVenta, idVendedor, idComprador, FechaAlta, HoraAlta, codInmueble, 
	codOperacion, superficie, codDivisa, precioVenta, fechaVenta, codCiudad)
	SELECT r.referenciaVenta, r.idVendedor, a.idComprador, r.fechaAlta, r.horaAlta, b.codInmueble, 
	c.codOperacion, r.superficie, d.codDivisa, r.precioVenta, r.fechaVenta, e.codCiudad
	FROM #RegistrosTransformados r
	LEFT JOIN tbComprador a ON a.nombreComprador = r.nombreComprador
	LEFT JOIN tbInmueble b ON b.tipoInmueble = r.tipoInmueble
	LEFT JOIN tbOperacion c on c.tipoOperacion = r.tipoOperacion
	LEFT JOIN tbDivisa d ON d.simbolo = r.simboloDivisa
	LEFT JOIN tbCiudad e ON e.ciudad = r.ciudad
	WHERE r.referenciaVenta IS NOT NULL;

    -- Insertar valores distintos en tabla física
    INSERT INTO dbo.tbVentas(ReferenciaVenta, IdVendedor, IdComprador, FechaAlta, HoraAlta, codInmueble, 
	codOperacion, Superficie, codDivisa, PrecioVenta, FechaVenta, codCiudad)
    SELECT ReferenciaVenta, idVendedor, idComprador, FechaAlta, HoraAlta, codInmueble, 
	codOperacion, superficie, codDivisa, precioVenta, fechaVenta, codCiudad
    FROM #tbVentas
	WHERE ReferenciaVenta IS NOT NULL;

    -- Eliminar la tabla temporal
    DROP TABLE #RegistrosTransformados;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_CalculoVentasPorFecha]    Script Date: 15/09/2023 21:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CalculoVentasPorFecha]
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    WITH calculo1 AS 
    (
        SELECT  
            a.FechaVenta,
            b.tipoInmueble,
            c.Pais,
            d.tipoOperacion,
            e.simbolo,
            SUM(PrecioVenta) AS SumPrecio,
            COUNT(ReferenciaVenta) AS UnidadesVendidas,
            dbo.CalcularValorEnDolar(e.[codDivisa]) AS ValorDolar,
            dbo.CalcularValorEnDolar(e.[codDivisa]) * SUM(PrecioVenta) AS VentaTotalDolar
        FROM [TPVentas].[dbo].[tbVentas] AS a
        LEFT JOIN tbInmueble b ON a.codInmueble = b.codInmueble
        LEFT JOIN tbCiudad ciu ON a.codCiudad = ciu.codCiudad
        LEFT JOIN tbProvincia prov ON prov.codProvincia = ciu.codProvincia
        LEFT JOIN tbPais c ON c.codPais = prov.codPais
        LEFT JOIN tbOperacion d ON d.codOperacion = a.codOperacion
        LEFT JOIN tbDivisa e ON e.codDivisa = a.codDivisa
        WHERE a.FechaVenta BETWEEN @FechaInicio AND @FechaFin
        GROUP BY
            a.FechaVenta,
            b.tipoInmueble,
            c.Pais,
            d.tipoOperacion,
            e.simbolo,
            e.codDivisa
    ) 
    SELECT  
        FechaVenta,
        tipoInmueble,
        Pais,
        tipoOperacion,
        simbolo,
        SUM(CASE WHEN tipoOperacion = 'Venta' THEN VentaTotalDolar END) AS 'Suma Venta Dolares',
        SUM(CASE WHEN tipoOperacion = 'Alquiler' THEN VentaTotalDolar END) AS 'Suma Alquiler Dolares',
        AVG(CASE WHEN tipoOperacion = 'Venta' THEN VentaTotalDolar END) AS 'Promedio Venta Dolares',
        AVG(CASE WHEN tipoOperacion = 'Alquiler' THEN VentaTotalDolar END) AS 'Promedio Alquiler Dolares',
        COUNT(CASE WHEN tipoOperacion = 'Venta' THEN VentaTotalDolar END) AS 'Unidades Vendidas',
        COUNT(CASE WHEN tipoOperacion = 'Alquiler' THEN VentaTotalDolar END) AS 'Unidades Alquiladas'
    FROM calculo1
    GROUP BY
        FechaVenta,
        tipoInmueble,
        Pais,
        tipoOperacion,
        simbolo;
END
GO
USE [master]
GO
ALTER DATABASE [TPVentas] SET  READ_WRITE 
GO
