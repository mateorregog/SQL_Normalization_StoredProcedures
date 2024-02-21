## Normalización, creación e implementación de un modelo relacional en SQL Server a partir de un caso de negocio
El proyecto se centra en la normalización, creación e implementación de un modelo relacional a partir de una tabla existente que cuenta con redundancia y poca estructuración de datos. En el proyecto se usa T-SQL y SQL Server como herramientas principales para la ejecución del proyecto, y la herramienta gratuita https://dbdiagram.io/home para la creación del modelo relacional. 

## Metodología
El proyecto se desarrolló llevando a cabo los siguientes pasos:</br></br>
**1.)** Normalización del dataset inicial y planteamiento del modelo relacional.</br>
**2.)** Creación de script de SQL para la creación de la base de datos, tablas y dependencias correspondiente según el modelo relacional planteado en el punto anterior.</br>
**3.)** Perfilado,limpieza de datos y carga en las tablas planteadas en el modelo relacional
**4.)**

##  Haz click en el enlace de abajo para descargar el dataset inicial del proyecto. 
El dataset continene información sobre la gestión de alquiler, venta y demás servicios ofrecidos por una inmobiliaria, así como datos de clientes, vendedores y ubicaciones geográficas. 
[Descargar archivo Excel](https://github.com/mateorregog/SQL_Normalization_StoredProcedures/blob/main/BBDD%20Ventas.xlsx
)

## 1.) Normalización y plantemamiento del modelo relacional
El modelo relacional planteado a partir del dataset compartido se muestra a continuación: <br>
![pp1-02](https://github.com/mateorregog/SQL_Normalization_StoredProcedures/blob/main/diagramaRelacional.jpg)

## 2.) Creación de tablas, relaciones y dependencias del modelo planteado</br>
```sql
--2.1) Creación tabla original 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBDD](
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
```
```sql
--2.2) Creación tabla tbCiudad
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
```
```sql
--2.3) Creación tabla tbComprador
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
```
```sql
--2.4) Creación tabla tbDivisa
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
```
```sql
--2.5) Creación tabla tbInmueble
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
```
```sql
--2.6) Creación tabla tbOperacion
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
```
```sql
--2.7) Creación tabla tbPais
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
```
```sql
--2.8) CReación tabla tbProvincia
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
```
```sql
--2.9) Creación tabla tbVendedor
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
```
```sql
--2.10) Creación tabla final normalizada y declaración de relaciones
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
```


## 3.) Creación de funciones para la limpieza de datos y procedimientos almacenados para la carga de datos según el modelo planteado
```sql
--3.1) Convertir fecha
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
```
```sql
--3.2) Extraer valor numérico con moneda
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
```
```sql
--3.3) Limpiar cédula
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
```
```sql
--3.4) Limpiar metros
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
```
```sql
--3.5) Limpiar registro
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
```
```sql
--3.6) Separar fecha y hora
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
```

