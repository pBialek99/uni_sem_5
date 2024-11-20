select * from kursy;
select * from uczestnicy;
select * from Kursy_Uczestnicy;

-- Funkcje
alter function lista_kursow (@uzytkownik int)
returns table
as
   return 
   (
   select u.imie, u.nazwisko, k.id_kurs, k.nazwa, k.data_rozpoczecia, k.data_zakonczenia, k.maks_liczba_uczestnikow
   from kursy k
   join kursy_uczestnicy ku on k.id_kurs = ku.id_kurs
   join uczestnicy u on ku.id_uczestnik = u.id_uczestnik
   where u.id_uczestnik = @uzytkownik
   )

select * from dbo.lista_kursow(1)

create function czas_trwania_kursu (@id int)
returns int
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

select dbo.czas_trwania_kursu(1) as czas_trwania

-- Widoki
create view lista_maili_kurs_sql
as
select u.email as maile_uczestnikow_kursu_sql 
from uczestnicy u
join kursy_uczestnicy ku on u.id_uczestnik = ku.id_uczestnik
where ku.id_kurs = 1

select * from lista_maili_kurs_sql

create view dane_kursantow
as
select u.id_uczestnik, u.imie, u.nazwisko, u.email, k.nazwa as kurs, ku.data_zapisu, datediff(day, ku.data_zapisu, k.data_zakonczenia) as dni_do_zakonczenia
from uczestnicy u
join kursy_uczestnicy ku on u.id_uczestnik = ku.id_uczestnik
join kursy k on ku.id_kurs = k.id_kurs

select * from dane_kursantow

-- Procedury
create procedure wprowadz_kurs (@nazwa varchar(50), @data_r date, @data_z date, @uczestnicy int)
as
insert into kursy 
(nazwa, data_rozpoczecia, data_zakonczenia, maks_liczba_uczestnikow)
values (@nazwa, @data_r, @data_z, @uczestnicy)
go

wprowadz_kurs 'jakiskurs', '2019-11-01', '2022-11-01', 30
select * from kursy 

create procedure zmien_status_kursanta
(@id int, @nowy_status varchar(50))
as
update kursy_uczestnicy
set status = @nowy_status
where id_uczestnik = @id
go
