# Normalización, modelamiento, creación e implementación de un modelo relacional en SQL Server a partir de un caso de negocio
El proyecto se centra en la normalización, creación e implementación de un modelo relacional a partir de una tabla existente que cuenta con redundancia y poca estructuración de datos. En el proyecto se usa T-SQL y SQL Server como herramientas principales para la ejecución del proyecto, y la herramienta gratuita https://dbdiagram.io/home para la creación del modelo relacional. 

## Metodología
El proyecto se desarrolló llevando a cabo los siguientes pasos:

[**1.)** ](https://github.com/mateorregog/SQL_Normalization_StoredProcedures/blob/main/README.md#1-normalizaci%C3%B3n-y-plantemamiento-del-modelo-relacional)Normalización del dataset inicial y planteamiento del modelo relacional.

[**2.)** ](https://github.com/mateorregog/SQL_Normalization_StoredProcedures/blob/main/README.md#2-creaci%C3%B3n-de-tablas-relaciones-y-dependencias-del-modelo-planteado)Creación de script de SQL para la creación de la base de datos, tablas y dependencias correspondiente según el modelo relacional planteado en el punto anterior.

[**3.)**](https://github.com/mateorregog/SQL_Normalization_StoredProcedures/blob/main/README.md#3-creaci%C3%B3n-de-funciones-para-la-limpieza-de-datos-y-procedimientos-almacenados-para-la-carga-de-datos) Perfilado,limpieza de datos y carga en las tablas planteadas en el modelo relacional.

[**4.)**](https://github.com/mateorregog/SQL_Normalization_StoredProcedures/blob/main/README.md#4-creaci%C3%B3n-del-reporte-en-sql) Se solicita la creación de un reporte en SQL que devuelve una tabla con la siguiente estructura:


| Mes/Año | Tipo de inmueble | País | Suma venta en US | Suma alquiler en US | Promedio venta en US | Promedio alquiler en US | Unidades vendidas | Unidades alquiladas|
|---------|------------------|------|------------------|---------------------|----------------------|-------------------------|-------------------|--------------------|

Dado que las transacciones de la base de datos original contiene diferentes tipos de monedas, es preciso hacer algunas funciones de conversión de cada una de ellas con base en la siguiente tabla:

| País/Región | Divisa | Símbolo divisa | Cambio USD | 
|-------------|--------|--------------------|------------|
|RU|Libra esterlina|£|1,32|
|Eurozona|Euro|€|1,1|
|EE.UU|Dólar|$|1|
|Noruega|Corona noruega|Kr|0,11|
|Suiza|Franco suizo|Fr|1,07|
|Corea|Won surcoreano|₩|0,00082|

Este paso implica dos tareas: 
 - Creación de una función para la conversión de divisas.
 - Creación de procedimiento almacenado que retorna el dataset solicitado en el reporte. Procedimiento almacenado con parámetros de fecha que se usarán para filtrar la información según se requiera.
   
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
--2.8) Creación tabla tbProvincia
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


## 3.) Creación de funciones para la limpieza de datos y procedimientos almacenados para la carga de datos 
```sql
--3.1.1) Convertir fecha
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
--3.1.2) Extraer valor numérico con moneda
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
--3.1.3) Limpiar cédula
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
--3.1.4) Limpiar metros
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
--3.1.5) Limpiar registro
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
--3.1.6) Separar fecha y hora
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
## 3.2) Creación de procedimientos almacenados para la inserción de datos en las tablas creadas. Utilización de las funciones de limpieza creadas anteriormente
```sql
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

-- Insertar registros transformados en la tabla temporal haciendo uso de las funciones de limpieza previamente creadas
    INSERT INTO #RegistrosTransformados
	SELECT
	CONVERT(INT,[Referencia Venta]) AS referenciaVenta
	,CONVERT(INT,[Id Vendedor]) AS idVendedor
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
	FROM [TPVentas].[dbo].[BBDD]

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
	
-- Inserción compradores en tabla temporal
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
	
