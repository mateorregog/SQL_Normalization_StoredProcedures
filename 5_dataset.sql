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
