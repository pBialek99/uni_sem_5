-- Tabela Kursy
CREATE TABLE Kursy (
    ID_Kurs INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa NVARCHAR(100) NOT NULL,
    Data_Rozpoczecia DATE NOT NULL,
    Data_Zakonczenia DATE NOT NULL,
    Maks_Liczba_Uczestnikow INT NOT NULL
);

-- Tabela Uczestnicy
CREATE TABLE Uczestnicy (
    ID_Uczestnik INT IDENTITY(1,1) PRIMARY KEY,
    Imie NVARCHAR(50) NOT NULL,
    Nazwisko NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE
);

-- Tabela Kursy_Uczestnicy (relacja N:N)
CREATE TABLE Kursy_Uczestnicy (
    ID_Kurs INT NOT NULL FOREIGN KEY REFERENCES Kursy(ID_Kurs) ON DELETE CASCADE,
    ID_Uczestnik INT NOT NULL FOREIGN KEY REFERENCES Uczestnicy(ID_Uczestnik) ON DELETE CASCADE,
    Data_Zapisu DATE NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Zapisany',
    PRIMARY KEY (ID_Kurs, ID_Uczestnik)
);

-- Dane do tabeli Kursy
INSERT INTO Kursy (Nazwa, Data_Rozpoczecia, Data_Zakonczenia, Maks_Liczba_Uczestnikow)
VALUES 
('SQL dla Początkujących', '2024-11-01', '2024-11-15', 20),
('Zaawansowany Python', '2024-11-10', '2024-11-25', 15),
('Projektowanie Baz Danych', '2024-12-01', '2024-12-15', 25);

-- Dane do tabeli Uczestnicy
INSERT INTO Uczestnicy (Imie, Nazwisko, Email)
VALUES 
('Jan', 'Kowalski', 'jan.kowalski@example.com'),
('Anna', 'Nowak', 'anna.nowak@example.com'),
('Piotr', 'Wiśniewski', 'piotr.wisniewski@example.com'),
('Maria', 'Zielińska', 'maria.zielinska@example.com');

-- Dane do tabeli Kursy_Uczestnicy
INSERT INTO Kursy_Uczestnicy (ID_Kurs, ID_Uczestnik)
VALUES 
(1, 1), -- Jan Kowalski zapisany na SQL
(1, 2), -- Anna Nowak zapisany na SQL
(2, 3), -- Piotr Wiśniewski na Python
(3, 4); -- Maria Zielińska na Projektowanie


-- Funkcje
create function lista_kursow (@uzytkownik int)
returns table
as
begin
    return 
        (select u.imie, u.nazwisko, k.id_kurs, k.nazwa, k.data_rozpoczecia, k.data_zakonczenia, k.maks_liczba_uczestnikow
        from kursy k
        join kursy_uczestnicy ku on k.id_kurs = ku.id_kurs
        join uczestnicy u on ku.id_uczestnik = u.id_uczestnik
        where u.id_uczestnik = @uzytkownik)
end

create function czas_trwania_kursu (@id int)
returns date
as
begin
    declare @poczatek date
    declare @koniec date
    declare @czas int
    set @poczatek = (select data_rozpoczecia from kursy where id_kurs = @id)
    set @koniec = (select data_zakonczenia from kursy where id_kurs = @id)
    set @czas = (datediff(day, @poczatek, @koniec))
    
    return @czas
end

-- Widoki
create view lista_maili_kurs_sql
as
select u.email as maile_uczestnikow_kursu_sql 
from uczestnicy u
join kursy_uczestnicy ku on u.id_uczestnik = ku.id_uczestnik
where ku.id_kurs = 1
-- ----------------------------------------------------
create view dane_kursantow
as
select u.id_uczestnik, u.imie, u.nazwisko, u.email, k.nazwa as kurs, ku.data_zapisu, 
    datediff(day, ku.data_zapisu, k.data_zakonczenia) as dni_do_zakonczenia
from uczestnicy u
join kursy_uczestnicy ku on u.id_uczestnik = ku.id_uczestnik
join kursy k on ku.id_kurs = k.id_kurs
-- -----------------------------------------------------

-- Procedury
create procedure wprowadz_kurs (@nazwa varchar(50), @data_r date, @data_z date, @uczestnicy int)
as
  insert into kursy 
  (nazwa, data_rozpoczecia, data_zakonczenia, maks_liczba_uczestnikow)
  values (@nazwa, @data_r, @data_z, @uczestnicy)
go

-- ------------------------------------------------------
create procedure zmien_status_kursanta
(@id int, @nowy_status varchar(50))
as
  update kursy_uczestnicy
  set status = @nowy_status
  where id_uczestnik = @id
go

-- -------------------------------------------------------

-- Wyzwalacze
create trigger jesli_przekroczono_limit
on kursy_uczestnicy
after insert
as
begin
    declare @kurs_id int
    declare @liczba_uczestnikow int
    declare @max_liczba_uczestnikow int

    select @kurs_id = id_kurs from inserted
    select @liczba_uczestnikow = count(*) from kursy_uczestnicy where id_kurs = @kurs_id
    select @max_liczba_uczestnikow = maks_liczba_uczestnikow from kursy where id_kurs = @kurs_id
    
    if @liczba_uczestnikow > @max_liczba_uczestnikow
    begin
        rollback transaction
        print 'nie mozna dodac uczestnika, przekroczono limit miejsc.'
    end
end
go

-- ------------------------------------------------------

create trigger sprawdz_status_uczestnika
on kursy_uczestnicy
after update
as
begin
    declare @status varchar(50)
    declare @id int

    select @id = id_uczestnik, @status = status from inserted
    
    if @status = 'nieaktywny'
    begin
        update kursy_uczestnicy
        set status = 'zrezygnowany'
        where id_uczestnik = @id
    end
end
go
