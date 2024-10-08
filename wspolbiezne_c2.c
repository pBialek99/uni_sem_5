/*************  kontrola liczby wątków - semafory **************
Funkcja tworzenia wątku:
  pthread_create(&w, &atw, watek,(void*)par);
  w   	- obiekt wątku
  atw 	- obiekt atrybutu wątku (do ustawienia atrybutów tworzonego wątku)
  watek - funkcja która wykonuje się jako nowy wątek
  par   - parametr funkcji wątku

Funkcja wątku:
 void *fw( void *) - prototyp funkcji wątku
 Funkcje wątku działają współbieżnie (równolegle) po utworzeniu
 wątku (wywołanie pthread_create) w ramach tego samego procesu.
 Zmienne globalne programu są wspólne dla wszystkich wątków

**************************************************************/



#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>


/******************************* Ćwiczenie *******************************
Program pokazuje różnicę między wątkiem trwałym a ulotnym

- tworzenie wątków trwałych odbywa się z atrybutem PTHREAD_CREATE_JOINABLE
- tworzenie wątków ulotnych odbywa się z atrybutem PTHREAD_CREATE_DETACHED

1) uruchom program, w którym tworzone są wątki trwałe
2) uruchom program, w którym tworzone są wątki ulotne

Objaśnić różnicę w działaniu programu w wersjach (1) i (2)


Ważne:
Wątków trwałych można tworzyć tylko ograniczoną liczbę mimo
że czas życia ich jest tutaj bardzo krótki (wykonują tylko dwie instrukcje).
Problem polega na tym, że dla wątków trwałych w odróżnieniu od wątków ulotnych
zasoby nie są automatycznie zwalniane po zakończeniu ich działania.
Aby zasoby zakończonego wątku zostały zwolnione, inny działający wątek (najlepiej główny)
powinien wywołać funkcję pthread_join. W tym przypadku funkcja pthread_join
nie jest wywoływana. Stąd duża liczba trwałych wątków musi w końcu wyczerpać
zasoby systemu i następne wątki nie będą już tworzone.
W przypadku wątku ulotnego zasoby są automatycznie zwalniane
po zakończeniu działania takiego wątku.

Zwróć uwagę:
a) jak jest przekazywana wartość całkowita do funkcji wątku.
b) jak ustalić atrybut tworzonego wątku

********************************************/



long licznik=0;



void* p (void* l) { // funkcja wątku (wątek)

    long n=*(long *)l;

    printf("wątek %ld\n",n);

    return 0;
}



int main () {
    pthread_t w;
    pthread_attr_t atrybut;
    pthread_attr_init(&atrybut); // inicjalizuje obiekt atrybutu dla wątku

    pthread_attr_setdetachstate(&atrybut,PTHREAD_CREATE_JOINABLE); // ustawia atrybut wątek trwały
//    pthread_attr_setdetachstate(&atrybut,PTHREAD_CREATE_DETACHED); // ustawia atrybut wątek ulotny


    do  {

        licznik++;

//        pthread_join(w,NULL);
    }  while (pthread_create(&w, &atrybut, p,(void*)&licznik)==0);

    printf("\nkoniec procesu\n");



    return 0;
}

/***************************  ODPOWIEDŹ ********************************
Ćwiczenie 1 -> w przypadku wykonywania programu, w którym są wątki trwałe:
 System zapycha się i zaczyna działać 'wolniej' ponieważ nie są zwalniane
 zasoby przy użyciu pthread_join.

Ćwiczenie 2 -> w przypadku wykonywania programu, w którym są wątki ulotne:
 System nie zapucha się i jego działanie nie spowalnia. Zasoby przydzielone
 do wątków, które już się wykonały zostają automatycznie zwolnione
 bez potrzeby wywoływania dla każdego wątku pthread_join. Lepsza stabilność
 programu i większe bezpieczeństwo.

Uwaga 'a' -> wartość całkowita przekazywana jest w funkcji 'p' przez
 wskaźnik nieokreślonego typu, a następnie w samej funkcji jest rzutowana
 na typ wskaźnika do typu 'long'

Uwaga 'b' -> ustalanie atrybutu tworzonego wątku odbywa się przez
 stworzenie zmiennej 'atrybut' struktury 'pthread_attr_t',
 inicjalizację go przez 'pthread_attr_init(...)'
 a następnie ustalenie trybu na trwały lub ulotny
************************************************************************/
