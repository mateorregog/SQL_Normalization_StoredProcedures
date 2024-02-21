
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