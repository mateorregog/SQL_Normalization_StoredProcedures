--CREATE DATABASE ventasTP;

USE ventasTP;

IF OBJECT_ID('dbo.tbVendedor', 'U') IS NOT NULL
    DROP TABLE dbo.tbVendedor;

-- Crear la tabla Vendedores
CREATE TABLE tbVendedor (
    idVendedor INT PRIMARY KEY,
    nombreVendedor VARCHAR(50) NOT NULL,
    correoVendedor VARCHAR(50) UNIQUE,
    cedulaVendedor VARCHAR(50) UNIQUE,
    telefVendedor VARCHAR(50)
);

IF OBJECT_ID('dbo.tbComprador', 'U') IS NOT NULL
    DROP TABLE dbo.tbComprador;

CREATE TABLE tbComprador (
	idComprador	INTEGER PRIMARY KEY,
	nombreComprador	VARCHAR(50) NOT NULL,
	correoComprador	VARCHAR(50) UNIQUE,
	cedulaComprador	VARCHAR(50) UNIQUE,
	telefComprador	VARCHAR(50)
);

IF OBJECT_ID('dbo.tbInmueble', 'U') IS NOT NULL
    DROP TABLE dbo.tbInmueble;

CREATE TABLE tbInmueble(
	codInmueble INTEGER PRIMARY KEY,
	tipoInmueble VARCHAR(50) NOT NULL
);

IF OBJECT_ID('dbo.tbOperacion', 'U') IS NOT NULL
    DROP TABLE dbo.tbOperacion;

CREATE TABLE tbOperacion(
	codOperacion INTEGER PRIMARY KEY,
	tipoOperacion VARCHAR(50) NOT NULL
);

IF OBJECT_ID('dbo.tbDivisa', 'U') IS NOT NULL
    DROP TABLE dbo.tbDivisa;

CREATE TABLE tbDivisa(
	codDivisa INTEGER PRIMARY KEY,
	nombreDivisa VARCHAR(50) NOT NULL,
	simbolo VARCHAR(4)
);

IF OBJECT_ID('dbo.tbPais', 'U') IS NOT NULL
    DROP TABLE dbo.tbPais;

CREATE TABLE tbPais(
	codPais INTEGER PRIMARY KEY,
	pais VARCHAR(50) NOT NULL
);

IF OBJECT_ID('dbo.tbProvincia', 'U') IS NOT NULL
    DROP TABLE dbo.tbProvincia;

CREATE TABLE tbProvincia(
	codProvincia INTEGER PRIMARY KEY,
	provincia VARCHAR(50) NOT NULL,
	codPais INTEGER,
	FOREIGN KEY (codPais) REFERENCES tbPais(codPais)
);

IF OBJECT_ID('dbo.tbCiudad', 'U') IS NOT NULL
    DROP TABLE dbo.tbCiudad;

CREATE TABLE tbCiudad(
	codCiudad INTEGER PRIMARY KEY,
    ciudad VARCHAR(50) NOT NULL,
	codProvincia INTEGER,
	FOREIGN KEY (codProvincia) REFERENCES tbProvincia(codProvincia)
);


IF OBJECT_ID('dbo.tbVentas', 'U') IS NOT NULL
    DROP TABLE dbo.tbCiudad;

CREATE TABLE tbVentas (
	ReferenciaVenta INTEGER PRIMARY KEY,
	IdVendedor INTEGER,
	IdComprador INTEGER,
	FechaAlta DATE,
	HoraAlta TIME,
	codInmueble INTEGER,
	codOperacion INTEGER,
	Superficie INTEGER,
	codDivisa INTEGER,
	PrecioVenta INTEGER,
	FechaVenta DATE,
	codCiudad INTEGER,
	FOREIGN KEY (IdVendedor) REFERENCES tbVendedor(idVendedor),
	FOREIGN KEY (codInmueble) REFERENCES tbInmueble(codInmueble),
	FOREIGN KEY (codOperacion) REFERENCES tbOperacion(codOperacion),
	FOREIGN KEY (codDivisa) REFERENCES tbDivisa(codDivisa),
	FOREIGN KEY (IdComprador) REFERENCES tbComprador(idComprador),
	FOREIGN KEY (codCiudad) REFERENCES tbCiudad(codCiudad),
);


