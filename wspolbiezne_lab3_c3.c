#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define ITER 10
int x;
pthread_mutex_t mutex;
sem_t s_p, s_q, s_r;

// przypisywanie x
void* p(void* arg) {
    for (int i = 1; i <= ITER; i++) {
        sem_wait(&s_p);
        pthread_mutex_lock(&mutex);
        x = i;
        pthread_mutex_unlock(&mutex);

        if (x % 2 != 0) {
            sem_post(&s_q);
        } else {
            sem_post(&s_r);
        }
    }
    return NULL;
}

// nieparzyste
void* q(void* arg) {
    for (int i = 1; i <= ITER / 2; i++) {
        sem_wait(&s_q);
        pthread_mutex_lock(&mutex);
        printf("Q -> %d\n", x);
        pthread_mutex_unlock(&mutex);
        sem_post(&s_p);
    }
    return NULL;
}

// parzyste
void* r(void* arg) {
    for (int i = 1; i <= ITER / 2; i++) {
        sem_wait(&s_r);
        pthread_mutex_lock(&mutex);
        printf("R -> %d\n", x);
        pthread_mutex_unlock(&mutex);
        sem_post(&s_p);
    }
    return NULL;
}

int main() {
    pthread_t p_t, q_t, r_t;

    pthread_mutex_init(&mutex, NULL);
    sem_init(&s_p, 0, 1);
    sem_init(&s_q, 0, 0);
    sem_init(&s_r, 0, 0);

    pthread_create(&p_t, NULL, p, NULL);
    pthread_create(&q_t, NULL, q, NULL);
    pthread_create(&r_t, NULL, r, NULL);

    pthread_join(p_t, NULL);
    pthread_join(q_t, NULL);
    pthread_join(r_t, NULL);

    pthread_mutex_destroy(&mutex);
    sem_destroy(&s_p);
    sem_destroy(&s_q);
    sem_destroy(&s_r);

    return 0;
}