-- Inserción divisa en tabla temporal
	INSERT INTO #tbDivisa (nombreDivisa, simbolo)
	SELECT DISTINCT '-' AS nombreDivisa, simboloDivisa 
	FROM #RegistrosTransformados
	WHERE simboloDivisa IS NOT NULL

-- Insertar valores distintos en tabla física
    	INSERT INTO dbo.tbDivisa(nombreDivisa, simbolo)
    	SELECT nombreDivisa, simbolo
    	FROM #tbDivisa
	WHERE simbolo IS NOT NULL;

-- Tabla temporal país
	CREATE TABLE #tbPais (
	pais VARCHAR(50),
	);
	
-- Inserción país en tabla temporal
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

-- Creación tabla temporal ciudad	
	CREATE TABLE #tbCiudad (
	ciudad VARCHAR(50),
	codProvincia INT
	);

-- Inserción ciudad en tabla temporal
	INSERT INTO #tbCiudad (ciudad, codProvincia)
	SELECT DISTINCT r.ciudad, p.codProvincia
	FROM #RegistrosTransformados r
	INNER JOIN tbProvincia p ON r.provincia = p.provincia
	WHERE r.provincia IS NOT NULL;

-- Inserción valores distintos en tabla física
    	INSERT INTO dbo.tbCiudad(ciudad, codProvincia)
    	SELECT ciudad, codProvincia
    	FROM #tbCiudad
	WHERE ciudad IS NOT NULL;

--Tabla temporal inmueble
    	CREATE TABLE #tbInmueble(
	tipoInmueble VARCHAR(50),
	);

-- Inserción inmueble en tabla temporal
	INSERT INTO #tbInmueble (tipoInmueble)
	SELECT DISTINCT r.tipoInmueble
	FROM #RegistrosTransformados r
	WHERE r.tipoInmueble IS NOT NULL;

-- Inserción valores distintos en tabla física
    	INSERT INTO dbo.tbInmueble(tipoInmueble)
    	SELECT tipoInmueble
    	FROM #tbInmueble
	WHERE tipoInmueble IS NOT NULL;

--Tabla temporal operacion
    	CREATE TABLE #tbOperacion(
	tipoOperacion VARCHAR(50),
	);

-- Inserción operación en tabla temporal
	INSERT INTO #tbOperacion (tipoOperacion)
	SELECT DISTINCT r.tipoOperacion
	FROM #RegistrosTransformados r
	WHERE r.tipoOperacion IS NOT NULL;

-- Inserción valores distintos en tabla física
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

-- Inserción ventas en tabla temporal
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

-- Insertar valores en tabla física final
	INSERT INTO dbo.tbVentas(ReferenciaVenta, IdVendedor, IdComprador, FechaAlta, HoraAlta, codInmueble, 
	codOperacion, Superficie, codDivisa, PrecioVenta, FechaVenta, codCiudad)
	SELECT ReferenciaVenta, idVendedor, idComprador, FechaAlta, HoraAlta, codInmueble, 
	codOperacion, superficie, codDivisa, precioVenta, fechaVenta, codCiudad
	FROM #tbVentas
	WHERE ReferenciaVenta IS NOT NULL;

-- Eliminar tablas temporales
	DROP TABLE #RegistrosTransformados;
 	DROP TABLE #tbVendedor;
	DROP TABLE #tbComprador;
	DROP TABLE #tbDivisa;
	DROP TABLE #tbPais;
	DROP TABLE #tbProvincia;
	DROP TABLE #tbCiudad;
	DROP TABLE #tbInmueble;
	DROP TABLE #tbOperacion;
	DROP TABLE #tbVentas;

END;
GO
```
## 4.) Creación del reporte en SQL

## 4.1.) Creación de la función para la conversión de divisas

```sql
CREATE FUNCTION dbo.CalcularValorEnDolar (@CodDivisa INT)
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
```
## 4.2) Creación de procedimiento almacenado que retorna el reporte solicitado 

El procedimiento almacenado recibe parámetros de fecha que se usarán para filtrar la información según se requiera. Así mismo hace uso de la función creada en el paso anterior paa realizar la conversión de divisas requerida.

```sql
CREATE PROCEDURE SP_CalculoVentasPorFecha
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

```


