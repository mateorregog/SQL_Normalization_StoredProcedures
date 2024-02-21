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

## 2.)
'''
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
'''
