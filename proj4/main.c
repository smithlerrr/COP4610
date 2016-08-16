#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <signal.h>

typedef int buffer_item;
typedef int SIG;
#define BUFFER_SIZE 5
#define true 1
#define false 0

/* Declare the buffer */
buffer_item buffer[BUFFER_SIZE];

/* Declare the mutex and semaphores */
pthread_mutex_t mutex;
sem_t empty;
sem_t full;

/* counter to keep track of buffer size */
int count;

/* first and last pointers to implement circular queue */
int first;
int last;

/* SIGNAL FLAG FOR DEFERRED CANCELLATION */
SIG SIGNAL; 

/* Signal Handler function */
void
sig_hand (SIG s) {
  if (s == SIGINT) {
    printf("Finishing up...\n");
    SIGNAL = true;
  }
}

/* insert item into buffer
return 0 if successful, otherwise
return -1 indicating an error condition */
int
insert_item (buffer_item item)
{
  if (count < BUFFER_SIZE) {
    buffer[last] = item;
    //printf("added item at index %d\n", last);
    count++;

    last = (last + 1) % BUFFER_SIZE;

    return 0;
  }
  else
    return -1;
}


/* remove an object from buffer
placing it in item
return 0 if successful, otherwise
return -1 indicating an error condition */
int
remove_item (buffer_item *item)
{
  if (count > 0) {
    *item = buffer[first];
    //printf("removed item at index %d\n", first);
    count--;

    first = (first + 1) % BUFFER_SIZE;

    return 0;
  }
  else
    return -1;
}

void *
producer (void *param)
{
  buffer_item item;

  while (true) {
    signal(SIGINT, sig_hand);

    /* sleep for a random period of time */
    usleep( (rand() % 1000000) + 1);

    /* generate a random number */
    item = rand();

    sem_wait(&empty);
    pthread_mutex_lock(&mutex);
    

    if ( insert_item(item) )
      fprintf(stderr, "producer report error condition\n");
    else
      printf("producer produced %d\n",item);

    pthread_mutex_unlock(&mutex);
    sem_post(&full);
  }

}

void *
consumer (void *param)
{
  buffer_item item;

  while (true)
  {
    signal(SIGINT, sig_hand);

    /* sleep for a random period of time */
    usleep( (rand() % 1000000) + 1);

    sem_wait(&full);
    pthread_mutex_lock(&mutex);

    if ( remove_item(&item) )
      fprintf(stderr, "consumer report error condition\n");
    else
      printf("consumer consumed %d\n",item);

    pthread_mutex_unlock(&mutex);
    sem_post(&empty);

    // if SIGINT is caught break out of infinite loop
    if (SIGNAL)
      break;
  }
}

int
main (int argc, char *argv[])
{
/* 1. Get command line arguments argv[1],argv[2],argv[3] */
  if (argc != 4) {
    fprintf(stderr, "wrong number of arguments\n");
    return -1;
  }

  /*
   * convert argv's to ints and create thread ids.
   * argv[1] is the amount of time to sleep before terminating
   * argv[2] is the number of producer threads
   * argv[3] is the number of consumer threads
   */
  int s_time = atoi( argv[1] );  
  int p_num = atoi( argv[2] );  
  int c_num = atoi( argv[3] );


/* 2. Initialize buffer */
  count = 0;
  first = 0;
  last = 0;
  SIGNAL = false;

  // Init the mutex
  pthread_mutex_init( &mutex, NULL );
  sem_init( &empty, 0, BUFFER_SIZE );
  sem_init( &full, 0, 1 );


/* 3. Create producer thread(s) */
  pthread_t p_tid[p_num];
  pthread_attr_t p_attr[p_num];

  /*
   * Initialise the threads and thread attributes
  */
  int i;
  for (i = 0; i < p_num; ++i) {
    pthread_attr_init( &p_attr[i] );
    pthread_create( &p_tid[i], &p_attr[i], producer, NULL );
  }

/* 4. Create consumer thread(s) */
  pthread_t c_tid[c_num];
  pthread_attr_t c_attr[c_num];

  for (i = 0; i < c_num; ++i) {
    pthread_attr_init( &c_attr[i] );
    pthread_create( &c_tid[i], &c_attr[i], consumer, NULL );
  }

/* Wait for Threads to exit */
  for (i = 0; i < p_num; ++i)
    pthread_join( c_tid[i], NULL );

  for (i = 0; i < c_num; ++i)
    pthread_join( c_tid[i], NULL );

/* 5. Sleep */
  sleep(s_time);

/* 6. Exit */
  return 0;
}