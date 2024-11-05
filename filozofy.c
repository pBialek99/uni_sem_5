#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define F 5

sem_t widelce[F];

void *filozof(void *arg) {
    int f = *(int *)arg;

    while (1) {
        printf("Filozof %d myśli\n", f + 1);
        usleep(1000 * (rand() % 500 + 500));

        printf("Filozof %d jest głodny\n", f + 1);

        int left = f;
        int right = (f + 1) % F;

        if (left > right) {
            int temp = left;
            left = right;
            right = temp;
        }

        sem_wait(&widelce[left]);
        sem_wait(&widelce[right]);

        printf("Filozof %d je\n", f + 1);
        usleep(1000 * (rand() % 500 + 500));

        sem_post(&widelce[left]);
        sem_post(&widelce[right]);

        printf("Filozof %d skończył jeść.\n", f + 1);
    }

    return NULL;
}

void *finish(void *arg) {
    sleep(30);
    exit(0);
}

int main() {
    pthread_t filozofowie[F];
    pthread_t kontroler;
    int ids[F];

    for (int i = 0; i < F; i++) {
        sem_init(&widelce[i], 0, 1);
    }

    pthread_create(&kontroler, NULL, finish, NULL);

    for (int i = 0; i < F; i++) {
        ids[i] = i;
        pthread_create(&filozofowie[i], NULL, filozof, &ids[i]);
    }

    for (int i = 0; i < F; i++) {
        pthread_join(filozofowie[i], NULL);
    }

    for (int i = 0; i < F; i++) {
        sem_destroy(&widelce[i]);
    }

    return 0;
}
