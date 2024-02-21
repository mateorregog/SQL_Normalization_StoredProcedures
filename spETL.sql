
--use TPVentas;

-- Crear el procedimiento almacenado
CREATE PROCEDURE dbo.ExtraccionTransformacionCarga
AS
BEGIN
    -- Crear una tabla temporal para almacenar los registros transformados
    CREATE TABLE #RegistrosTransformados (
        IdVendedor INT,
        TipoInmueble VARCHAR(50),
        TipoOperacion VARCHAR(50),
        --simboloDivisa VARCHAR(4),
        nombreVendedor VARCHAR(50),
        nombreComprador VARCHAR(50),
        correoVendedor VARCHAR(50),
        correoComprador VARCHAR(50),
        cedulacomprador VARCHAR(50),
        cedulaVendedor VARCHAR(50),
        ciudad VARCHAR(50),
		provincia VARCHAR(50),
		pais VARCHAR (50),
        telefComprador VARCHAR(50),
        telefvendedor VARCHAR(50)
    );

    -- Insertar registros transformados en la tabla temporal
    INSERT INTO #RegistrosTransformados
    SELECT [Referencia Venta]
      ,[Id Vendedor]
	  ,[Fecha y hora Alta]
      ,CONVERT(date,[Fecha y hora Alta]) as FechaAlta 
	  ,CONVERT(TIME(0), [Fecha y hora Alta]) as HoraAlta
      ,[Tipo Inmueble]
      ,[Operación]
      ,dbo.LimpiarMetros([Superficie]) as Superficie
      ,[Divisa]
      ,dbo.ExtraerValorNumericoConMoneda([Precio Venta]) as [Precio Venta]
      ,[Fecha Venta]
      ,dbo.LimpiarRegistro([Vendedor]) as Vendedor
      ,dbo.LimpiarRegistro([coprador]) as Comprador
      ,dbo.LimpiarRegistro([Correo Vendedor]) as CorreoVendedor
      ,dbo.LimpiarRegistro([Correo coprador]) as CorreoComprador
      ,[Cedula coprador]
      ,[Cedula Vendedor]
      ,[Pais]
      ,[Provincia]
      ,[Ciudad]
      ,dbo.LimpiarRegistro([Telefono comprador]) as [Telefono comprador]
      ,dbo.LimpiarRegistro([Telefono Vendedor] ) as [Telefono Vendedor]
  FROM [TPVentas].[dbo].[BBDD$]


    -- Insertar valores distintos de Vendedor en la tabla dimensión de Vendedores
    INSERT INTO dbo.tbVendedor([idVendedor], [nombreVendedor])
    SELECT DISTINCT IdVendedor, nombreVendedor
    FROM #RegistrosTransformados
	WHERE [IdVendedor] IS NOT NULL;


    -- Insertar valores distintos de Comprador en la tabla dimensión de Comprador
    INSERT INTO dbo.tbComprador([nombreComprador],[correoComprador],[cedulaComprador],[telefComprador])
    SELECT DISTINCT nombreComprador, correoComprador, cedulacomprador, telefComprador
    FROM #RegistrosTransformados;

    -- Insertar valores distintos de Divisa en la tabla dimensión de Divisas
    INSERT INTO dbo.tbDivisa([simbolo])
    SELECT DISTINCT simboloDivisa
    FROM #RegistrosTransformados;

	-- Insertar valores distintos en pais
	INSERT INTO dbo.tbPais([pais])
    SELECT DISTINCT pais
    FROM #RegistrosTransformados;

	-- Insertar valores dinstintos en Provincia
	INSERT INTO dbo.tbProvincia (provincia, codPais)
	SELECT DISTINCT r.provincia, p.codPais
	FROM #RegistrosTransformados r
	INNER JOIN dbo.tbPais p ON r.pais = p.pais
	WHERE r.Ciudad IS NOT NULL;

	-- Insertar valores dinstintos en Ciudad
	INSERT INTO dbo.tbCiudad (ciudad, codProvincia)
	SELECT DISTINCT r.ciudad, pr.codProvincia
	FROM #RegistrosTransformados r
	INNER JOIN dbo.tbProvincia p ON r.provincia = p.provincia
	WHERE r.Ciudad IS NOT NULL;


	/*--Insercion en tabla ventas
	INSERT INTO dbo.tbVentas([ReferenciaVenta]
      ,[IdVendedor]
      ,[IdComprador]
      ,[FechaAlta]
      ,[HoraAlta]
      ,[codInmueble]
      ,[codOperacion]
      ,[Superficie]
      ,[codDivisa]
      ,[PrecioVenta]
      ,[FechaVenta]
      ,[codCiudad])
	  */
    -- Eliminar la tabla temporal
    DROP TABLE #RegistrosTransformados;
END;

--exec dbo.ExtraccionTransformacionCarga;


--drop procedure dbo.ExtraccionTransformacionCarga;


