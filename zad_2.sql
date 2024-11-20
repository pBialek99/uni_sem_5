-- Tabela kursy
create table kursy (
    id_kurs int identity(1,1) primary key,
    nazwa nvarchar(100) not null,
    data_rozpoczecia date not null,
    data_zakonczenia date not null,
    maks_liczba_uczestnikow int not null
);

-- Tabela uczestnicy
create table uczestnicy (
    id_uczestnik int identity(1,1) primary key,
    imie nvarchar(50) not null,
    nazwisko nvarchar(50) not null,
    email nvarchar(100) not null unique
);

-- Tabela kursy_uczestnicy (relacja N:N)
create table kursy_uczestnicy (
    id_kurs int not null foreign key references kursy(id_kurs) on delete cascade,
    id_uczestnik int not null foreign key references uczestnicy(id_uczestnik) on delete cascade,
    data_zapisu date not null default getdate(),
    status nvarchar(20) default 'zapisany',
    primary key (id_kurs, id_uczestnik)
);

-- Dane do tabeli kursy
insert into kursy (nazwa, data_rozpoczecia, data_zakonczenia, maks_liczba_uczestnikow)
values 
('sql dla początkujących', '2024-11-01', '2024-11-15', 20),
('zaawansowany python', '2024-11-10', '2024-11-25', 15),
('projektowanie baz danych', '2024-12-01', '2024-12-15', 25);

-- Dane do tabeli uczestnicy
insert into uczestnicy (imie, nazwisko, email)
values 
('jan', 'kowalski', 'jan.kowalski@example.com'),
('anna', 'nowak', 'anna.nowak@example.com'),
('piotr', 'wiśniewski', 'piotr.wisniewski@example.com'),
('maria', 'zielińska', 'maria.zielinska@example.com');

-- Dane do tabeli kursy_uczestnicy
insert into kursy_uczestnicy (id_kurs, id_uczestnik)
values 
(1, 1), -- jan kowalski zapisany na sql
(1, 2), -- anna nowak zapisany na sql
(2, 3), -- piotr wiśniewski na python
(3, 4); -- maria zielińska na projektowanie

-- Funkcje
-- --------------------------------------
create function lista_kursow (@uzytkownik int)
returns table
as
begin
    return (
        select u.imie, u.nazwisko, k.id_kurs, k.nazwa, k.data_rozpoczecia, k.data_zakonczenia, k.maks_liczba_uczestnikow
        from kursy k
        join kursy_uczestnicy ku on k.id_kurs = ku.id_kurs
        join uczestnicy u on ku.id_uczestnik = u.id_uczestnik
        where u.id_uczestnik = @uzytkownik
    )
end
-- ----------------------------------------
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
-- ----------------------------------------------------
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
-- ------------------------------------------------------
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
-- ------------------------------------------------------
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
