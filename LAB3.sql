-- CW1

ALTER PROCEDURE podwyzka (
	@stanowisko NVARCHAR(100), 
	@podwyzka DECIMAL(3)
)
AS
UPDATE Pracownicy
SET Pensja = (Pensja + Pensja * (@podwyzka / 100))
WHERE Stanowisko = @stanowisko
GO

-- EXEC podwyzka 'Programista', 20;
-- SELECT * FROM Pracownicy;


-- CW2
ALTER PROCEDURE ilosc_dzialu(
	@stanowisko NVARCHAR(100)
)
AS
SELECT COUNT(*) AS Ilosc_pracownikow
FROM Pracownicy
WHERE Stanowisko = @stanowisko
GO
-- EXEC ilosc_dzialu 'Programista';


-- CW3
ALTER PROCEDURE wyswietl_tab (
	@nazwa NVARCHAR(100)
)
AS
DECLARE @query NVARCHAR(100)
SET @query = 'SELECT * FROM ' + @nazwa
EXEC (@query)
GO

-- EXEC wyswietl_tab 'Pracownicy';


-- CW4

CREATE TABLE uczen (
	ID INT IDENTITY(1,1) PRIMARY KEY,  -- Unikalny identyfikator dla pracownika
    Imie NVARCHAR(100) NOT NULL,       -- Imię pracownika
    Nazwisko NVARCHAR(100) NOT NULL,   -- Nazwisko pracownika
    Klasa DECIMAL(10, 2) NOT NULL,
)
