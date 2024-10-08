/*************  watki - wzajemne wykluczanie ***************
Funkcja tworzenia watku:
  pthread_create(&w, &atw, watek, (void*)par);
  w   	- obiekt watku
  atw 	- obiekt atrybutu watku (do ustawienia atrybutow tworzonego watku)
  watek - funkcja, która wykonuje się jako nowy wątek
  par   - parametr funkcji wątek

Funkcja wątku:
 void *fw(void *) - prototyp funkcji wątku
 Funkcje wątku działają współbieżnie (równolegle) po utworzeniu
 wątku (wywołanie pthread_create) w ramach tego samego procesu.
 Zmienne globalne programu są wspólne dla wszystkich wątków

**************************************************************/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>

/***************************** Ćwiczenie *************************************

Program zliczający liczbę cykli wykonywanych przez funkcje p i q

1) Uruchom kilka razy program i sprawdź wyniki
2) Ustal stałą MAXL na 10 i sprawdź wyniki
Pytanie:
Objaśnić, dlaczego program nie zawsze poprawnie zlicza liczbę cykli

3) Spróbuj poprawić funkcje wątku (p, q) w taki sposób, aby zmienna licznik
   zliczała poprawnie liczbę cykli wykonanych łącznie przez dwa wątki w
   pętlach for. Wolno zmieniać tylko funkcję (p, q)

******************************************************************************/

#define MAXL 100000000

double licznik = 0;

void* p(void* a) { // funkcja wątku (wątek)
    int i;
    double t = 0;

    for (i = 0; i < MAXL; i++) {
        t++;
    }
    licznik += t;

    return 0;
}

void* q(void* a) { // funkcja wątku (wątek)
    int i;
    double t = 0;

    for (i = 0; i < MAXL; i++) {
        t++;
    }
    licznik += t;

    return 0;
}

int main() {
    pthread_t w1, w2;

    pthread_create(&w1, 0, p, 0); // tworzy wątek dla funkcji p
    pthread_create(&w2, 0, q, 0); // tworzy wątek dla funkcji q

    pthread_join(w1, NULL);
    pthread_join(w2, NULL);

    printf("licznik=%.0lf\n", licznik);
    printf("\nkoniec procesu\n");

    return 0;
}

/***************************  ODPOWIEDŹ ********************************
Ćwiczenie 1
 - uruchomienie nr 1: licznik=112480637
 - uruchomienie nr 2: licznik=100858970
 - uruchomienie nr 3: licznik=105915016
 - uruchomienie nr 4: licznik=108733376
 - uruchomienie nr 5: licznik=105837645

Ćwiczenie 2 (MAXL = 10)
 - uruchomienie nr 1: licznik=20
 - uruchomienie nr 2: licznik=20
 - uruchomienie nr 3: licznik=20
 - uruchomienie nr 4: licznik=20
 - uruchomienie nr 5: licznik=20

OBJAŚNIENIE: w przypadku dużej ilości iteracji (wysoka wartość MAXL)
 w trakcie wykonywania wątków mogą być one przerywane i uruchamiane
 co może skutkować 'zgubieniem' części operacji i zmianą wyniku
 (wątek może wykonać pętlę np. do powtórzenia 10005 i przekazać zmienną
 krytyczną drugiemu wątkowi).

Ćwiczenie 3
 - zmienione funkcje p i q (linia 41 oraz 53)
************************************************************************/
