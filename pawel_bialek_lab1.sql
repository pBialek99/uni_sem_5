-- Zadanie nr 1
/*
SELECT p.IMIE, p.NAZWISKO, p.ETAT
FROM pracownicy p
JOIN zespoly z ON p.ID_ZESP = z.ID_ZESP
WHERE z.ADRES LIKE 'PIOTROWO%';
*/

-- Zadanie nr 2
/*
INSERT INTO etaty (NAZWA, PLACA_OD, PLACA_DO)
VALUES ('Lektor', 2000, 3000);
*/
-- sprawdzenie
-- SELECT *
-- FROM etaty e
-- WHERE e.NAZWA = 'Lektor';


-- Zadanie nr 3
/*
SELECT e.NAZWA
FROM etaty e
LEFT JOIN pracownicy p ON NAZWA = p.ETAT
WHERE p.ID_PRAC IS NULL;
*/

-- Zadanie nr 4
/*
SELECT NAZWA
FROM etaty
WHERE PLACA_DO = (SELECT MIN(PLACA_DO) FROM etaty);
*/

-- Zadanie nr 5
/*
SELECT z.NAZWA
FROM zespoly z
WHERE NOT EXISTS (
  SELECT *
  FROM pracownicy p
  WHERE p.ID_ZESP = z.ID_ZESP
  AND p.ETAT IN ('LEKTOR', 'PROFESOR')
);
*/

-- Zadanie nr 6
/*
SELECT p.NAZWISKO, p.ETAT
FROM pracownicy p
WHERE p.PLACA_POD = (
    SELECT MAX(PLACA_POD)
    FROM pracownicy
    WHERE ETAT IN ('SEKRETARKA', 'ADIUNKT')
);
*/

-- Zadanie nr 7
/*
SELECT z.NAZWA
FROM zespoly z
JOIN pracownicy p ON p.ID_ZESP = z.ID_ZESP
GROUP BY z.NAZWA
HAVING AVG(p.PLACA_POD) > (SELECT AVG(PLACA_POD) FROM pracownicy);
*/

-- Zadanie nr 8
/*
SELECT p1.NAZWISKO
FROM pracownicy p1
JOIN pracownicy p2 ON p1.ID_SZEFA = p2.ID_PRAC
WHERE p1.ZATRUDNIONY > p2.ZATRUDNIONY;
*/

-- Zadanie nr 9
/*
SELECT z.NAZWA
FROM zespoly z
JOIN pracownicy p ON p.ID_ZESP = z.ID_ZESP
WHERE p.ETAT = 'ASYSTENT'
GROUP BY z.NAZWA
HAVING COUNT(p.ID_PRAC >= 2);
*/

-- Zadanie nr 10
/*
SELECT p.IMIE, p.NAZWISKO, z.NAZWA AS ZESPOL
FROM pracownicy p
JOIN (
	SELECT ID_ZESP, NAZWA
	FROM zespoly
) z ON p.ID_ZESP = z.ID_ZESP
WHERE p.ETAT = 'PROFESOR';
*/

-- Zadanie nr 11
/*
DROP TABLE IF EXISTS projekty_badawcze;
CREATE TABLE projekty_badawcze (
	ID_PROJ decimal(4, 0) NOT NULL,
	NAZWA varchar(50) NOT NULL,
	SZEF varchar(50) NOT NULL,
	ID_ZESP decimal(2, 0) NOT NULL,
	DATA_ROZ date,
	DATA_ZAK date,
	BUDZET decimal(10, 2),
	PRIMARY KEY (ID_PROJ),
	FOREIGN KEY (ID_ZESP) REFERENCES zespoly(ID_ZESP)
);

INSERT INTO projekty_badawcze (
	ID_PROJ, NAZWA, SZEF, ID_ZESP, DATA_ROZ, DATA_ZAK, BUDZET)
VALUES
(1, 'Projekt A', 'Jan Kowalski', 20, '2024-10-23', '2024-10-30', 40000),
(2, 'Projekt B', 'Mateusz Nowiski', 40, '2024-10-28', '2024-10-39', 4000);

SELECT z.NAZWA AS ZESPOL, p.NAZWA AS PROJEKT
FROM projekty_badawcze p
JOIN zespoly z ON p.ID_ZESP = z.ID_ZESP;
*/
