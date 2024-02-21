
--use TPVentas;

-- Crear el procedimiento almacenado
CREATE PROCEDURE dbo.ExtraccionTransformacionCarga
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



/*

exec dbo.ExtraccionTransformacionCarga;


drop procedure dbo.ExtraccionTransformacionCarga;



delete from tbVendedor	
delete from tbComprador
delete from tbDivisa
delete from tbCiudad
delete from tbProvincia
delete from tbPais
delete from tbCiudad
delete from tbVentas
delete from tbOperacion
delete from tbInmueble

DBCC CHECKIDENT('tbComprador', RESEED, 1);
DBCC CHECKIDENT('tbDivisa', RESEED, 1);
DBCC CHECKIDENT('tbCiudad', RESEED, 1);
DBCC CHECKIDENT('tbProvincia', RESEED, 1);
DBCC CHECKIDENT('tbPais', RESEED, 1);
DBCC CHECKIDENT('tbOperacion', RESEED, 1);
DBCC CHECKIDENT('tbInmueble', RESEED, 1);



*/












